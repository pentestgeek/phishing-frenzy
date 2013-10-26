class GlobalSettings < ActiveRecord::Base

	attr_accessible :command_apache_restart, 
					:path_apache_httpd
end
