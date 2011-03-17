class SquadsController < ApplicationController
  # GET /squads
  # GET /squads.xml
  def index
    @squads = Squad.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @squads }
    end
  end

  # GET /squads/1
  # GET /squads/1.xml
  def show
    @squad = Squad.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @squad }
    end
  end

end
