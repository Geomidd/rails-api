class CommentsController < ApplicationController
  include Paginable
  skip_before_action :authorize!, only: %i[index]
  before_action :load_article

  # GET /comments
  def index
    paginator = JSOM::Pagination::Paginator.new
    comments = @article.comments
    paginate_params = {
      number: params[:page],
      size: params[:per_page],
    }
    paginated = paginator.call(comments, params: paginate_params )
    render_collection(paginated)
  end

  # POST /comments
  def create
    @comment = @article.comments.build(comment_params.merge(user: current_user))
    @comment.save!
    render json: serializer.new(@comment), status: :created, location: @article
  end

  def load_article
    @article = Article.find(params[:article_id])
  end

  def serializer
    CommentSerializer
  end

  private
    def comment_params
      params.require(:data).require(:attributes).
        permit(:content) ||
        ActionController::Parameters.new
    end
end
