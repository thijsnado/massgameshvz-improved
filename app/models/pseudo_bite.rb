class PseudoBite < ActiveRecord::Base
  belongs_to :game
  
  validates_uniqueness_of :code
  
  before_save :format_code
  before_create :set_game
  
  private 
  
  def set_code
    self.code = Digest::MD5.hexdigest("HVZ RAWKS!!!" + rand(100000000).to_s + Time.now.to_s + rand(100000000).to_s)[0, 10] if self.code.blank?
  end
  
  def set_game
    self.game = Game.current
  end
  
  def format_code
    set_code unless self.code
    self.code = Codeinator.format_code(self.code)
  end
end
