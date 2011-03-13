class Admin::UsersController < AdminController
  before_filter :find_user, :except => ['index', 'get_creatures', 'new', 'create']
  
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
    @user = User.find(params[:id])
    @game_participation = @user.current_participation ? @user.current_participation : Game.current.game_participations.new rescue nil
    @living_areas = LivingArea.all
    @creatures = @game_participation.creature.class.all rescue []
  end
  
  def new
    @user = User.new
    @game_participation =  Game.current.game_participations.new rescue nil
    @living_areas = LivingArea.all
    @creatures = []
  end

  def update
    @user.attributes = params[:user]
    @game_participation = @user.current_participation ? @user.current_participation : Game.current.game_participations.new
    @game_participation.attributes = params[:game_participation]
    @game_participation.user_id = @user.id if @game_participation
    respond_to do |format|
      @user.save(:validate => false)
      @game_participation.save(:validate => false)
      format.html { redirect_to(admin_user_url(@user), :notice => 'User was successfully updated.') }
      format.xml  { head :ok }
    end
  end
  
  def create
    @user = User.new(params[:user])
    @game_participation = Game.current.game_participations.new rescue nil
    @game_participation.attributes = params[:game_participation]
    @game_participation.user = @user if @game_participation
    respond_to do |format|
      @user.save(:validate => false)
      @game_participation.save(:validate => false) if @game_participation
      format.html { redirect_to(admin_user_url(@user), :notice => 'User was successfully created.') }
      format.xml  { head :ok }
    end
  end
  


  def show
    if @user.current_participation.creature_type == 'Human'
      @status = :human
    elsif @user.current_participation.creature_type == 'Zombie'
      @status = :normal_zombie
    end
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
