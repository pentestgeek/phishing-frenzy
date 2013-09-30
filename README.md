Phishing Frenzy
===============

Ruby on Rails Phishing Framework

Install
-------

Upload Phishing Frenzy to the webroot of your webserver (/var/www/*)

### Apache Configuration

Source:
http://nathanhoad.net/how-to-ruby-on-rails-ubuntu-apache-with-passenger

Configure Apache to always run Phishing Frenzy by adding the following line to the apache configuration file (/etc/apache2/apache2.conf).

	Include pf.conf

Now that Apache is configured to run the pf.conf configuration file, create and add the following content to pf.conf.

	<VirtualHost *:80>
		ServerName phishing-frenzy.com
		# !!! Be sure to point DocumentRoot to 'public'!
		DocumentRoot /var/www/phishing-frenzy/public
		RailsEnv development
		<Directory /var/www/phishing-frenzy/public>
			# This relaxes Apache security settings.
			AllowOverride all
			# MultiViews must be turned off.
			Options -MultiViews
		</Directory>
	</VirtualHost>

Install some linux dependencies for Apache and MySQL to run ruby on rails.

Install Ruby on Rails

	#rvm all do gem install rails

Install mod_passenger for Apache

	#rvm all do gem install passenger

Invoke passenger install script

	#passenger-install-apache2-module

Edit your Apache configuration file, and add these lines to run Ruby on Rails:

	LoadModule passenger_module /usr/local/rvm/gems/ruby-1.9.3-p392/gems/passenger-4.0.14/buildout/apache2/mod_passenger.so
	PassengerRoot /usr/local/rvm/gems/ruby-1.9.3-p392/gems/passenger-4.0.14
	PassengerDefaultRuby /usr/local/rvm/wrappers/ruby-1.9.3-p392/ruby

Add the following lines in the Phishing Frenzy Gemfile to properly deploy with Apache mod_passenger:

	gem 'execjs'
	gem 'libv8'
	gem 'therubyracer'

Install all the gems for the Ruby on Rails application:

	#cd /var/www/phishing-framework
	#bundle install

Install nodejs

	#apt-get install nodejs

### MySQL Configuration

Create Rails Database for Phishing Frenzy:

	mysql> create database phishing_framework_production;
	mysql> grant all privileges on phishing_framework_production.* to 'phishing_frenzy'@'localhost' identified by 'password';

### Ruby on Rails Configuration

Make sure app/config/database.yaml file is properly configured:

Create Migrations:

	#rake db:migrate

Poppulate database with seeds:

	#rake db:seed

Change ownership of apache config to allow Phishing Fenzy

	#chown www-data:www-data /etc/apache2/httpd.conf

### Linux Configuration

Change ownership and permissions of the web application

	#chown -R www-data:www-data phishing-framework/
	#chmod a+rw /var/www/phishing-framework/public/templates/

Edit /etc/sudoers to allow phishing frenzy to restart apache:

	www-data ALL=(ALL) NOPASSWD: /etc/init.d/apache2 reload

### Default Login

Phishing Frenzy is configured with a default login of:

	username: admin
	password: funtime

Enjoy Phishing Frenzy and please submit all bug reports with a pull request.