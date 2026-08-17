# Maintenance automation for dotfiles-omarchy. Run from the repo root on the Omarchy machine.
# The package list here is the single source of truth for the stow command sets.

SHELL := /bin/bash
PACKAGES := bash hypr nvim yazi

# Twin files are byte-identical with dotfiles-wsl, synced manually; verify
# fails on drift so the copies cannot silently diverge. Paths are repo-relative
# and identical in both repos.
SIBLING := $(HOME)/Projects/repos/dotfiles/dotfiles-wsl
TWIN_SPECS := nvim/.config/nvim/lua/plugins/obsidian.lua \
  nvim/.config/nvim/lua/plugins/render-markdown.lua \
  bash/.config/bash/functions/dw \
  yazi/.config/yazi/yazi.toml

.PHONY: help stow unstow dry-run restow verify clean recover lint

# recover's prerequisites (clean, restow) must run in order, never concurrently.
.NOTPARALLEL:

# Hyprland auto-reloads on config changes and caches an error if a reload
# lands while a sourced file is mid-swap (as during a restow). Force a clean
# reload after any stow operation that ends in a linked state, but only when
# running inside a Hyprland session.
define hypr_reload
@if command -v hyprctl > /dev/null && [[ -n "$${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then \
  hyprctl reload > /dev/null; sleep 1; errs="$$(hyprctl configerrors)"; \
  if [[ -z "$$errs" || "$$errs" == *"no errors"* ]]; then \
    echo "ok:   hyprland reloaded, no config errors"; \
  else \
    echo "$$errs"; exit 1; \
  fi; \
else \
  echo "note: hyprland session not detected, skipped hyprctl reload"; \
fi
endef

help:
	@echo "Targets:"
	@echo "  stow      Stow all packages into ~"
	@echo "  unstow    Remove all package symlinks"
	@echo "  dry-run   Preview stow actions without making changes"
	@echo "  restow    Re-stow after repo content changes"
	@echo "  verify    Check symlinks, bash syntax, Lua syntax, TOML validity, and twin-file sync"
	@echo "  clean     Guarded stow preparation: owned links and clobber artifacts only (scripts/prepare-stow.sh)"
	@echo "  recover   Re-apply after omarchy-reinstall-configs (clean + restow)"
	@echo "  lint      ShellCheck over the bash package and scripts/ (.shellcheckrc holds the disable list)"

stow:
	stow -v -t ~ $(PACKAGES)
	$(hypr_reload)

unstow:
	stow -D -v -t ~ $(PACKAGES)

dry-run:
	stow -v -n -t ~ $(PACKAGES)

restow:
	stow -R -v -t ~ $(PACKAGES)
	$(hypr_reload)

# Symlink pairs are derived from the package files git sees (tracked plus
# untracked): stripping the leading package name maps each file to its stow
# target, so every package file is checked, including one being added in the
# working tree. Stow may tree-fold a parent directory (e.g. ~/.config/yazi)
# into a single directory symlink, so per-file "test -L" checks false-negative.
# Compare resolved paths instead: linked is linked, folded or not.
# Fail closed: a missing verifier binary must fail the run, not skip a check.
# A missing sibling clone skips the twin checks; an existing clone missing a
# twin file is drift and fails.
verify:
	@for tool in readlink cmp luac git python3; do \
	  command -v "$$tool" > /dev/null || { echo "FAIL: required verifier '$$tool' is missing"; exit 1; }; \
	done
	@fail=0; \
	for src in $$(git ls-files --cached --others --exclude-standard -- $(PACKAGES)); do \
	  target="$$HOME/$${src#*/}"; \
	  if [[ "$$(readlink -f "$$target")" == "$$(readlink -f "$$src")" ]]; then \
	    echo "ok:   $$target resolves into the repo"; \
	  else \
	    echo "FAIL: $$target does not resolve into the repo"; fail=1; \
	  fi; \
	done; \
	for f in bash/.bashrc bash/.config/bash/functions/*; do \
	  if bash -n "$$f"; then echo "ok:   bash -n $$f"; else echo "FAIL: bash -n $$f"; fail=1; fi; \
	done; \
	for f in hypr/.config/hypr/*.lua; do \
	  if luac -p "$$f" > /dev/null; then echo "ok:   luac -p $$f"; \
	  else echo "FAIL: luac -p $$f"; fail=1; fi; \
	done; \
	if python3 -c 'import tomllib,sys; tomllib.load(open(sys.argv[1],"rb"))' yazi/.config/yazi/yazi.toml 2> /dev/null; then \
	  echo "ok:   yazi.toml parses as TOML"; \
	else \
	  echo "FAIL: yazi.toml is not valid TOML"; fail=1; \
	fi; \
	if command -v hyprctl > /dev/null && [[ -n "$${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then \
	  errs="$$(hyprctl configerrors)"; \
	  if [[ -z "$$errs" || "$$errs" == *"no errors"* ]]; then echo "ok:   no hyprland config errors"; \
	  else echo "FAIL: $$errs"; fail=1; fi; \
	fi; \
	if [[ ! -d "$(SIBLING)" ]]; then \
	  echo "note: dotfiles-wsl clone not found, skipped twin checks"; \
	else \
	  for f in $(TWIN_SPECS); do \
	    twin="$(SIBLING)/$$f"; \
	    if [[ ! -e "$$twin" ]]; then echo "FAIL: twin missing in dotfiles-wsl: $$f"; fail=1; \
	    elif cmp -s "$$f" "$$twin"; then echo "ok:   $$f matches the dotfiles-wsl twin"; \
	    else echo "FAIL: $$f drifted from the dotfiles-wsl twin"; fail=1; fi; \
	  done; \
	fi; \
	exit $$fail

clean:
	@bash scripts/prepare-stow.sh

recover: clean restow

lint:
	shellcheck -s bash bash/.bashrc bash/.config/bash/functions/* scripts/*.sh
	@echo "ok:   shellcheck clean"
