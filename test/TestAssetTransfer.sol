pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/AssetTransfer.sol";

contract TestAssetTransfer {
//  event debug(uint);

 function testRegisterCopmanies() public {
   AssetTransfer assetTransfer = AssetTransfer(DeployedAddresses.AssetTransfer());
   assetTransfer.registerNewCompany("company1","desc1");
   assetTransfer.registerNewCompany("company2","desc2");
   assetTransfer.registerNewCompany("company3","desc3");

   uint expComp = 3;

//    console.log(assetTransfer.numCompanies());    
  //  debug(assetTransfer.numCompanies());
  //  Assert.isTrue(false,"");
   Assert.equal(assetTransfer.numCompanies(),expComp,"Num Companies not equal to 3");
 }
}
