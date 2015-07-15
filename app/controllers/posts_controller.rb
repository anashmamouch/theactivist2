class PostsController < ApplicationController
  before_action  :find_post, only:  [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action  :authenticate_user!, except: [:index, :show]
  respond_to :html, :json, :xml

  def index
    @posts = Post.all.order("created_at DESC")
    respond_to do |format|
      format.html
      format.json {render json: @posts}
    end
  end

  def show
    #@post = Post.find(params[:id])
    @comments = Comment.where(post_id: @post)
    respond_to do |format|
      format.html {@comments = Comment.where(post_id: @post)}
      format.json {render json: @post}
    end
  end
  #Responsible for rendering a form to create a new post Http GET Method
  def new
    @post = current_user.posts.build
  end
  #Responsible for creating the post inside the db Http POST Method
  def create
    @post = current_user.posts.build(post_params)
      if @post.save
        redirect_to @post
      else
        render 'new'
      end

  end
  #responsible for interacting with the model db Http PUT Method
  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end
  #responsible for rendering the view Http GET Method
  def edit

  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def upvote
    @post.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @post.downvote_by current_user
    redirect_to :back
  end

  private
    def find_post
      @post = Post.find(params[:id])
    end

    def post_params
        params.require(:post).permit(:title, :link, :description, :image)
    end
end
