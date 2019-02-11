{%- if servers is undefined or servers == '*' or servers == '' -%}
    {% set servers = groups.all|list %}
{%- else -%}
    {% set servers = groups.all|list|intersect(servers.split(',')|list) %}
{%- endif -%}

{
    {% if consul_bootstrap|bool and inventory_hostname in servers -%}
    "bootstrap_expect": {{servers|count}},
    {% endif -%}
    "retry_join": [{% for server in servers %}"{{hostvars[server].privip}}"{% if not loop.last %},{% endif %}{% endfor %}],
    {% if inventory_hostname in servers -%}
    "server": true,
    "watches": [
      {
        "type": "checks",
        "handler": "/usr/bin/consul-alerts"
      }
    ],
    {% else -%}
    "server": false,
    {% endif -%}
    "client_addr": "{{consul_client_addr}}",
    "advertise_addr": "{{privip}}",
    "node_name": "{{ansible_hostname}}",
    "recursors": ["{{consul_recursor}}"],
    "ports": { "dns": {{consul_dns_port}} },
    {% if consul_ui|bool -%}
    "ui": true,
    {% else -%}
    "ui": false,
    {% endif -%}
    "leave_on_terminate": {{consul_leave_on_terminate}},
    "rejoin_after_leave": {{consul_rejoin_after_leave}},
    "datacenter": "{{consul_env}}",
    "data_dir": "{{consul_dir}}",
    "encrypt": "{{consul_key}}",
    "log_level": "{{consul_log_level}}",
    "enable_syslog": {{consul_enable_syslog}}
}
