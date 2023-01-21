class ArticlesController < ApplicationController

  http_basic_authenticate_with name: "pablo", password: "secret", except: [:index, :show]

  def index
    @articles = Article.all
  end

  def show
    article = find_article(params[:id])
    if article.present?
      @article = article
    else
      @id = params[:id]
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article #redirect_to will cause the browser to make a new request
    else
      render :new, status: :unprocessable_entity  #renders the specified view for a current request.
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other #return 303
  end

  def validate(param_int)
    param_int.present? && param_int.to_i > 0 ? param_int.to_i : nil
  end

  def find_article(param_int)
    param = validate(param_int)
    if param.present?
      begin
        article = Article.find(param)
      rescue ActiveRecord::RecordNotFound => e
        p "Error: #{e}"
        nil
      end
    else
      nil
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end

