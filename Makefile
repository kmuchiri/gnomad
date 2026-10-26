PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share/gnomad

.PHONY: all install uninstall bundle clean test

all:
	@echo "gnomad build system"
	@echo ""
	@echo "Available targets:"
	@echo "  make install        Install gnomad to $(PREFIX) (use PREFIX=~/.local for user install)"
	@echo "  make uninstall      Uninstall gnomad from $(PREFIX)"
	@echo "  make bundle         Generate standalone single-file binary in dist/gnomad"
	@echo "  make clean          Clean build artifacts"
	@echo ""

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(DATADIR)
	install -m 755 gnomad $(DESTDIR)$(BINDIR)/gnomad
	cp -r cli utils $(DESTDIR)$(DATADIR)/
	rm -rf $(DESTDIR)$(DATADIR)/builtin-profiles
	cp -r profiles $(DESTDIR)$(DATADIR)/builtin-profiles
	chmod -R 755 $(DESTDIR)$(DATADIR)/cli $(DESTDIR)$(DATADIR)/utils

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/gnomad
	rm -rf $(DESTDIR)$(DATADIR)/cli $(DESTDIR)$(DATADIR)/utils $(DESTDIR)$(DATADIR)/builtin-profiles
	-rmdir $(DESTDIR)$(DATADIR) 2>/dev/null || true

bundle:
	bash scripts/bundle.sh

clean:
	rm -rf dist
