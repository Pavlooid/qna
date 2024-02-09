class SearchController < ApplicationController
  def search
    @query = params[:query]
    search_models = []
    search_models << 'question_core' if ActiveModel::Type::Boolean.new.cast(params[:search_model_question])
    search_models << 'answer_core' if ActiveModel::Type::Boolean.new.cast(params[:search_model_answer])
    search_models << 'comment_core' if ActiveModel::Type::Boolean.new.cast(params[:search_model_comment])
    search_models << 'user_core' if ActiveModel::Type::Boolean.new.cast(params[:search_model_user])

    if @query.present?
      @results = ThinkingSphinx.search(@query, indices: search_models, match_mode: :any)
      render 'search/index', results: @results, query: @query
    else
      redirect_back fallback_location: root_path, notice: "Search parameters doesn't submitted"    
    end  
  end
end
