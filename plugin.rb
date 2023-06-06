# name: delete-topic-ui
# about: Delete user topics
# version: 0.1
# authors: kbizsoft
# url: https://github.com/discourse/delete-topic-ui

add_admin_route 'delete_topic_ui.title', 'delete-topic-ui'

after_initialize do
    require_dependency File.expand_path("../jobs/scheduled/delete_user_posts.rb", __FILE__)

    Discourse::Application.routes.append do
      #get '/admin/plugins/delete_all_posts' => 'delete_user_posts#delete_test'
      get '/admin/plugins/delete-topic-ui' => 'admin/plugins#index'
    #save settings
      get '/admin/plugins/save_settings' => proc { |env|
        req = Rack::Request.new(env)
        settings = req.params['settings']

        # Perform the necessary logic to save the settings
        SiteSetting.delete_posts_for_username = settings['delete_posts_for_username']
        SiteSetting.delete_posts_in_single_batch = settings['delete_posts_in_single_batch']
        SiteSetting.delete_user_topics_enabled = settings['delete_user_topics_enabled']
        SiteSetting.delete_user_topics_dry_run = settings['delete_user_topics_dry_run'] 
         
        # Return a success response
        [200, {}, ["Deletion process started for user .It will delete batch of posts in every 2 minutes Please wait Before starting again until all posts have been deleted. You can confim this by going user profile page and checking posts created. For more details check log file"]]
      }

    end
end
