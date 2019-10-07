# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

file_path = File.join(ENV.fetch('ROOT_PATH'), 'lib', 'datapackage', 'datapackage-1566177582.zip')
dp = Datapackage.new
dp.file.attach(io: File.open(file_path), filename: 'datapackage-1566177582.zip', content_type: 'application/zip')
dp.save