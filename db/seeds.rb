# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

hayat = Company.find_by(name: 'Hayat')
if !hayat
  hayat = Company.create(name: 'Hayat')
end
if User.where(admin: true).count == 0
  User.create(name: "Admin", password: 'trans82', 
    password_confirmation: "trans82", email: 'kunashir@list.ru',
    company: hayat, admin: true, manager: true)
end