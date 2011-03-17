require "spec_helper"

describe SquadsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/squads" }.should route_to(:controller => "squads", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/squads/new" }.should route_to(:controller => "squads", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/squads/1" }.should route_to(:controller => "squads", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/squads/1/edit" }.should route_to(:controller => "squads", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/squads" }.should route_to(:controller => "squads", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/squads/1" }.should route_to(:controller => "squads", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/squads/1" }.should route_to(:controller => "squads", :action => "destroy", :id => "1")
    end

  end
end
