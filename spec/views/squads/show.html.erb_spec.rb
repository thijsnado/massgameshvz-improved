require 'spec_helper'

describe "squads/show.html.erb" do
  before(:each) do
    @squad = assign(:squad, stub_model(Squad,
      :squad_name => "Squald Name",
      :squad_leader => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Squald Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
