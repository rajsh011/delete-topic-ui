export default {
  resource: 'admin.adminPlugins',
  path: '/plugins',
  map() {
    this.route('delete-topic-ui');
  }
};
