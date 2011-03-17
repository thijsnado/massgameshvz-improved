require 'spec_helper'

describe "squads/new.html.erb" do
  before(:each) do
    assign(:squad, stub_model(Squad,
      :squad_name => "MyString",
      :squad_leader => nil
    ).as_new_record)
  end

  it "renders new squad form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => squads_path, :method => "post" do
      assert_select "input#squad_squad_name", :name => "squad[squad_name]"
      assert_select "input#squad_squad_leader", :name => "squad[squad_leader]"
    end
  end
end
