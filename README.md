Phishing Frenzy
===============

Ruby on Rails Phishing Framework

Install
-------

These instructions are to install Phishing Frenzy on a Debian based OS with a MySQL database used as a backend. Different steps will need to be taken if you are running on a Windows platform or using a different database server.

### Apache Configuration

Install LAMP server software of not already installed

	#tasksel install lamp-server

Clone the Phishing Frenzy repository to your system

	#git clone https://github.com/pentestgeek/phishing-frenzy.git /var/www/phishing-frenzy

Make sure Phishing Frenzy is in the Apache webroot of your webserver wherever that may be located (/var/www/*).

In this part of the install we will discuss how we can use Apache with mod_passenger to always serve up our Phishing Frenzy web application.

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

### Install Ruby on Rails

We are going to use RVM to install ruby and ruby on rails. For additional details on how to install RVM please see: https://rvm.io/rvm/install

Install RVM and Ruby

	curl -L https://get.rvm.io | bash -s stable --ruby

Install Ruby on Rails. We can use rvmsudo with rvm to get the job done.

	$rvmsudo rvm all do gem install rails

Install mod_passenger for Apache

	$rvmsudo rvm all do gem install passenger

Invoke passenger install script

	$passenger-install-apache2-module

If you do not have the required software to install passenger, the script will let you know which additional software needs to be install. In my case I had to install the following software on my fresh install of Ubuntu.

	$sudo apt-get install libcurl4-openssl-dev apache2-threaded-dev libapr1-dev libaprutil1-dev

If you were required to install additional software, you will need to invoke the passenger-install-apache2-module once again to continue.

Also in my case the passenger install module did not have the proper permissions to install so I ran the following which was given to me by the install script.

	rvmsudo -E /usr/local/rvm/wrappers/ruby-2.0.0-p247/ruby /usr/local/rvm/gems/ruby-2.0.0-p247/gems/passenger-4.0.20/bin/passenger-install-apache2-module

Pay attention to the end of the script because it will ask you to copy a few lines into your Apache configuration file, these are what the lines looked like in my case

	LoadModule passenger_module /usr/local/rvm/gems/ruby-2.0.0-p247/gems/passenger-4.0.20/buildout/apache2/mod_passenger.so
	PassengerRoot /usr/local/rvm/gems/ruby-2.0.0-p247/gems/passenger-4.0.20
	PassengerDefaultRuby /usr/local/rvm/wrappers/ruby-2.0.0-p247/ruby

Install all the gems for the Ruby on Rails application:

	$rvmsudo gem install bundler
	$cd /var/www/phishing-frenzy
	$rvmsudo bundle install

Install nodejs

	#apt-get install nodejs

### MySQL Configuration

Create Rails Database for Phishing Frenzy:

	mysql> create database phishing_framework_development;
	mysql> grant all privileges on phishing_framework_development.* to 'phishing_frenzy'@'localhost' identified by 'password';

### Ruby on Rails Configuration

Make sure app/config/database.yaml file is properly configured or the rake tasks will fail. The database.yaml file will tell your rails application how to properly authenticate to database server and access the database. If either of the rake tasks fail, it will render Phishing Frenzy worthless, so ensure the rake tasks are completed successfully before continuing on.

	$sudo chmod 0666 /var/www/phishing-frenzy/log/development.log
	$sudo chmod 0666 /var/www/phishing-frenzy/db/schema.rb

Create Database schema using Rails Migrations:

	$rake db:migrate

Poppulate database with content using Rails Seeds helper:

	$rake db:seed

Change ownership of apache config to allow Phishing Fenzy manage virtual hosts. If you currently have entries within the httpd.conf file, backup the file now because Phishing Frenzy will delete all entries in this file when managing virtual hosts for phishing campaigns.

	#chown www-data:www-data /etc/apache2/httpd.conf

### Linux Configuration

Change ownership and permissions of the web application to the same account Apache is running as. In most cases this will be the 'www-data' account.

	#chown -R www-data:www-data phishing-frenzy/
	#chmod a+rw /var/www/phishing-frenzy/public/templates/

Edit /etc/sudoers to allow Phishing Frenzy to restart apache and manage the virtual hosts. This way Phishing Frenzy can run multiple phishing websites on one webserver.

	www-data ALL=(ALL) NOPASSWD: /etc/init.d/apache2 reload

### Default Login

Phishing Frenzy is configured with a default login of:

	username: admin
	password: funtime

Enjoy Phishing Frenzy and please submit all bugs.

### Resources
http://nathanhoad.net/how-to-ruby-on-rails-ubuntu-apache-with-passenger
https://rvm.io/rvm/install
http://rubyonrails.org/download
