# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PdfRecord.create!(first_name: 'David', last_name: 'Vezzani', address: '5922 N. Krotik Ct.', address_2: '', city: 'Atwater', state: 'CA', zip_code: '95301', age: 43, comments: 'Loves lasagna.')
