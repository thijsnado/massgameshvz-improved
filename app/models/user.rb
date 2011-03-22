class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :game_participations
  
  before_create :generate_confirmation_hash
  after_create :send_confirmation_email
  
  validates :email_address, :email_domain => true
  
  attr_accessor :rules_read
  
  def current_participation
    @current_participation ||= Game.current.game_participations.find_by_user_id(id) rescue nil
  end
  
  def generate_confirmation_hash
    self.confirmation_hash = Digest::SHA1.hexdigest(self.username.to_s + Time.now.to_s + rand.to_s)
  end
  
  def send_confirmation_email
    ConfirmationEmail.confirmation_message(self).deliver
  end

  
end
