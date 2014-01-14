Phishing Frenzy
===============

Ruby on Rails Phishing Framework

![PhishingFrenzy](http://i.imgur.com/pt4JHb4.png)

Install
-------

These instructions are to install Phishing Frenzy on a Debian based OS with a MySQL database used as a backend. Different steps will need to be taken if you are running on a different OS or planning on using a different database server.

Install instructions will be temporary until a formal deployment service is configured to deploy Phishing Frenzy seamlessly.

### Apache Configuration

Install LAMP server software of not already installed

	# tasksel install lamp-server

Clone the Phishing Frenzy repository to your system

	# git clone https://github.com/pentestgeek/phishing-frenzy.git /var/www/phishing-frenzy

Make sure Phishing Frenzy is in the Apache webroot of your webserver wherever that may be located (/var/www/*).

This next part of the install will focus on how to use Apache with mod_passenger to always serve up the Phishing Frenzy web application.

Configure Apache to always run Phishing Frenzy by adding the following line to the apache configuration file (/etc/apache2/apache2.conf).

	Include pf.conf

Also you will need to add the following line which is used to manage the virtual hosts.

	Include httpd.conf

This addition to inclue pf.conf tells Apache to look at this file within the Apache directory (/etc/apache2/pf.conf) and serve up whatever website is configured. 

Now that Apache is configured to process the pf.conf configuration file everytime Apache reloads or restarts we need to create the file and add the following content to pf.conf. 'ServerName' should be changed to whichever domain name that Phishing Frenzy is running under. This tells Apache which website to serve up when a request for phishingfrenzy.com is made.

	<IfModule mod_passenger.c>
		PassengerRoot %ROOT
		PassengerRuby %RUBY
	</IfModule>

	<VirtualHost *:80>
		ServerName phishingfrenzy.com
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

Pay attention to the install notes here, you may be required to run a command similar to the following in order to get rvm working properly.  You may also be asked to logout / login or open a new shell before rvm is functioning properly.

	$ source /usr/local/rvm/scripts/rvm

Install Ruby on Rails. We can use rvmsudo with rvm to get the job done.

	$ rvmsudo rvm all do gem install rails

Install mod_passenger for Apache

	$ rvmsudo rvm all do gem install passenger

Invoke passenger install script

	$ passenger-install-apache2-module

If you do not have the required software to install passenger, the script will let you know which additional software needs to be install. In my case I had to install the following software on my fresh install of Ubuntu.

	$ sudo apt-get install libcurl4-openssl-dev apache2-threaded-dev libapr1-dev libaprutil1-dev

If you were required to install additional software, you will need to invoke the passenger-install-apache2-module once again to continue.

Also in my case the passenger install module did not have the proper permissions to install so I ran the following which was given to me by the install script.

	$ rvmsudo -E /usr/local/rvm/wrappers/ruby-2.0.0-p247/ruby /usr/local/rvm/gems/ruby-2.0.0-p247/gems/passenger-4.0.20/bin/passenger-install-apache2-module

Pay attention to the end of the script because it will ask you to copy a few lines into your Apache configuration file, these are what the lines looked like in my case

	LoadModule passenger_module /usr/local/rvm/gems/ruby-2.0.0-p247/gems/passenger-4.0.20/buildout/apache2/mod_passenger.so
	PassengerRoot /usr/local/rvm/gems/ruby-2.0.0-p247/gems/passenger-4.0.20
	PassengerDefaultRuby /usr/local/rvm/wrappers/ruby-2.0.0-p247/ruby

Install all the gems for the Ruby on Rails application:

	$ rvmsudo gem install bundler
	$ cd /var/www/phishing-frenzy
	$ rvmsudo bundle install

### MySQL Configuration

Create Rails Database for Phishing Frenzy:

	mysql> create database phishing_frenzy_development;
	mysql> grant all privileges on phishing_frenzy_development.* to 'phishing_frenzy'@'localhost' identified by 'password';

### Ruby on Rails Configuration

Make sure app/config/database.yml file is properly configured or the rake tasks will fail. The database.yml file will tell your rails application how to properly authenticate to database server and access the database. If either of the rake tasks fail, it will render Phishing Frenzy worthless, so ensure the rake tasks are completed successfully before continuing on.

Ensure that you are in the root of the rails application before running any rake commands.  rake commands will most certainly fail to run because of the required approot/Rakefile required.

Before you chmod these files, you may be required to create the log directory or even the development.log file if the rails application has never been started.

	$ sudo chmod 0666 /var/www/phishing-frenzy/log/development.log
	$ sudo chmod 0666 /var/www/phishing-frenzy/db/schema.rb

Create Database schema using Rails Migrations:

	$ rake db:migrate

Poppulate database with content using Rails Seeds helper:

	$ rake db:seed

Change ownership of apache config to allow Phishing Fenzy manage virtual hosts. If you currently have entries within the httpd.conf file, backup the file now because Phishing Frenzy will delete all entries in this file when managing virtual hosts for phishing campaigns.

	# chown www-data:www-data /etc/apache2/httpd.conf

If you are running Kali linux or a distro that does not have the httpd.conf file you will need to create one so Phishing Frenzy can manage the virtual hosts.

### Background Jobs

Phishing Frenzy uses Sidekiq to send emails in the background. Sidekiq depends on Redis to manage the job queue. At this
time, Phishing Frenzy does not use asynchronous processing by default so you do not need to install Redis and Sidekiq.
The feature can be enabled from the Global Settings view in the Admin section.

* [Install Redis on Ubuntu](https://www.digitalocean.com/community/questions/how-to-install-redis-on-ubuntu)
* [Install Redis and Use Redis](https://www.digitalocean.com/community/articles/how-to-install-and-use-redis)

In order to allow for Sidekiq process monitoring, you must start Sidekiq with a configuration that places the Sidekiq pid
in /tmp/pids/sidekiq.pid

    bundle exec sidekiq -C config/sidekiq.yml


### Linux Configuration

Change ownership and permissions of the web application to the same account Apache is running as. In most cases this will be the 'www-data' account.

	# chown -R www-data:www-data phishing-frenzy/
	# chmod a+rw /var/www/phishing-frenzy/public/templates/
	# chmod o+rw phishing-frenzy/public/uploads/

Edit /etc/sudoers to allow Phishing Frenzy to restart apache and manage the virtual hosts. This way Phishing Frenzy can run multiple phishing websites on one webserver.

	www-data ALL=(ALL) NOPASSWD: /etc/init.d/apache2 reload

### Default Login

Phishing Frenzy is configured with a default login of:

	username: admin
	password: Funt1me!

### Production mode

Now that we have our rails application up and running in development mode, we can switch over to production mode to increase performance among and increase security (not spewing errors everywhere when id is not found or 404).

You may be required to create the production.log file and chmod it so the rails application can be started. You'll usually receive some message in the terminal that states this needs to be done.

	$ sudo chmod 0666 /var/www/phishing-frenzy/log/production.log

Using our rails helper 'rake' we can precompile all of our assets which is required to enable production mode. We can also prefix the command with the environmental variable RAILS_ENV and set it to production. This is sometimes required to render all assets in production mode.

	# RAILS_ENV=production rake assets:precompile

Now we must migrate and seed the data for our production database.  If you have not created a seperate production account within mysql you need to do that now.

	mysql> create database phishing_frenzy_production;
	mysql> grant all privileges on phishing_frenzy_production.* to 'phishing_frenzy_production'@'localhost' identified by 'password';

Rake will assist with creating the database schema and seeding the database

	# RAILS_ENV=production rake db:migrate

	# RAILS_ENV=production rake db:seed

Now we must tell Apache to use production mode for our rails application by modifying /etc/apache2/pf.conf and changing the line of:

	RailsEnv development

to

	RailsEnv production

So your configuration file will look something like this:

	<VirtualHost *:80>
		ServerName phishingfrenzy.com
		# !!! Be sure to point DocumentRoot to 'public'!
		DocumentRoot /var/www/phishing-frenzy/public
		RailsEnv production
		<Directory /var/www/phishing-frenzy/public>
			# This relaxes Apache security settings.
			AllowOverride all
			# MultiViews must be turned off.
			Options -MultiViews
		</Directory>
	</VirtualHost>

Enjoy Phishing Frenzy and please submit all bugs.

### Troubleshooting

If you receive an error im the browser such as "rails no such file tmp/cache/assets/*".

Try the following:

	#rake tmp:pids:clear
	#rake tmp:sessions:clear
	#rake tmp:sockets:clear
	#rake tmp:cache:clear

If you receive an error in production mode the errors will not be displayed in the web browser (this is intended for security). If you need to diagnose the problem, tail the production.log file located in 'approot/log/production.log'

### Wiki

Check out the wiki on github for additional resources and install guides.

### Resources

* http://www.phishingfrenzy.com
* http://nathanhoad.net/how-to-ruby-on-rails-ubuntu-apache-with-passenger
* https://rvm.io/rvm/install
* http://rubyonrails.org/download
* http://httpd.apache.org/docs/2.2/vhosts/
* http://www.pentestgeek.com/2013/11/04/introducing-phishing-frenzy/