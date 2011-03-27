class Welcome
  @file = 'welcome.textile'
  
  def self.contents
    contents = ''
    begin
      File.open(Rails.root.join('redcloth_files', @file), "r") do |f|
        f.flock(File::LOCK_SH)
        contents =  f.read
      end
    rescue
    end
    return contents
  end
  
  def self.contents=(val)
    File.open(Rails.root.join('redcloth_files', @file), "w") do |f|
      f.flock(File::LOCK_EX)
      f.write(val)
      f.flush
    end
  end
end