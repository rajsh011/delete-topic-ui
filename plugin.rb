# name: delete-topic-ui
# about: Delete user topics
# version: 0.1
# authors: kbizsoft
# url: https://github.com/discourse/delete-topic-ui

add_admin_route 'delete_topic_ui.title', 'delete-topic-ui'

#require_dependency File.expand_path("../app/controllers/delete_user_posts_controller.rb", __FILE__)
=begin 
  after_initialize do 
    require_relative "..app/controllers/delete_user_posts_controller.rb"
  end 
=end

=begin 
after_initialize do
  require_dependency File.expand_path("../jobs/scheduled/delete_user_posts.rb", __FILE__)
end 
=end

Discourse::Application.routes.append do
  get '/admin/plugins/delete-topic-ui' => 'admin/plugins#index'
 # get '/admin/plugins/delete_all_posts' => 'admin/delete_user_posts#delete_all_posts'
  get '/admin/plugins/delete_all_posts', to: 'admin/delete_user_posts#delete_all_posts'
 # get '/test' => proc { |_env| [200, {}, ['This is a test route']] }
  get '/testjob' => proc { |_env|
  Jobs.enqueue(:delete_user_posts_job)
  [200, {}, ['Job enqueued']]
}
get '/test' => proc { |_env|
  # Execute code specific to the '/test' route
  username = SiteSetting.delete_posts_for_username
  user = User.find_by_username_or_email(username)

  if user
    #PostDestroyer.new(current_user).destroy_all_posts(user)
    Post.where(user_id: user.id).destroy_all
   # redirect_to admin_index_path, notice: "All posts by #{username} have been deleted."
   [200, {}, ['This is a test route']]
  else
   # redirect_to admin_index_path, alert: "User not found."
   [200, {}, ['This is a test route 2']]
  end

  # Return the response
  [200, {}, ['This is a test route']]
}


end
