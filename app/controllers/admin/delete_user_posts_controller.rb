class DeleteUserPostsController < ApplicationController
  #  before_action :ensure_admin, only: [:delete_all_posts]
  
    def delete_all_posts
      render json: { error: 'done' }, status: :success
    end
end
  