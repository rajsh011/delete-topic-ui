import { ajax } from 'discourse/lib/ajax';

export default Ember.Controller.extend({
  actions: {
    deletePosts() {
      ajax('/delete_user_posts/delete_all_posts', {
        type: 'GET',
        data: {
          // Include any data you want to send to the server in the request body
          // Example: param1: 'value1', param2: 'value2'
        }
      })
        .then(response => {
          // Handle the success response
          console.log(response);
        })
        .catch(error => {
          // Handle the error
          console.error(error);
        });
    }

   /*  deletePosts() {
      const username = this.get('deleteUserPostsUsername');
      const batchCount = this.get('deleteUserPostsBatchCount');

      // Perform any necessary validations or data manipulation here

      // Update site settings values
      Discourse.ajax(`/admin/site_settings/${yourPluginName}.delete_user_posts_username`, {
        type: 'PUT',
        data: { value: username }
      });

      Discourse.ajax(`/admin/site_settings/${yourPluginName}.delete_user_posts_batch_count`, {
        type: 'PUT',
        data: { value: batchCount }
      });

      // Navigate to the new URL
      this.transitionToRoute('admin-plugins.delete-topic-ui.del');
    } */
  }
});
