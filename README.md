Phishing Frenzy
===============

Ruby on Rails Phishing Framework

Install
-------

These instructions are to install Phishing Frenzy on a Debian based OS with a MySQL database used as a backend. Different steps will need to be taken if you are running on a Windows platform or using a different database server.

Upload Phishing Frenzy to the webroot of your webserver wherever that may be located (/var/www/*).

### Apache Configuration

In this part of the install we will discuss how we can use Apache with mod_passenger to always serve up our Phishing Frenzy web application.

Source:
http://nathanhoad.net/how-to-ruby-on-rails-ubuntu-apache-with-passenger

Configure Apache to always run Phishing Frenzy by adding the following line to the apache configuration file (/etc/apache2/apache2.conf).

	Include pf.conf

This addition to inclue pf.conf tells Apache to look at this file within the Apache directory (/etc/apache2/pf.conf) server up whatever website is configured. Now that Apache is configured to process the pf.conf configuration file everytime Apache reloads / restarts, create and add the following content to pf.conf. 'ServerName' should be changed to whichever domain name that Phishing Frenzy is running under. This tells Apache which website to server up when a request for phishing-frenzy.com is made.

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

At this point you will have to reload or restart your Apache services to server up the website configured in pf.conf

	#apache2ctl reload

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

Enable mod_rewrite for Apache:

	sudo a2enmod rewrite

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

Make sure app/config/database.yaml file is properly configured or the rake tasks will fail. The database.yaml file will tell your rails application how to properly authenticate to database server and access the database. If either of the rake tasks fail, it will render Phishing Frenzy worthless, so ensure the rake tasks are completed successfully before continuing on.

Create Database schema using Rails Migrations:

	#rake db:migrate

Poppulate database with content using Rails Seeds helper:

	#rake db:seed

Change ownership of apache config to allow Phishing Fenzy manage virtual hosts. If you currently have entries within the httpd.conf file, backup the file now because Phishing Frenzy will delete all entries in this file when managing virtual hosts for phishing campaigns.

	#chown www-data:www-data /etc/apache2/httpd.conf

### Linux Configuration

Change ownership and permissions of the web application to the same account Apache is running as. In most cases this will be the 'www-data' account.

	#chown -R www-data:www-data phishing-framework/
	#chmod a+rw /var/www/phishing-framework/public/templates/

Edit /etc/sudoers to allow Phishing Frenzy to restart apache and manage the virtual hosts. This way Phishing Frenzy can run multiple phishing websites on one webserver.

	www-data ALL=(ALL) NOPASSWD: /etc/init.d/apache2 reload

### Default Login

Phishing Frenzy is configured with a default login of:

	username: admin
	password: funtime

Enjoy Phishing Frenzy and please submit all bugs.