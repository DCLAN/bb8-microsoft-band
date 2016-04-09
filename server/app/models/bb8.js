/** BB8 **/
// TODO: cache to file?
var model = require('nodejs-model');

var BB8 = model("BB8")
  .attr('name', {
    validations: {
      presence: {
        message: 'Name is required'
      }
    }
  })
  .attr('uuid', {
    validations: {
      presence: {
        message: 'BT UUID is required'
      }
    }
  });

module.exports = BB8
