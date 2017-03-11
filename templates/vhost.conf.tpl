# {{ ansible_managed }}

<VirtualHost *:{{ item.port | default('80') }}>
    ServerName {{ item.name }}
    {% if item.server_alias is defined %}
ServerAlias {% for alias in item.server_alias %}{{ alias }} {% endfor %}
    {% endif %}

    ServerAdmin {{ item.server_admin | default('infraestrutura@muxi.com.br') }}

    DocumentRoot {{ item.document_root | default(apache_document_root + '/' + item.name) }}

    <Directory {{ item.document_root | default(apache_document_root + '/' + item.name) }}>
    {% if item.directory_options is defined %}
{{ item.directory_options }}
    {% else %}
        AllowOverride All
        Options -Indexes +FollowSymLinks
	Require all granted
    {% endif %}
    </Directory>

    {% if item.custom_options is defined %}
{{ item.custom_options }}
    {% endif %}

    {% if item.mod_jk_enabled is defined %}
    {% for worker in item.mod_jk_workers %}
JkMount "{{ worker.path }}" "{{ worker.name }}"
    {% endfor %}
    {% endif %}

    {% if item.mod_wsgi_enabled is defined %}
WSGIDaemonProcess {{ item.mod_wsgi_daemon_process }} processes={{ item.mod_wsgi_process_number }} threads={{ item.mod_wsgi_threads_number }} python-path={{ item.document_root }}
    WSGIProcessGroup {{ item.mod_wsgi_daemon_process }}
    WSGIScriptAlias {{ item.mod_wsgi_script_alias }} {{ item.document_root }}/{{ item.mod_wsgi_script }} process-group={{ item.mod_wsgi_process_group }}
    {% endif %}

    {% if item.mod_ssl_enabled is defined %}
SSLEngine on
    SSLProtocol all -SSLv2
    SSLCertificateFile {{ certificates_destination }}/{{ item.name}}/{{ item.mod_ssl_certificate_file }}
    SSLCertificateKeyFile {{ certificates_destination }}/{{ item.name }}/{{ item.mod_ssl_certificate_key }}
    {% endif %}

    CustomLog {{ apache_log_directory }}/{{ item.name }}_access.log common
    ErrorLog {{ apache_log_directory }}/{{ item.name }}_error.log

    <Location "/server-status">
        SetHandler server-status
	Allow from localhost
    </Location>
</VirtualHost>

{% if item.mod_ssl_redirect_http is defined %}
<VirtualHost *:{{ item.port | default('443') }}>
    ServerName {{ item.name }}

    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]
</VirtualHost>
{% endif %}
