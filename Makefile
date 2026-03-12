SERVICE_NAME=monitoring-stack
USER_SYSTEMD_DIR=$(HOME)/.config/systemd/user
SCRIPT_SRC=./deploy/start-monitoring.sh
SCRIPT_DST=/opt/monitoring/start-monitoring.sh
SERVICE_SRC=./deploy/monitoring-stack.service
SERVICE_DST=$(USER_SYSTEMD_DIR)/monitoring-stack.service

.PHONY: install create-script create-service reload enable start status linger

install: linger create-script create-service reload enable

linger:
	sudo loginctl enable-linger $(USER)

create-script:
	sudo install -d /opt/monitoring
	sudo install -m 0755 $(SCRIPT_SRC) $(SCRIPT_DST)

create-service:
	mkdir -p $(USER_SYSTEMD_DIR)
	install -m 0644 $(SERVICE_SRC) $(SERVICE_DST)

reload:
	systemctl --user daemon-reload

enable:
	systemctl --user enable $(SERVICE_NAME)

start:
	systemctl --user start $(SERVICE_NAME)

status:
	systemctl --user status $(SERVICE_NAME)
