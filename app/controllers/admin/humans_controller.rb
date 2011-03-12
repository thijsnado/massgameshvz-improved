class Admin::HumansController < AdminController
  
  def index
    @humans = Human.all
  end

  def new
    @human = Human.new
  end

  def show
  end

  def edit
    @human = Human.find(params[:id])
    render :action => 'new'
  end
  
  def update
    @human = Human.find(params[:id])
    if @human.update_attributes(params[:human])
      redirect_to admin_humans_url
    else
      render :action => 'new'
    end
  end


  def create
    @human = Human.new(params[:human])
    if @human.save
      redirect_to admin_humans_url()
    else
      render :action => 'new'
    end
  end

  def destroy
  end

end
