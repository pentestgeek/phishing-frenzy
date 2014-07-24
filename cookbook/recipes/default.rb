#
# Cookbook Name:: phishing-frenzy
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt::default"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby "1.9.3-p194" do
  global true
end

rbenv_gem "bundler"

include_recipe "apache2::default"

#enable custom template
template  "/etc/apache2/apache2.conf" do
  source  'apache2.conf.erb'
  owner   'root'
  group   node['apache']['root_group']
  mode    '0644'
end

#enable custom pf.conf
template  "/etc/apache2/pf.conf" do
  source  'pf.conf.erb'
  owner   'root'
  group   node['apache']['root_group']
  mode    '0644'
end

include_recipe "passenger_apache2::source"
include_recipe "passenger_apache2::mod_rails"


include_recipe "mysql::server"
include_recipe 'database::mysql'

user "pf_prod" do
  supports :manage_home => true
  comment "PF user"
  shell "/bin/bash"
  password "passwordyo123"
end

mysql_database node['phishing-frenzy']['database']['dbname'] do
  connection(
    :host => node['phishing-frenzy']['database']['host'],
    :username => node['phishing-frenzy']['database']['username'],
    :password => node['phishing-frenzy']['database']['password']
  )
  action :create
end

mysql_database_user node['phishing-frenzy']['database']['app']['username'] do
  connection(
    :host => node['phishing-frenzy']['database']['host'],
    :username => node['phishing-frenzy']['database']['username'],
    :password => node['phishing-frenzy']['database']['password']
  )
  password node['phishing-frenzy']['database']['app']['password']
  database_name node['phishing-frenzy']['database']['dbname']
  privileges [:all]
  host node['phishing-frenzy']['database']['host']
  action [:create, :grant]
end

git "/var/www/phishing-frenzy" do
  repository "https://github.com/pentestgeek/phishing-frenzy.git"
  revision "master"
  action :sync
end

directory "/var/www/phishing-frenzy/log/" do
  owner "root"
  group "root"
  mode "0666"
  action :create
end

file "/var/www/phishing-frenzy/log/production.log" do
  mode "0666"
  action :create
end

file "/etc/apache2/httpd.conf" do
  mode "0666"
  action :create
end

app_user = "root"
app_user2 = "pf_prod"

execute 'bundle install' do
  command "bundle install --system"
  cwd '/var/www/phishing-frenzy/'
end
execute 'bundle install' do
  command "bundle install --deployment"
  cwd '/var/www/phishing-frenzy/'
end

execute 'sudo chown -R www-data:www-data /var/www/phishing-frenzy/' do
end
execute 'sudo chmod a+rw /var/www/phishing-frenzy/public/templates/' do
end
execute 'sudo chmod o+rw /var/www/phishing-frenzy/public/uploads/' do
end

execute 'assests precompile' do
  command "cd /var/www/phishing-frenzy/ && RAILS_ENV=production bundle exec rake assets:precompile"
end

file "/var/www/phishing-frenzy/db/schema.rb" do
  mode "0666"
end

execute 'migrate dbs' do
  command 'cd /var/www/phishing-frenzy/ && RAILS_ENV=production bundle exec rake db:migrate'
end


execute 'seed dbs' do
  command 'cd /var/www/phishing-frenzy/ && RAILS_ENV=production bundle exec rake db:seed'
end

execute 'load templates' do
  command 'cd /var/www/phishing-frenzy/ && RAILS_ENV=production bundle exec rake templates:load'
end
