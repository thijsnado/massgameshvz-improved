class PseudoBite < ActiveRecord::Base
  belongs_to :game
  
  validates_uniqueness_of :code
  
  before_save :_format_code
  has_one :stat, :as => :action
  
  private 
  
  def set_code
    self.code = Digest::MD5.hexdigest("HVZ RAWKS!!!" + rand(100000000).to_s + Time.now.to_s + rand(100000000).to_s)[0, 10] if self.code.blank?
  end
  
  def self.format_code(code)
    if code
      code = code.strip
      code = code.gsub('0', 'o')
      code = code.upcase
    end
    return code
  end
  
  def _format_code
    set_code unless self.code
    self.code = self.class.format_code(self.code)
  end
end
