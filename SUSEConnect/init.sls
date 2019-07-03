---
{% set regcode = salt['pillar.get']('SUSEConnect:regcode', {}) %}

SUSEConnect_register:
  cmd.run:
    - name: SUSEConnect -r {{regcode}}
    - creates: /etc/zypp/credentials.d/SCCcredentials

{% for product_obj in salt['pillar.get']('SUSEConnect:products', []) %}
{% set productregcode = None %}
{% if not product_obj %}{# in case product_obj == [] #}
{% continue %}
{% elif product_obj is mapping %}
{% set product = product_obj.get('path') %}
{% set productregcode = product_obj.get('regcode') %}
{% else %}
{% set product = product_obj %}
{% endif %}
{% set productname = product.split('/')[0] %}

SUSEConnect_register_product_{{product}}:
  cmd.run:
{% if productregcode !=  None %}
    - name: SUSEConnect -p {{product}} -r {{productregcode}}
{% else %}
    - name: SUSEConnect -p {{product}}
{% endif %}
    - creates: /etc/products.d/{{productname}}.prod
{% endfor %}
