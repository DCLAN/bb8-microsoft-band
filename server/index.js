var express = require("express");
var app = express();
var router = express.Router();

var noble = require('noble');

// Initializing Application - likely should go elsewhere.... An actual module?
// I don't know what is the best practice for this...
var controllers = require("./app/controllers");
var discovery = controllers.Discovery();
var btDiscovery = controllers.BTDiscovery();

// Setup Routes and Controller
var BB8Controller = require("./app/controllers/bb8-controller.js");
var bb8Controller = new BB8Controller();
var Droid = require('./app/routes/droid.js')(app, router, bb8Controller);

var port = process.env.PORT || 8080;
app.listen(port);

var appDiscovery = new discovery(port);
appDiscovery.publish();

var btDiscovery = new btDiscovery(noble);
btDiscovery.on('discovered', function(peripheral) {
  bb8Controller.onDeviceDiscovered(peripheral) ;
});

console.log("May the Force be With You on Port: " + port);
