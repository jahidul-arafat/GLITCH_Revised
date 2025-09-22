# Security issues cookbook
cookbook_name = 'security_issues'

# Hard-coded secrets
db_password = 'hardcoded123'
api_key = 'sk-1234567890abcdef'

user 'admin' do
  password 'admin'
  shell '/bin/bash'
  home '/home/admin'
  action :create
end

execute 'download_script' do
  command 'wget http://example.com/install.sh -O /tmp/install.sh'
  action :run
end

file '/etc/app/config' do
  content <<-EOH
    database_password: #{db_password}
    api_secret: #{api_key}
    bind_address: 0.0.0.0
    ssl_enabled: false
  EOH
  mode '0644'
  action :create
end

execute 'weak_crypto' do
  command 'echo "password" | md5sum > /tmp/hash.txt'
  action :run
end

service 'httpd' do
  supports :status => true, :restart => true
  action [:enable, :start]
end