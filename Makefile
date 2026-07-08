# Maintenance automation for dotfiles-omarchy. Run from the repo root on the Omarchy machine.
# The package list here is the single source of truth for the stow command sets.

SHELL := /bin/bash
PACKAGES := bash hypr yazi

.PHONY: help stow unstow dry-run restow verify clean recover

help:
	@echo "Targets:"
	@echo "  stow      Stow all packages into ~"
	@echo "  unstow    Remove all package symlinks"
	@echo "  dry-run   Preview stow actions without making changes"
	@echo "  restow    Re-stow after repo content changes"
	@echo "  verify    Check symlinks and bash syntax"
	@echo "  clean     Remove files that would conflict with stow (README Prepare steps)"
	@echo "  recover   Re-apply after omarchy-reinstall-configs (clean + restow)"

stow:
	stow -v -t ~ $(PACKAGES)

unstow:
	stow -D -v -t ~ $(PACKAGES)

dry-run:
	stow -v -n -t ~ $(PACKAGES)

restow:
	stow -R -v -t ~ $(PACKAGES)

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
	exit $$fail

clean:
	-rm -f ~/.bashrc ~/.config/hypr/bindings.conf ~/.config/yazi/yazi.toml

recover: clean restow
