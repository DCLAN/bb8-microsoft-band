var bb8Model = require('../models/bb8.js');

// TODO: error handling is non existant
module.exports = function(app, router, controller) {
  'use strict';
  app.use('/droid', router);

  router.get('/discover', function(req, res) {
    // TODO: here goes logic to find a UUID for a bb8 droid.
    // TODO: Returns all droids it is aware of...
    // TODO: actual discovery should be done in a seperate module
    var bb8 = bb8Model.create();
    bb8.name("Zig");
    bb8.uuid("15acde0142c44762aa78c0e01489278b");
    controller.initialize(bb8);

    res.setHeader('Content-Type', 'application/json');
    res.status(200);
    res.send(bb8.toJSON());
  });

  router.post('/subscribe', function(req, res) {
    if(!controller.isInitialized()) {
      res.status(500);
      res.setHeader('Content-Type', 'application/json');
      res.send("Not Initialized");
      return;
    }

    controller.connect(function() {
      res.status(200);
      res.setHeader('Content-Type', 'application/json');
      res.send(controller.JSONModel());
    });
  });

  router.post('/unsubscribe', function(req, res) {
    controller.disconnect(function() {
      res.status(200);
      res.setHeader('Content-Type', 'application/json');
      res.send(controller.JSONModel());
    });

    res.status(200);
    res.setHeader('Content-Type', 'application/json');
    res.send(controller.JSONModel());

  });

  router.post('/move', function(req, res) {
      controller.move();
      res.setHeader('Content-Type', 'application/json');
      res.status(200);
      res.send(controller.JSONModel());
  });

  router.post('/stop', function(req, res) {
    controller.stop();
    res.setHeader('Content-Type', 'application/json');
    res.status(200);
    res.send(controller.JSONModel());
  });
}
