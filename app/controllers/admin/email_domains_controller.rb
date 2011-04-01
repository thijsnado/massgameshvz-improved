class Admin::EmailDomainsController < AdminController
  def index
    @email_domains = EmailDomain.all
  end
  
  def new
    @email_domain = EmailDomain.new
  end
  
  def edit
    @email_domain = EmailDomain.find(params[:id])
  end
  
  def update
    @email_domain = EmailDomain.find(params[:id])
    if @email_domain.update_attributes(params[:email_domain])
      redirect_to admin_email_domains_url
    else
      render :action => 'new'
    end
  end
  
  def create
    @email_domain = EmailDomain.new(params[:email_domain])
    if @email_domain.save
      redirect_to admin_email_domains_url
    else
      render :action => 'new'
    end
  end
end