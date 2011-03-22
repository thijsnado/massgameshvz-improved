class PseudoBite < ActiveRecord::Base
  belongs_to :game
  
  validates_uniqueness_of :code
  
  before_create :set_code
  before_save :trim_whitespace
  has_one :stat, :as => :action
  
  private 
  
  def set_code
    self.code = Digest::MD5.hexdigest("HVZ RAWKS!!!" + rand(100000000).to_s + Time.now.to_s + rand(100000000).to_s)[0, 10] if self.code.blank?
  end
  
  def trim_whitespace
    self.code = self.code.strip
  end
end
