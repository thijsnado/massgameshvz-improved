class Admin::PostsController < AdminController
  
  def index
    @posts = Post.order('created_at desc')
  end
  
  def create
    Post.create params[:post]
    
    redirect_to admin_posts_url
  end
  
  def update
    post = Post.find(params[:id]).update_attributes(params[:post])
    
    redirect_to admin_posts_url
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def new
    @post = Post.new
  end
  
end