require 'spec_helper'

describe "squads/index.html.erb" do
  before(:each) do
    assign(:squads, [
      stub_model(Squad,
        :squad_name => "Squald Name",
        :squad_leader => nil
      ),
      stub_model(Squad,
        :squad_name => "Squald Name",
        :squad_leader => nil
      )
    ])
  end

  it "renders a list of squads" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Squald Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
