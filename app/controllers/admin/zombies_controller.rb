class Admin::ZombiesController < AdminController
  def index
    @zombies = Zombie.all
  end

  def new
    @zombie = Zombie.new
  end

  def show
  end

  def edit
    @zombie = Zombie.find(params[:id])
    render :action => 'new'
  end
  
  def update
    @zombie = Zombie.find(params[:id])
    if @zombie.update_attributes(params[:zombie])
      redirect_to admin_zombies_url
    else
      render :action => 'new'
    end
  end

  def create
    @zombie = Zombie.new(params[:zombie])
    if @zombie.save
      redirect_to admin_zombies_url()
    else
      render :action => 'new'
    end
  end

  def destroy
  end

end
