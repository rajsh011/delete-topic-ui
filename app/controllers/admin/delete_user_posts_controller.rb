class DeleteUserPostsController < ApplicationController
  #  before_action :ensure_admin, only: [:delete_all_posts]
  
    def delete_all_posts
 #     username = params[:username]
       username = SiteSetting.delete_posts_for_username
      user = User.find_by_username_or_email(username)
  
      if user
        PostDestroyer.new(current_user).destroy_all_posts(user)
        redirect_to admin_index_path, notice: "All posts by #{username} have been deleted."
      else
        redirect_to admin_index_path, alert: "User not found."
      end

      render json: { error: 'success' }, status: :success

    end

    def ensure_admin
        unless current_user&.admin?
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end
end
  