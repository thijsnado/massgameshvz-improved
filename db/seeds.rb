# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#zombie types
#name               #vaccinatable, #immortal, #color string, #code
[
['Original Zombie', 0,             1,         'FFFFFF',      :original],
['Regular Zombie',  1,             0,         'F2EA00',      :normal],
['Self Bitten',     0,             0,         '3BD300',      :self_bitten],
['Immortal',        1,             1,         'ED004F',      :immortal]
].each do |zombie|
  Zombie.create(:name => zombie[0], :vaccinatable => zombie[1], :immortal => zombie[2], :color_string => zombie[3], :code => zombie[4])
end

#human types
#name,               #immortal when bitten,   #color string
[
['Normal',           0,                       'FFFFFF',       :normal],
['Squad Leader',     1,                       '0008F2',       :squad]
].each do |human|
  Human.create(:name => human[0], :immortal_when_bitten => human[1], :color_string => human[2], :code => human[3])
end

#email_domains
domain = EmailDomain.new
domain.description = 'UMass Email Address'
domain.rule = 'umass'
domain.save

#admin, change password immediatly after deploying. 
admin = User.new(:username => 'admin', :password => 'test123')
admin.is_admin = true
admin.save(:validate => false)
