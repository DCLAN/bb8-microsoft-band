var express = require("express");
var fs = require("fs");
var https = require("https");

// Initializing Application - likely should go elsewhere.... An actual module?
// I don't know what is the best practice for this...
var controllers = require("./app/controllers");
var discovery = controllers.Discovery();
var btDiscovery = controllers.BTDiscovery();

const FILENAME_KEY = 'key.pem';
const FILENAME_CERT = 'cert.pem';


// Setup Routes and Controller
var BB8Controller = require("./app/controllers/bb8-controller.js");
var bb8Controller = new BB8Controller();
var app = express();
var router = express.Router();
var noble = require('noble');
var Droid = require('./app/routes/droid.js')(app, router, bb8Controller);

var port = process.env.PORT || 8080;
var path = __dirname + "/config/certificates/";

try {
    fs.statSync(path + FILENAME_KEY);
    fs.statSync(path + FILENAME_CERT);
} catch (e) {
    console.log("*** ERROR *** Missing certificate and key pair. Please run generateCertificates.sh")
    process.exit(1);
}
https.createServer({
      key: fs.readFileSync(path + FILENAME_KEY),
      cert: fs.readFileSync(path + FILENAME_CERT),
      ciphers: "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4",
    }, app).listen(port);

var appDiscovery = new discovery(port);
appDiscovery.publish();

var btDiscovery = new btDiscovery(noble);
btDiscovery.on('discovered', function(peripheral) {
  bb8Controller.onDeviceDiscovered(peripheral) ;
});

console.log("May the Force be With You on Port: " + port);
