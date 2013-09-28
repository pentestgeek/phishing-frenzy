# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create initial admin account with password of funtime
Admin.find_or_create_by_name({ name: 'admin', username: 'admin', password: '25290094b52f4dd1af5be269481a9de412590a0d', salt: 'c2e395561aeaee9160d0d49196aad9d9bd449a9f', active: 'true' })

# Create intial phishing templates
Template.create([
	{ name: 'Intel Password Checker', location: 'intel', description: 'Users test the strength of their password' },
	{ name: 'Efax', location: 'efax', description: 'User received a efax which requires them to open the PDF' }])