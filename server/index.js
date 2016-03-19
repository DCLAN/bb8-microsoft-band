var express = require("express");
var bb8 = require("./bb8");
var app = express();
var discovery = require("./discovery");

var router = express.Router();
app.use('/bb8', router);

var robots = [];

// API HERE
router.get('/', function(req,res) {
  res.send("Hello, I am BB8");
});

router.post('/subscribe', function(req, res) {
  // TODO; create a bb8
  // return an id
  // TODO: UUID + name need to come from the application. Still at POC stage though.
  var robot = new bb8("15acde0142c44762aa78c0e01489278b", "Zig");
  robot.connect();
  robots[0] = robot;
  res.status(200).send("OK");
});

// TODO: gross, needs to be more robust, you know?
router.post('/move', function(req, res) {
  // TODO; create a bb8
  // TODO; Gross API.
  if(robots[0] == undefined) {
    res.status(500).send("Not A Robot");
  } else {
    var robot = robots[0];
    robot.move();
    res.status(200).send("Okay?");
  }
});

// TODO: gross, needs to be more robust, you know?
router.post('/stop', function(req, res) {
  // TODO; create a bb8
  // TODO; Gross API.
  if(robots[0] == undefined) {
    res.status(500).send("Not A Robot");
  } else {
    var robot = robots[0];
    robot.stop();
    res.status(200).send("Okay?");
  }
});

var port = process.env.PORT || 8080;
app.listen(port);

var appDiscovery = new discovery(port);
appDiscovery.publish();
appDiscovery.find();

console.log("Server started on Port: " + port);
