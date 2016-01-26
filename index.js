var express = require("express");
var bb8 = require("./bb8");
var app = express();

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
  var tmpBB8 = new bb8("15acde0142c44762aa78c0e01489278b", "Zig");
  tmpBB8.connect();
  robots[0] = tmpBB8;
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
    // robot.move();
    // robot.disconnect();
  }
});

var port = process.env.PORT || 8080;
app.listen(port);

console.log("Server started on Port: " + port);
