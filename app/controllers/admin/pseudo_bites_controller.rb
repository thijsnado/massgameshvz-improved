class Admin::PseudoBitesController < AdminController
  def index
    @pseudo_bites = PseudoBite.all
  end

  def edit
    @pseudo_bite = PseudoBite.find(params[:id])
  end

  def update
    @pseudo_bite = PseudoBite.find(params[:id])
    if @pseudo_bite.save
      redirect_to admin_pseudo_bites_url
    end
  end

  def create
    @pseudo_bite = PseudoBite.new(params[:pseudo_bite])
    if @pseudo_bite.save
      redirect_to admin_pseudo_bites_url
    end
  end
  
  def destroy
    @pseudo_bite = PseudoBite.find(params[:id])
    if @pseudo_bite.destroy
      redirect_to admin_pseudo_bites_url
    end
  end

end
