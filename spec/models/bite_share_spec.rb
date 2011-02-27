require 'spec_helper'

describe BiteShare do
  describe 'share_bite' do
    let(:human_participation){Factory(:human_participation)}
    let(:zombie_participation){Factory(:normal_zombie_participation)}
    let(:zombie_participation_2){Factory(:normal_zombie_participation)}
    it "should extend the life of another zombie participation to the recorded starve time increase" do
      
    end
  end
end
