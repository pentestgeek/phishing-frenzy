# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create initial admin account with password of funtime

# Don't run the following code if you just want to update your password after the devise install
connection = ActiveRecord::Base.connection();
unless ENV['SEED_DATA'] == 'devise'
  connection.execute("INSERT INTO admins ( name, username, password, salt, active, created_at, updated_at ) VALUES ( 'admin', 'admin', '25290094b52f4dd1af5be269481a9de412590a0d', 'c2e395561aeaee9160d0d49196aad9d9bd449a9f', '1', '2013-01-01', '2013-01-01')")

# Create Default Global Settings
  GlobalSettings.create({
                            command_apache_restart: 'sudo /etc/init.d/apache2 reload',
                            command_apache_status: '/etc/init.d/apache2 status'
                        })

end

connection.execute("UPDATE admins SET encrypted_password = '$2a$10$vNos/nCiOItiqDhSKmqO..OoxCLEck.sLtny1mXIAN2vkOjwB.kmG' WHERE admins.id = 1")
admin = Admin.first
admin.approved = true
admin.save
