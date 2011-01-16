require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "can signup with valid email" do
    @umass_user = User.new
    @umass_user.email_address = 'bob@student.umass.edu'
    EmailDomainValidator.new(:attributes => {}).validate_each @umass_user, :email_address, @umass_user.email_address
    assert_equal 0, @umass_user.errors.size
    
    @smith_user = User.new
    @smith_user.email_address = 'kate@smith.edu'
    EmailDomainValidator.new(:attributes => {}).validate_each @smith_user, :email_address, @smith_user.email_address
    assert_equal 0, @smith_user.errors.size
  end
  
  test "cannot signup with invalid email" do
    @bad_user = User.new
    @bad_user.email_address = 'joe@gmail.com'
    EmailDomainValidator.new(:attributes => {}).validate_each @bad_user, :email_address, @bad_user.email_address
    assert_equal 1, @bad_user.errors.size
  end
  
end
