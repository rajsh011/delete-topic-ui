# name: delete-topic-ui
# about: Delete user topics
# version: 0.1
# authors: kbizsoft
# url: https://github.com/discourse/delete-topic-ui

add_admin_route 'delete_topic_ui.title', 'delete-topic-ui'

after_initialize do
  require_dependency 'application_controller'

  class DeleteUserPostssController < ApplicationController
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
      end
  
      def ensure_admin
          unless current_user&.admin?
            render json: { error: 'Unauthorized' }, status: :unauthorized
          end
      end
  end
    
end
Discourse::Application.routes.append do
  get '/admin/plugins/delete-topic-ui' => 'admin/plugins#index'
  post '/delete_user_posts/delete_all_posts' => 'delete_user_postss#delete_all_posts'
end
