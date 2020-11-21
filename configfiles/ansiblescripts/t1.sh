#!/bin/bash
set -o nounset -o pipefail -o errexit

# Load all variables from .env and export them all for Ansible to read
set -o allexport
source ../../.hlc.env
set -o allexport
exec ansible-playbook 01_configtxchg.yaml



         #when: '"abc3" in ORG_3'
         #when: org3check.stdout is search('ORG_3')
         #when: "'abc3' in ORG_3.org3check"
      #- shell: echo "I've got '{{ foo }}' and am not afraid to use it!"
      #    when: foo is defined
       #- name: localenvs
       #  debug:
       #   msg: "{{ ansible_env }}"


       #- name: filtering for org3
       #  tags: always
       #  set_fact:
       #    ORG_3: '{{ lookup("env", "ORG_3") }}'
       #  when: ORG_3|length > 0
       #  register: org3check
       #- name: Ansible when variable is empty example
       #  debug: 
       #    var: ORG_3.org3check 


       #- name: Ansible when variable is empty example1
       #  debug: 
       #    msg: var= "{{ lookup('env', 'ORG_3', 'HOME') }}"
       #    verbosity: 1

         #debug:
          # msg: "{{ var }}"
         #with_file:
          # - "ORG_3=abc3"
           #- "{{ org3check }}"       
         #when: org3check.stdout.ORG_3_C == Org3
         #when: {{ org3check.stdout }} | search("ORG_3")
         #when: '"ORG_3" in {{ org3check.stdout }}'
         #when: org3check.stdout.find("ORG_3_C") is defined
         #when: '"value" in variable1'

       #- name: Conditionally decide to load in variables into 
       #  include_vars:
       #    file: ../../.hlc.env
       #    name: ORG_3
       #  #when: ORG_3 != 0
       #  #shell: cat ./../.hlc.env | grep ORG_3 
       #  #when: ORG_3|length > 0
       #  register: org3check