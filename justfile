set dotenv-load := true
set export := true

[private]
default:
    @just -u --list

# Init repo
init:
    ansible-galaxy collection install -r playbook/requirements.yml
    ansible-galaxy role install -r playbook/requirements.yml

# Run setup
setup *ARGS:
    ansible-playbook -i playbook/inventory playbook/setup.yml {{ARGS}}

# Run deploy
deploy:
    ansible-playbook -i playbook/inventory playbook/deploy.yml

# Update dns
dns:
    ansible-playbook -i playbook/inventory playbook/dns.yml

# Show logs
logs *SERVICE:
    ssh -t 10.0.2.20 -- docker compose -f ./deploy/docker-compose.yml logs --follow {{SERVICE}}

# Exec
exec SERVICE CMD *ARGS:
    ssh -t 10.0.2.20 -- docker compose -f ./deploy/docker-compose.yml exec {{SERVICE}} {{CMD}} {{ARGS}}

# Bring service down
down *SERVICE:
    ssh -t 10.0.2.20 -- docker compose -f ./deploy/docker-compose.yml down {{SERVICE}}

# Ping hosts using provided pattern
ping pattern="all":
    ansible -i playbook/inventory -m ping {{pattern}}

# Show Wireguard QR for peer
show-wireguard peer="1":
    ssh -t 10.0.2.20 -- docker compose -f ./deploy/docker-compose.yml exec wireguard /app/show-peer {{peer}}
