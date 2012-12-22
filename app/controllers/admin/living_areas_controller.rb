class Admin::LivingAreasController < AdminController
  
  before_filter :get_living_area, :only => [:show, :update, :edit, :destroy]

  def index
    @living_areas = LivingArea.all
  end
  
  def edit
  end
  
  def destroy
    @living_area.delete
    redirect_to admin_living_areas_url()
  end
  
  def show
  end
  
  def new
    @living_area = LivingArea.new
  end
  
  def create
    @living_area = LivingArea.new(params[:living_area])
    if @living_area.save
      redirect_to admin_living_areas_url()
    else
      render :action => 'new'
    end
  end
  
  def update
    @living_area.update_attributes params[:living_areas]
    redirect_to admin_living_areas_url()
  end
  
  private
  
  def get_living_area
    @living_area = LivingArea.find(params[:id])
  end
  
end
