# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#zombie types
#name                          #vaccinatable, #immortal, #color string, #code
Zombie.delete_all
[
['Original Zombie',             0,             1,         'FFFFFF',      :original],
['Regular Zombie',              1,             0,         'F2EA00',      :normal],
['Self Bitten',                 0,             0,         '3BD300',      :self_bitten],
['Immortal',                    1,             1,         'ED004F',      :immortal],
['Immortal Self Bitten',        0,             1,         '3852B7',      :immortal_self_bitten]
].each do |zombie|
  Zombie.create(:name => zombie[0], :vaccinatable => zombie[1], :immortal => zombie[2], :color_string => zombie[3], :code => zombie[4])
end

#human types
#name,               #immortal when bitten,   #color string
Human.delete_all
[
['Normal',           0,                       'FFFFFF',       :normal],
['Squad Leader',     1,                       '0008F2',       :squad]
].each do |human|
  Human.create(:name => human[0], :immortal_when_bitten => human[1], :color_string => human[2], :code => human[3])
end

#email_domains
EmailDomain.delete_all
domain = EmailDomain.new
domain.description = 'UMass Email Address'
domain.rule = 'umass'
domain.save

if Rails.env != 'test'
#admin, change password immediatly after deploying.
  admin = User.new(:username => 'admin', :password => 'test123', :confirmed => true, :email_address => 'tdevries.development@gmail.com')
  admin.is_admin = true
  admin.save(:validate => false)
end
