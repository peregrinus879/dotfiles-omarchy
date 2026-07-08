# Maintenance automation for dotfiles-omarchy. Run from the repo root on the Omarchy machine.
# The package list here is the single source of truth for the stow command sets.

SHELL := /bin/bash
PACKAGES := bash hypr yazi

.PHONY: help stow unstow dry-run restow verify clean recover lint

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
	@echo "  verify    Check symlinks and bash syntax"
	@echo "  clean     Remove files that would conflict with stow (README Prepare steps)"
	@echo "  recover   Re-apply after omarchy-reinstall-configs (clean + restow)"
	@echo "  lint      ShellCheck over the bash package (.shellcheckrc holds the disable list)"

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

# Stow may tree-fold a parent directory (e.g. ~/.config/yazi) into a single
# directory symlink, so per-file "test -L" checks false-negative. Compare
# resolved paths instead: linked is linked, folded or not.
verify:
	@fail=0; \
	for pair in "$$HOME/.bashrc=bash/.bashrc" \
	  "$$HOME/.config/hypr/bindings.conf=hypr/.config/hypr/bindings.conf" \
	  "$$HOME/.config/yazi/yazi.toml=yazi/.config/yazi/yazi.toml"; do \
	  target="$${pair%%=*}"; src="$${pair##*=}"; \
	  if [[ "$$(readlink -f "$$target")" == "$$(readlink -f "$$src")" ]]; then \
	    echo "ok:   $$target resolves into the repo"; \
	  else \
	    echo "FAIL: $$target does not resolve into the repo"; fail=1; \
	  fi; \
	done; \
	if bash -n bash/.bashrc; then echo "ok:   bash -n bash/.bashrc"; else echo "FAIL: bash -n bash/.bashrc"; fail=1; fi; \
	if command -v hyprctl > /dev/null && [[ -n "$${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then \
	  errs="$$(hyprctl configerrors)"; \
	  if [[ -z "$$errs" || "$$errs" == *"no errors"* ]]; then echo "ok:   no hyprland config errors"; \
	  else echo "FAIL: $$errs"; fail=1; fi; \
	fi; \
	exit $$fail

clean:
	-rm -f ~/.bashrc ~/.config/hypr/bindings.conf ~/.config/yazi/yazi.toml

recover: clean restow

lint:
	shellcheck -s bash bash/.bashrc
	@echo "ok:   shellcheck clean"
