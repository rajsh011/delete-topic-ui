import { ajax } from 'discourse/lib/ajax';
import discourseComputed, { on } from "discourse-common/utils/decorators";

export default Ember.Controller.extend({
  actions: {
    deletePosts() {
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
          document.querySelector("p.response.notice").innerHTML= response;
          console.log(response);
        })
        .catch(error => {
          // Handle the error
          document.querySelector("p.response.notice").innerHTML= "Error deleting posts something unusual happned at server side for more information check console and error log file";
          console.error(error);
        });
    },
    test() {
      ajax('/test', {
        type: 'GET',
        data: {
          // Include any data you want to send to the server in the request body
          // Example: param1: 'value1', param2: 'value2'
        },
        dataType: 'text'
      })
        .then(response => {
          // Handle the success response
          document.querySelector("p.response.notice").innerHTML= response;
          console.log(response);
        })
        .catch(error => {
          // Handle the error
          document.querySelector("p.response.notice").innerHTML= "Error deleting posts something unusual happned at server side for more information check console and error log file";
          console.error(error);
        });
    },
  },
  userName(){
    //return "skyscraper_1";
    return this.siteSettings.delete_posts_for_username ;
}
});
