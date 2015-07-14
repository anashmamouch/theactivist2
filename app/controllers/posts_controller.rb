class PostsController < ApplicationController
  before_action  :find_post, only:  [:show, :edit, :update, :destroy]
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
    respond_to do |format|
      format.html
      format.json {render json: @post}
    end
  end
  #Responsible for rendering a form to create a new post Http GET Method
  def new
    @post = Post.new
  end
  #Responsible for creating the post inside the db Http POST Method
  def create
    @post = Post.new(post_params)
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

  private
    def find_post
      @post = Post.find(params[:id])
    end

    def post_params
        params.require(:post).permit(:title, :link, :description)
    end
end
