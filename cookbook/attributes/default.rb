default[:rbenv][:group_users] == ['pf_prod', 'vagrant'] 

default['mysql']['server_root_password'] = 'ilikerandompasswords'

default['phishing-frenzy']['database']['host'] = 'localhost'
default['phishing-frenzy']['database']['username'] = 'root'
default['phishing-frenzy']['database']['password'] = node['mysql']['server_root_password']
default['phishing-frenzy']['database']['dbname'] = 'pf_prod'

default['phishing-frenzy']['database']['app']['username'] = 'pf_prod'
default['phishing-frenzy']['database']['app']['password'] = 'password'
