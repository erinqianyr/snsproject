// Routes.
const get_routes = require('./get_routes');
const post_routes = require('./post_routes');

module.exports = function(app, con, utils) {
  get_routes(app, con, utils);
  post_routes(app, con, utils);
};
