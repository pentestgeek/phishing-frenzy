# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# create admin account with default password if it does not exist
admin = Admin.find_by(username: "admin")
unless admin.present?
	Admin.create(
		username: "admin",
		name: "admin",
		password: "Funt1me!",
		password_confirmation: "Funt1me!",
		email: "admin@phishingfrenzy.local",
		approved: true
	)
end
