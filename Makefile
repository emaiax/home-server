.PHONY: help install-server install-deployer deploy check-client-requirements test

CLIENT_REQUIRED_COMMANDS := op jq ansible-playbook
OP_ANSIBLE_INVENTORY_REF := op://homeserver/ansible/notesPlain

help:
	@echo "Available options:"
	@echo "	install-server      - Setup your home-server"
	@echo "	install-client      - Setup your deployer client"
	@echo "	deploy [TAGS=tags]  - Deploy your home-server"

check-client-requirements:
	@for cmd in $(CLIENT_REQUIRED_COMMANDS); do \
		command -v $$cmd >/dev/null || (echo "\nError: '$$cmd' is not installed.\nPlease install: $(CLIENT_REQUIRED_COMMANDS)\n" && exit 1); \
	done

install-server:
  # Add commands to install the server here
  # ...

install-client:
  # Add commands to install the deployer here
  # ...

deploy:
	@$(MAKE) check-client-requirements
	@$(eval TMP_FILE := $(shell mktemp -t "ansible-inventory" 2>/dev/null))
	@op read $(OP_ANSIBLE_INVENTORY_REF) --force --out-file $(TMP_FILE) > /dev/null
	@ansible-playbook setup.yml -i $(TMP_FILE) $(if $(TAGS), -t $(TAGS))

	@rm -f $$TMPDIR/ansible-*