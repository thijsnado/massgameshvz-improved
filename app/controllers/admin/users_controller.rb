class Admin::UsersController < AdminController
  before_filter :find_user, :except => ['index', 'get_creatures']
  
  def index
    @order = params[:order] || 'id'
    @descasc = params[:descasc] || 'asc'
    @users = User.paginate(:all, :page => params[:page], :order =>  @order+ ' ' + @descasc)
    if @descasc == 'asc'
      @descasc = 'desc'
    else
      @descasc = 'asc'
    end
  end

  def edit
    @living_areas = LivingArea.all
    @creatures = @user.creature.class.all rescue []
  end

  def update
    @user.attributes = params[:user]
    @user.creature_type = params[:user][:creature_type]
    @user.creature_id = params[:user][:creature_id]
    @user.is_admin = params[:user][:is_admin] if params[:user][:is_admin]
    @user.confirmed = params[:user][:confirmed] if params[:user][:confirmed]
    if @user.save_without_validation
      if params[:date]
        date_hash = params[:date]
        date = "#{date_hash[:year]}-#{date_hash[:month]}-#{date_hash[:day]} #{date_hash[:hour]}:#{date_hash[:minute]}:#{date_hash[:second]}"
        ZombieExpirationDate.update_or_create(@user, date)
      end
      redirect_to admin_users_url
    end
  end

  def show
    @stats = Stat.find(:all, 
      :conditions => ["user_id = ? or (action_type = 'Share' and action_id = ?) or (action_type = 'User' and action_id = ?)", 
                      @user.id, @user.id, @user.id],
      :order => 'created_at asc'
    )
  end
  
  def destroy
    @user.destroy
    redirect_to admin_users_url()
  end
  
  def get_creatures
    if params.has_key? :Human
      @creatures = Human.all
    elsif params.has_key? :Zombie
      @creatures = Zombie.all
    end
  end

  private 
  
  def find_user
    @user = User.find(params[:id])
  end
end
