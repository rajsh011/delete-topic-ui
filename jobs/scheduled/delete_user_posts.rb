# frozen_string_literal: true
#require_dependency 'jobs/scheduled/base'

module Jobs
  class DeleteUserPosts < ::Jobs::Scheduled
    every 2.minutes

    def execute(args)
      return unless SiteSetting.delete_user_topics_enabled?

      username = SiteSetting.delete_posts_for_username
      posts_per_batch = SiteSetting.delete_posts_in_single_batch.to_i

      return unless username.present? && posts_per_batch.positive?

      user = User.find_by(username: username)
      return unless user.present?

      posts = user.posts.limit(1000)

      if posts.empty?
        SiteSetting.delete_posts_for_username = ""
        SiteSetting.delete_user_topics_enabled = false
        return
      end  
      deleted_count = 0
      begin
        posts.each do |post|
          break if deleted_count >= posts_per_batch

          if SiteSetting.delete_user_topics_dry_run?
            Rails.logger.error("DeleteUserPosts would remove Post ID #{post.id} (dry run mode)")
          else
            begin
              Rails.logger.error("DeleteUserPosts removing Post ID #{post.id} ")
              PostDestroyer.new(Discourse.system_user, post).destroy
              deleted_count += 1
            rescue StandardError => e
              Rails.logger.error("Error deleting post ID #{post.id}: #{e.message}")
            end
          end
        end 
      rescue StandardError => e
        Rails.logger.error("Error deleting post in loop")
      end    
    end
  end
end