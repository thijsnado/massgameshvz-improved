class Admin::StatsController < AdminController
  def index
    @stats = Stat.paginate(:all, :order => 'created_at asc', :page => params[:page])
  end
end
