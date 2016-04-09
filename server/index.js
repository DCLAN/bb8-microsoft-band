var express = require("express");
var app = express();
var router = express.Router();

// Initializing Application - likely should go elsewhere.... An actual module?
// I don't know what is the best practice for this...
var controllers = require("./app/controllers");
var discovery = controllers.Discovery();
var bb8controller = require("./app/controllers/bb8-controller.js");
var droid = require('./app/routes/droid.js')(app, router, new bb8controller());

var port = process.env.PORT || 8080;
app.listen(port);

var appDiscovery = new discovery(port);
appDiscovery.publish();

console.log("May the Force be With You on Port: " + port);
