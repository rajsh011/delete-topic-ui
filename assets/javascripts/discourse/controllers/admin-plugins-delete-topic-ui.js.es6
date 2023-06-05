import { ajax } from 'discourse/lib/ajax'
import discourseComputed, { on } from "discourse-common/utils/decorators";
import loadScript from "discourse/lib/load-script";
import { alias } from "@ember/object/computed";
import RSVP from "rsvp";
import { isTesting } from "discourse-common/config/environment";
import { htmlSafe } from "@ember/template";

export default Ember.Controller.extend({
  actions: {
    deletePosts() {
      let responseElement = document.querySelector("p.response.notice");
      responseElement.innerHTML = "Deleting all posts for user";
      ajax('/admin/plugins/delete_all_posts', {
        type: 'GET',
        data: {
          // Include any data you want to send to the server in the request body
          // Example: param1: 'value1', param2: 'value2'
        },
        dataType: 'text'
      })
        .then(response => {
          // Handle the success response
          let response_element = document.querySelector("p.response.notice");
          response_element.innerHTML= response;
          console.log(response);

          if(response_element.classList.contains("hide")){
            response_element.classList.remove('hide');
          setTimeout(function(){
            response_element.classList.add("hide");
          },10000);
  
        }

        })
        .catch(error => {
          // Handle the error
          let response_element = document.querySelector("p.response.notice");
          response_element.innerHTML= "Error deleting posts something unusual happned at server side for more information check console and error log file";
          console.error(error);

          if(response_element.classList.contains("hide")){
            response_element.classList.remove('hide');
          setTimeout(function(){
            response_element.classList.add("hide");
          },10000);
  
        }
        });
    },
  saveSettings() {
    const deletePostsForUsername = document.getElementById('delete_posts_for_username').value;
     const deletePostsInSingleBatch = document.getElementById('delete_posts_in_single_batch').value;
    const deleteUserTopicsEnabled = document.getElementById('delete_user_topics_enabled').checked;
    const deleteUserTopicsDryRun = document.getElementById('delete_user_topics_dry_run').checked; 
    const data = {
      delete_posts_for_username: deletePostsForUsername,
      delete_posts_in_single_batch: deletePostsInSingleBatch,
      delete_user_topics_enabled: deleteUserTopicsEnabled,
      
      delete_user_topics_dry_run: deleteUserTopicsDryRun 
    }
   
    // Perform the necessary logic to save the updated settings, e.g., via AJAX request or other method
    ajax('/admin/plugins/save_settings', {
      type: 'GET',
      data: {
        settings: data
      }
    })
      .then(response => {
        // Handle the success response
        let response_element = document.querySelector("p.response.notice");
        response_element.innerHTML= "Settings saved successfully";
        if(response_element.classList.contains("hide")){
          response_element.classList.remove('hide');
        setTimeout(function(){
          response_element.classList.add("hide");
        },10000);

      }
        console.log('Settings saved:', response);
        // Optionally display a success message to the user
      })
      .catch(error => {
        // Handle the error response
        let response_element = document.querySelector("p.response.notice");
        response_element.innerHTML= "Error saving settings";
        console.error('Error saving settings:', error);

        if(response_element.classList.contains("hide")){
          response_element.classList.remove('hide');
        setTimeout(function(){
          response_element.classList.add("hide");
        },10000);

      }
        // Optionally display an error message to the user
      }); 
    // Prevent the form from submitting
    return false;
  },
  @discourseComputed("this.siteSettings.delete_posts_for_username")
  userName(){
    //return "skyscraper_1";
    return this.siteSettings.delete_posts_for_username ;
}
  }
});
