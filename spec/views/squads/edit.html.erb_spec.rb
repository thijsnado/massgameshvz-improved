require 'spec_helper'

describe "squads/edit.html.erb" do
  before(:each) do
    @squad = assign(:squad, stub_model(Squad,
      :squad_name => "MyString",
      :squad_leader => nil
    ))
  end

  it "renders the edit squad form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => squad_path(@squad), :method => "post" do
      assert_select "input#squad_squad_name", :name => "squad[squad_name]"
      assert_select "input#squad_squad_leader", :name => "squad[squad_leader]"
    end
  end
end
