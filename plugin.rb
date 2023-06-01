# name: delete-topic-ui
# about: Delete user topics
# version: 0.1
# authors: kbizsoft
# url: https://github.com/discourse/delete-topic-ui

add_admin_route 'delete_topic_ui.title', 'delete-topic-ui'

Discourse::Application.routes.append do
  get '/admin/plugins/delete-topic-ui' => 'admin/plugins#index'
 #save settings
 get '/admin/plugins/save_settings' => proc { |env|
    req = Rack::Request.new(env)
    settings = req.params['settings']

    # Perform the necessary logic to save the settings
    SiteSetting.delete_posts_for_username = settings['delete_posts_for_username']
=begin 
    SiteSetting.delete_posts_in_single_batch = settings['delete_posts_in_single_batch']
    SiteSetting.delete_user_topics_enabled = settings['delete_user_topics_enabled']
    SiteSetting.delete_user_topics_dry_run = settings['delete_user_topics_dry_run'] 
=end

    # Return a success response
    [200, {}, [settings.to_json]]
}
get '/admin/plugins/delete_all_posts' => proc { |_env|
  # Execute code specific to the '/test' route
  username = SiteSetting.delete_posts_for_username
  user = User.find_by_username_or_email(username)

  if user
    Post.where(user_id: user.id).destroy_all
    SiteSetting.delete_posts_for_username = ""
   [200, {}, ['Deleated all posts for user ']]
  else
   # redirect_to admin_index_path, alert: "User not found."
   [200, {}, ['User does not exist. Please check user name you entered in plugin settings']]
  end

}


end
