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

# Show logs
logs *SERVICE:
    ssh -t tarkah@10.0.2.20 -- docker compose -f ./deploy/docker-compose.yml logs --follow {{SERVICE}}

# Ping hosts using provided pattern
ping pattern="all":
    ansible -i playbook/inventory -m ping {{pattern}}
