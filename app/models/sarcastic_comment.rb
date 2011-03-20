class SarcasticComment < ActiveRecord::Base
  def self.random
    find(:first, :offset => rand(self.count))
  end
end
