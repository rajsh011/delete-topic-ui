# name: delete-topic-ui
# about: Delete user topics
# version: 0.1
# authors: kbizsoft
# url: https://github.com/discourse/delete-topic-ui

add_admin_route 'delete_topic_ui.title', 'delete-topic-ui'

Discourse::Application.routes.append do
  get '/admin/plugins/delete-topic-ui' => 'admin/plugins#index'
  get '/admin/plugins/delete_all_posts' => 'delete_user_posts#delete_all_posts'
  get '/test' => proc { |_env| [200, {}, ['This is a test route']] }
  get '/testjob' => proc { |_env|
  Jobs.enqueue(:delete_user_posts)
  [200, {}, ['Job enqueued']]
}


end
