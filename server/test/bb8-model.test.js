var chaiAssert = require('chai').assert;
var bb8Model = require('../app/models/bb8.js');

var bb8;
describe('bb8model.name', function(){
  before(function() {
    bb8 = bb8Model.create();
  });
  // obviously useless unit test, presuming the library is unit tested.
  // doing it to learn it.
  it('should initialize the model name', function() {
    var newName = "NewName";
    bb8.name(newName);

    chaiAssert(bb8.name() === newName, "Model didn't update its name");
  });
  it('should accept a name after it is already set', function() {
    var newName = "NewName";
    var originalName = "OriginalName";
    bb8.name(originalName);
    bb8.name(newName);

    chaiAssert(bb8.name() === newName, "Model didn't update its name");
  });
  it('should reject undefined names', function() {
    var name = undefined;
    bb8.name(name);
    bb8.validate();
    chaiAssert(!bb8.isValid, "Model name is invalid when it is undefined.");
  });
  it('should be a string', function() {
    var name = { test: "hello "};
    bb8.name(name);
    bb8.validate();
    chaiAssert(!bb8.isValid, "Model name should be a string");
  });
});
describe('bb8Model.uuid', function() {
  before(function() {
    bb8 = bb8Model.create();
  });
  it('should initialize the model uuid', function() {
    var uuid = "asdf12345";
    var bb8 = bb8Model.create();
    bb8.uuid(uuid);

    chaiAssert(bb8.uuid() === uuid, "Model didn't update its uuid");
  });
  it('should accept a name after it is already set', function() {
    var uuid = "123456asdf";
    var originaluuid = "asdf12345";

    bb8.uuid(originaluuid);
    bb8.uuid(uuid);

    chaiAssert(bb8.uuid() === uuid, "Model didn't update its uuid");
  });
  it('should reject undefined uuid', function() {
    var uuid = undefined;
    bb8.uuid(uuid);
    bb8.validate();

    chaiAssert(!bb8.isValid, "Model uiid is invalid when it is undefined.");
  });
  it('should be a string', function() {
    var uuid = { test: "hello "};
    bb8.uuid(uuid);
    bb8.validate();
    chaiAssert(!bb8.isValid, "Model uuid should be a string");
  });
});
