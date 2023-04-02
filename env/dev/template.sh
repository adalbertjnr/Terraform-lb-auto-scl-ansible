#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
python3 -m pip install ansible
export PATH=$PATH:/home/ubuntu/.local/bin
tee -a playbook.yml > /dev/null << EOT
- hosts: localhost
  tasks:
  - name: Instalando o python3, virtualenv
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: true
  - name: Instalando dependencias com pip (Django e Django Rest)
    pip:
      virtualenv: /home/ubuntu/tcc/venv
      name:
        - django
        - djangorestframework
  - name: Verificando se projeto já existe
    stat:
      path: /home/ubuntu/tcc/setup/settings.py
    register: proj
  - name: Iniciando o projeto
    shell: '. /home/ubuntu/tcc/venv/bin/activate; django-admin startproject setup /home/ubuntu/tcc/'
    when: not proj.stat.exists
  - name: Alterando o hosts do settings
    lineinfile:
      path: /home/ubuntu/tcc/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
EOT
ansible-playbook playbook.yml