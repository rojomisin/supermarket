# # Supermarket configuration
#
# Attributes here will be applied to configure the application and the services
# it uses.
#
# Most of the attributes in this file are things you will not need to ever
# touch, but they are here in case you need them.
#
# A `supermarket-ctl reconfigure` should pick up any changes made here.

# ## Common Use Cases
#
# These are examples of things you may want to do, depending on how you set up
# the application to run.
#
# ### Chef Identity
#
# You will have to set this up in order to log into Supermarket and upload
# cookbooks with your Chef server keys.
#
# See the "Chef OAuth2 Settings" section below
#
# ### Using an external Postgres database
#
# Disable the provided Postgres instance and connect to your own:
#
# default['supermarket']['postgresql']['enable'] = false
# default['supermarket']['database']['user'] = 'my_db_user_name'
# default['supermarket']['database']['name'] = 'my_db_name''
# default['supermarket']['database']['host'] = 'my.db.server.address'
# default['supermarket']['database']['port'] = 5432
#
# ### Using an external Redis server
#
# Disable the provided Redis server and use on reachable on your network:
#
# default['supermarket']['redis']['enable'] = false
# default['supermarket']['redis_url'] = 'redis://my.redis.host:6379/0/mydbname
#
# ### Bring your on SSL certificate
#
# If a key and certificate are not provided, a self-signed certificate will be
# generated. To use your own, provide the paths to them and ensure SSL is
# enabled in Nginx:
#
# default['supermarket']['nginx']['port'] = 443
# default['supermarket']['nginx']['protocol'] = 'https'
# default['supermarket']['ssl']['certificate'] = '/path/to/my.crt'
# default['supermarket']['ssl']['certificate_key'] = '/path/to/my.key'

# ## Top-level attributes
#
# These are used by the other items below. More app-specific top-level
# attributes are further down in this file.

# The fully qualified domain name. Will use the node's fqdn if nothing is
# specified.
default['supermarket']['fqdn'] = node['fqdn']

default['supermarket']['config_directory'] = '/etc/supermarket'
default['supermarket']['install_directory'] = '/opt/supermarket'
default['supermarket']['app_directory'] = "#{node['supermarket']['install_directory']}/embedded/service/supermarket"
default['supermarket']['log_directory'] = '/var/log/supermarket'
default['supermarket']['var_directory'] = '/var/opt/supermarket'
default['supermarket']['user'] = 'supermarket'
default['supermarket']['group'] = 'supermarket'

# ## Enterprise
#
# The "enterprise" cookbook provides recipes and resources we can use for this
# app.

default['enterprise']['name'] = 'supermarket'

# Enterprise uses install_path internally, but we use install_directory because
# it's more consistent. Alias it here so both work.
default['supermarket']['install_path'] = node['supermarket']['install_directory']

# An identifier used in /etc/inittab (default is 'SV'). Needs to be a unique
# (for the file) sequence of 1-4 characters.
default['supermarket']['sysvinit_id'] = 'SUP'

# ## Nginx

# These attributes control Supermarket-specific portions of the Nginx
# configuration and the virtual host for the Supermarket Rails app.
default['supermarket']['nginx']['enable'] = true
default['supermarket']['nginx']['port'] = 80
default['supermarket']['nginx']['protocol'] = 'http'
default['supermarket']['nginx']['directory'] = "#{node['supermarket']['var_directory']}/nginx"
default['supermarket']['nginx']['log_directory'] = "#{node['supermarket']['log_directory']}/nginx"
default['supermarket']['nginx']['log_rotation']['file_maxbytes'] = 104857600
default['supermarket']['nginx']['log_rotation']['num_to_keep'] = 10

# These attributes control the main nginx.conf, including the events and http
# contexts. Note that they are not scoped to 'supermarket', like most things
# here, because we're using the template from the community nginx cookbook
# (https://github.com/miketheman/nginx/blob/master/templates/default/nginx.conf.erb)
default['nginx']['user'] = node['supermarket']['user']
default['nginx']['group'] = node['supermarket']['group']
default['nginx']['dir'] = node['supermarket']['nginx']['directory']
default['nginx']['log_dir'] = node['supermarket']['nginx']['log_directory']
default['nginx']['pid'] = "#{node['supermarket']['nginx']['directory']}/nginx.pid"
default['nginx']['daemon_disable'] = true
default['nginx']['gzip'] = 'on'
default['nginx']['gzip_static'] = 'off'
default['nginx']['gzip_http_version'] = '1.0'
default['nginx']['gzip_comp_level'] = '2'
default['nginx']['gzip_proxied'] = 'any'
default['nginx']['gzip_vary'] = 'off'
default['nginx']['gzip_buffers'] = nil
default['nginx']['gzip_types'] = %w[
  text/plain
  text/css
  application/x-javascript
  text/xml
  application/xml
  application/rss+xml
  application/atom+xml
  text/javascript
  application/javascript
  application/json
]
default['nginx']['gzip_min_length'] = 1000
default['nginx']['gzip_disable'] = 'MSIE [1-6]\.'
default['nginx']['keepalive'] = 'on'
default['nginx']['keepalive_timeout'] = 65
default['nginx']['worker_processes'] = node['cpu'] && node['cpu']['total'] ? node['cpu']['total'] : 1
default['nginx']['worker_connections'] = 1024
default['nginx']['worker_rlimit_nofile'] = nil
default['nginx']['multi_accept'] = false
default['nginx']['event'] = nil
default['nginx']['server_tokens'] = nil
default['nginx']['server_names_hash_bucket_size'] = 64
default['nginx']['sendfile'] = 'on'
default['nginx']['access_log_options'] = nil
default['nginx']['error_log_options'] = nil
default['nginx']['disable_access_log'] = false
default['nginx']['default_site_enabled'] = false
default['nginx']['types_hash_max_size'] = 2048
default['nginx']['types_hash_bucket_size'] = 64
default['nginx']['proxy_read_timeout'] = nil
default['nginx']['client_body_buffer_size'] = nil
default['nginx']['client_max_body_size'] = '250m'
default['nginx']['default']['modules'] = []

# ## Postgres

default['supermarket']['postgresql']['enable'] = true
default['supermarket']['postgresql']['username'] = node['supermarket']['user']
default['supermarket']['postgresql']['data_directory'] = "#{node['supermarket']['var_directory']}/postgresql/9.3/data"

# ### Logs
default['supermarket']['postgresql']['log_directory'] = "#{node['supermarket']['log_directory']}/postgresql"
default['supermarket']['postgresql']['log_rotation']['file_maxbytes'] = 104857600
default['supermarket']['postgresql']['log_rotation']['num_to_keep'] = 10

# ### DB settings
default['supermarket']['postgresql']['checkpoint_completion_target'] = 0.5
default['supermarket']['postgresql']['checkpoint_segments'] = 3
default['supermarket']['postgresql']['checkpoint_timeout'] = '5min'
default['supermarket']['postgresql']['checkpoint_warning'] = '30s'
default['supermarket']['postgresql']['effective_cache_size'] = '128MB'
default['supermarket']['postgresql']['listen_address'] = '127.0.0.1'
default['supermarket']['postgresql']['max_connections'] = 350
default['supermarket']['postgresql']['md5_auth_cidr_addresses'] = ['127.0.0.1/32', '::1/128']
default['supermarket']['postgresql']['port'] = 15432
default['supermarket']['postgresql']['shared_buffers'] = "#{(node['memory']['total'].to_i / 4) / (1024)}MB"
default['supermarket']['postgresql']['shmmax'] = 17179869184
default['supermarket']['postgresql']['shmall'] = 4194304
default['supermarket']['postgresql']['work_mem'] = "8MB"

# ## Rails
#
# The Rails app for Supermarket
default['supermarket']['rails']['enable'] = true
default['supermarket']['rails']['port'] = 13000
default['supermarket']['rails']['log_directory'] = "#{node['supermarket']['log_directory']}/rails"
default['supermarket']['rails']['log_rotation']['file_maxbytes'] = 104857600
default['supermarket']['rails']['log_rotation']['num_to_keep'] = 10

# ## Redis

default['supermarket']['redis']['enable'] = true
default['supermarket']['redis']['bind'] = '127.0.0.1'
default['supermarket']['redis']['directory'] = "#{node['supermarket']['var_directory']}/redis"
default['supermarket']['redis']['log_directory'] = "#{node['supermarket']['log_directory']}/redis"
default['supermarket']['redis']['log_rotation']['file_maxbytes'] = 104857600
default['supermarket']['redis']['log_rotation']['num_to_keep'] = 10
default['supermarket']['redis']['port'] = 16379

# ## Runit

# This is missing from the enterprise cookbook
# see (https://github.com/opscode-cookbooks/enterprise-chef-common/pull/17)
default['runit']['svlogd_bin'] = "#{node['supermarket']['install_directory']}/embedded/bin/svlogd"

# ## Sidekiq
#
# Used for background jobs

default['supermarket']['sidekiq']['enable'] = true
default['supermarket']['sidekiq']['concurrency'] = 25
default['supermarket']['sidekiq']['log_directory'] = "#{node['supermarket']['log_directory']}/sidekiq"
default['supermarket']['sidekiq']['log_rotation']['file_maxbytes'] = 104857600
default['supermarket']['sidekiq']['log_rotation']['num_to_keep'] = 10
default['supermarket']['sidekiq']['timeout'] = 30

# ## SSL

default['supermarket']['ssl']['directory'] = '/var/opt/supermarket/ssl'

# This shouldn't be changed, but can be overriden in tests
default['supermarket']['ssl']['openssl_bin'] = "#{node['supermarket']['install_directory']}/embedded/bin/openssl"

# Paths to the SSL certificate and key files. If these are not provided we will
# attempt to generate a self-signed certificate and use that instead.
default['supermarket']['ssl']['certificate'] = nil
default['supermarket']['ssl']['certificate_key'] = nil

# These are used in creating a self-signed cert if you haven't brought your own.
default['supermarket']['ssl']['country_name'] = "US"
default['supermarket']['ssl']['state_name'] = "WA"
default['supermarket']['ssl']['locality_name'] = "Seattle"
default['supermarket']['ssl']['company_name'] = "My Supermarket"
default['supermarket']['ssl']['organizational_unit_name'] = "Operations"
default['supermarket']['ssl']['email_address'] = "you@example.com"

# ## Unicorn
#
# Settings for main Rails app Unicorn application server. These attributes are
# used with the template from the community Unicorn cookbook:
# https://github.com/opscode-cookbooks/unicorn/blob/master/templates/default/unicorn.rb.erb
#
# Full explanation of all options can be found at
# http://unicorn.bogomips.org/Unicorn/Configurator.html

default['supermarket']['unicorn']['name'] = 'supermarket'
default['supermarket']['unicorn']['copy_on_write'] = true
default['supermarket']['unicorn']['enable_stats'] = false
default['supermarket']['unicorn']['forked_user'] = node['supermarket']['user']
default['supermarket']['unicorn']['forked_group'] = node['supermarket']['group']
default['supermarket']['unicorn']['listen'] = ["127.0.0.1:#{node['supermarket']['rails']['port']}"]
default['supermarket']['unicorn']['pid'] = "#{node['supermarket']['var_directory']}/rails/run/unicorn.pid"
default['supermarket']['unicorn']['preload_app'] = true
default['supermarket']['unicorn']['worker_timeout'] = 15
default['supermarket']['unicorn']['worker_processes'] = node['nginx']['worker_processes']

# These are not used, but you can set them if needed
default['supermarket']['unicorn']['before_exec'] = nil
default['supermarket']['unicorn']['stderr_path'] = nil
default['supermarket']['unicorn']['stdout_path'] = nil
default['supermarket']['unicorn']['unicorn_command_line'] = nil
default['supermarket']['unicorn']['working_directory'] = nil

# These are defined a recipe to be specific things we need that you
# could change here, but probably should not.
default['supermarket']['unicorn']['before_fork'] = nil
default['supermarket']['unicorn']['after_fork'] = nil

# ## Database

default['supermarket']['database']['user'] = node['supermarket']['postgresql']['username']
default['supermarket']['database']['name'] = 'supermarket'
default['supermarket']['database']['host'] = node['supermarket']['postgresql']['listen_address']
default['supermarket']['database']['port'] = node['supermarket']['postgresql']['port']
default['supermarket']['database']['pool'] = node['supermarket']['sidekiq']['concurrency']

# ## App-specific top-level attributes
#
# These are used by Rails and Sidekiq. Most will be exported directly to
# environment variables to be used by the app.
#
# Items that are set to nil here and also set in the development environment
# configuration (https://github.com/opscode/supermarket/blob/master/.env) will
# use the value from the development environment. Set them to something other
# than nil to change them.

default['supermarket']['fieri_url'] = nil
default['supermarket']['fieri_key'] = nil
default['supermarket']['from_email'] = nil
default['supermarket']['github_access_token'] = nil
default['supermarket']['github_key'] = nil
default['supermarket']['github_secret'] = nil
default['supermarket']['google_analytics_id'] = nil
default['supermarket']['host'] = node['supermarket']['fqdn']
default['supermarket']['newrelic_agent_enabled'] = 'false'
default['supermarket']['newrelic_app_name'] = nil
default['supermarket']['newrelic_license_key'] = nil
default['supermarket']['port'] = node['supermarket']['nginx']['port']
default['supermarket']['protocol'] = node['supermarket']['nginx']['protocol']
default['supermarket']['pubsubhubbub_callback_url'] = nil
default['supermarket']['pubsubhubbub_secret'] = nil
default['supermarket']['redis_url'] = "redis://#{node['supermarket']['redis']['bind']}:#{node['supermarket']['redis']['port']}/0/supermarket"
default['supermarket']['sentry_url'] = nil

# ### Chef OAuth2 Settings
#
# These settings configure the service to talk to a Chef identity service.
#
# An Application must be created on the Chef server's identity service to do
# this. With the following in /etc/opscode/chef-server.rb:
#
#     oc_id['applications'] = { 'my_supermarket' => { 'redirect_uri' => 'https://my.supermarket.server.fqdn/auth/chef_oauth2/callback' } }
#
# Run `chef-server-ctl reconfigure`, then these values should available in
# /etc/opscode/oc-id-applications/my_supermarket.json.
#
# If you are using a self-signed certificate on your Chef server without a
# properly configured certificate authority, chef_oauth2_verify_ssl must be
# false.
default['supermarket']['chef_oauth2_app_id'] = nil
default['supermarket']['chef_oauth2_secret'] = nil
default['supermarket']['chef_oauth2_url'] = nil
default['supermarket']['chef_oauth2_verify_ssl'] = true

# ### CLA Settings
#
# These are used for the Contributor License Agreement features. You only need
# them if the cla and/or join_ccla features are enabled (see "Features" below.)
default['supermarket']['ccla_version'] = nil
default['supermarket']['cla_signature_notification_email'] = nil
default['supermarket']['cla_report_email'] = nil
default['supermarket']['curry_cla_location'] = nil
default['supermarket']['curry_success_label'] = nil
default['supermarket']['icla_location'] = nil
default['supermarket']['icla_version'] = nil
default['supermarket']['seed_cla_data'] = nil

# ### Features
#
# These control the feature flags that turn features on and off.
#
# Available features are:
#
# * announcement: TODO
# * cla: Enable the Contributor License Agreement features
# * fieri: Use the fieri service to report on cookbook quality (requires
#   fieri_url and fieri_key to be set.)
# * join_ccla: Enable joining of Corporate CLAs
# * tools: Enable the tools section
default['supermarket']['features'] = 'announcement,tools'

# ### S3 Settings
#
# If these are not set, uploaded cookbooks will be stored on the local
# filesystem (this means that running multiple application servers will require
# some kind of shared storage, which is not provided.)
#
# If these are set, cookbooks will be uploaded to the to the given S3 bucket
# using the provided credentials. A cdn_url can be used for an alias if the
# given S3 bucket is behind a CDN like CloudFront.
default['supermarket']['s3_access_key_id'] = nil
default['supermarket']['s3_bucket'] = nil
default['supermarket']['s3_secret_access_key'] = nil
default['supermarket']['cdn_url'] = nil

# ### SMTP Settings
#
# If none of these are set, the :sendmail delivery method will be used. Using
# the sendmail delivery method requires that a working mail transfer agent
# (usually set up with a relay host) be configured on this machine.
#
# SMTP will use the 'plain' authentication method.
default['supermarket']['smtp_address'] = nil
default['supermarket']['smtp_password'] = nil
default['supermarket']['smtp_port'] = nil
default['supermarket']['smtp_user_name'] = nil

# ### StatsD Settings
#
# If these are present, metrics can be reported to a StatsD server.
default['supermarket']['statsd_url'] = nil
default['supermarket']['statsd_port'] = nil
