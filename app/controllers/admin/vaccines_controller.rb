class Admin::VaccinesController < AdminController
  def index
    @vaccines = Vaccine.all
  end
  
  def edit
    @vaccine = Vaccine.find(params[:id])
  end
  
  def update
    @vaccine = Vaccine.find(params[:id])
    @vaccine.update_attributes(params[:vaccine])
    redirect_to admin_vaccines_url
  end
  
  def destroy
    @vaccine = Vaccine.find(params[:id])
    @vaccine.destroy
    redirect_to admin_vaccines_url
  end

  def create
    @vaccine = Vaccine.new(params[:vaccine])
    if @vaccine.save
      redirect_to admin_vaccines_url
    else
      @vaccines = Vaccine.all
      render :action => 'index'
    end
  end

end
