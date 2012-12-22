class Admin::SarcasticCommentsController < AdminController
  def index
    @sarcastic_comments = SarcasticComment.all
  end
  
  def create
    @sarcastic_comment = SarcasticComment.new(params[:sarcastic_comment])
    @sarcastic_comment.save
    redirect_to admin_sarcastic_comments_url
  end
  
  def destroy
    @sarcastic_comment = SarcasticComment.find(params[:id])
    @sarcastic_comment.destroy
    redirect_to admin_sarcastic_comments_url
  end
end
