# name: delete-topic-ui
# about: Delete user topics
# version: 0.1
# authors: kbizsoft
# url: https://github.com/discourse/delete-topic-ui

add_admin_route 'delete_topic_ui.title', 'delete-topic-ui'
#getting error loding file 
#require_dependency File.expand_path('../jobs/scheduled/delete_user_posts.rb', __FILE__)

=begin 
Discourse::Application.routes.append do
  # ...

  get '/admin/plugins/delete_all_posts' => proc { |_env|
    # Execute code specific to the '/admin/plugins/delete_all_posts' route
    Jobs::Scheduled::DeleteUserPosts.enqueue

    [200, {}, ['Cron job for deleting all posts has been scheduled']]
  }

  # ...
end 
=end

Discourse::Application.routes.append do
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
    [200, {}, [settings.to_json]]
}
=begin get '/admin/plugins/delete_all_posts' => proc { |_env|
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
=end
  get '/admin/plugins/delete_all_posts' => proc { |_env|

  module Jobs
    class DeleteUserPostsJ < ::Jobs::Scheduled
      every 2.minutes
  
      def execute(args)
        Rails.logger.error("task executed")
        return unless SiteSetting.delete_user_topics_enabled?
  
        username = SiteSetting.delete_posts_for_username
        posts_per_batch = SiteSetting.delete_posts_in_single_batch.to_i
  
        return unless username.present? && posts_per_batch.positive?
  
        user = User.find_by(username: username)
        return unless user.present?
  
        posts = user.posts.order(created_at: :asc)
        return if posts.empty?
  
        deleted_count = 0
        posts.each do |post|
          break if deleted_count >= posts_per_batch
  
          if SiteSetting.delete_user_topics_dry_run?
            Rails.logger.error("DeleteUserPosts would remove Post ID #{post.id} (#{post.topic.title} - #{post.excerpt}) (dry run mode)")
          else
            Rails.logger.error("DeleteUserPosts removing Post ID #{post.id} (#{post.topic.title} - #{post.excerpt})")
            begin
              PostDestroyer.new(Discourse.system_user, post).destroy
              deleted_count += 1
            rescue StandardError => e
              Rails.logger.error("Error deleting post ID #{post.id}: #{e.message}")
            end
          end
        end
  
        # Cancel the scheduled job if there are no more posts remaining
        if posts.size <= posts_per_batch
          self.class.cancel_scheduled_job
        end
      end

    end
  end

  [200, {}, ['Cron job for deleting user posts has been scheduled']] 
=begin  # Execute code specific to the '/test' route
    uname = SiteSetting.delete_posts_for_username
    userobj = User.find_by(username: uname)
    uposts = userobj.posts.order(created_at: :asc) 
    
    if userobj
        #require_dependency File.expand_path("../app/jobs/scheduled/delete_user_posts_job.rb", __FILE__) 
        #::Jobs::DeleteUserPosts.enqueue
        #::Jobs::Scheduled::DeleteUserPosts.enqueue

        # Require the job file to load the job class
        # require_dependency Rails.root.join('plugins', 'delete-topic-ui', 'app', 'jobs', 'scheduled', 'delete_user_posts')

        # Start the cron job to delete posts for the specified user
        #::Jobs::Scheduled::DeleteUserPosts.enqueue

        Jobs::Scheduled::DeleteUserPosts.enqueue
        [200, {}, ['Cron job for deleting user posts has been scheduled']] 

    else
      # redirect_to admin_index_path, alert: "User not found."
      [200, {}, ['User does not exist. Please check user name you entered in plugin settings']]
    end 
=end

  }


end
