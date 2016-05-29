var bb8Model = require('../models/bb8.js');

// TODO: error handling is non existant
module.exports = function(app, router, controller) {
  'use strict';
  app.use('/droid', router);

  router.get('/discover', function(req, res) {
    // TODO: what about when the model isn't defined?
    res.setHeader('Content-Type', 'application/json');
    res.status(200);
    res.send(controller.JSONModel());
  });

  router.post('/subscribe', function(req, res) {
    // TODO: set a name here.
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
