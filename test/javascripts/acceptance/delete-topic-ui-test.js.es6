import { acceptance } from "helpers/qunit-helpers";
acceptance("Delete Topics ", { loggedIn: true });

/* test("Delete Topics  button works", assert => {
  visit("/admin/plugins/delete-topic-ui");

  andThen(() => {
    assert.ok(exists('#show-delete _topics '), "it shows the Delete Topics  button");
    assert.ok(!exists('.delete _topics '), "the delete _topics  is not shown yet");
  });

  click('#show-delete _topics ');

  andThen(() => {
    assert.ok(exists('.delete _topics '), "the delete _topics  wants to rule the world!");
  });

 
}); */
