var assetTransfer = artifacts.require("../contracts/AssetTransfer.sol");

contract('AssetTransfer', function(accounts) {

  it("...should store the value 89.", function() {
    return assetTransfer.deployed().then(function(instance) {
      assetTransferInstance = instance;

      return assetTransferInstance.set(89, {from: accounts[0]});
    }).then(function() {
      return assetTransferInstance.get.call();
    }).then(function(storedData) {
      assert.equal(storedData, 89, "The value 89 was not stored.");
    });
  });

});
