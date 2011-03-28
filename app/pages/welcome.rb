class Welcome
  @name = 'welcome'
  
  def self.contents
    contents = Page.where(:name => @name).first.contents rescue ''
    return contents
  end
  
  def self.contents=(val)
    page = Page.where(:name => @name).first
    page = Page.create(:name => @name) unless page
    page.update_attribute(:contents, val)
  end
end