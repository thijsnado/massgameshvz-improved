class WelcomeController < ApplicationController
  
  def index
    post = posts.last
    if (!post) || stale?(
        :etag => post,
        :last_modified => post.updated_at.utc
      )
      @posts = Post.order('created_at desc')
    
      respond_to do |format|
        format.html #index.html.erb
        format.atom #index.atom.builder
      end
    end
  end

  def posts
    Post.order('created_at desc')
  end
end
