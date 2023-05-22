# name: delete-topic-ui
# about: Delete user topics
# version: 0.1
# authors: kbizsoft
# url: https://github.com/discourse/delete-topic-ui

add_admin_route 'delete_topic_ui.title', 'delete-topic-ui'

Discourse::Application.routes.append do
  get '/admin/plugins/delete-topic-ui' => 'admin/plugins#index'
  get '/delete_user_posts/delete_all_posts' => 'delete_user_posts#delete_all_posts'
end
