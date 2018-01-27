pragma solidity ^0.4.2;

contract AssetTransfer {

  struct Company {
    uint id;
    address owner;
    string name;
    string description;
    mapping (uint => Asset) assets;
  }

  struct Asset {
    uint id;
    string name;
  }

  address admin;

  uint public numCompanies;
  uint public numAssets;
  mapping (uint => Company) public companies;

  event NewCompanyRegistered(uint _companyID);
  event NewAssetRegisteredToCompany(uint _assetID, uint _companyID);
  event AssetTransfered(uint _assetID, uint _toCompanyID, uint _fromCompanyID);

  function AssetTransfer() public {
    admin = msg.sender;
  }

  modifier adminOnly() {
    require(msg.sender == admin);
    _;
  }

  function registerNewCompany(string _name, string _description) public adminOnly returns (uint companyID) {
    companyID = numCompanies++;
    companies[companyID].id = companyID;
    companies[companyID].name = _name;
    companies[companyID].description = _description;
    NewCompanyRegistered(companyID);
  }

  function registerAssetToCompany(string _name, uint _companyID) public returns (uint assetID) {
    assetID = numAssets++;
    companies[_companyID].assets[assetID]= Asset(assetID, _name);
    NewAssetRegisteredToCompany(assetID, _companyID);
  }

  function transferAssetToCompany(uint _assetID, uint _toCompanyID, uint _fromCompanyID) public {
    companies[_toCompanyID].assets[_assetID] = companies[_fromCompanyID].assets[_assetID];
    delete companies[_fromCompanyID].assets[_assetID];
    AssetTransfered(_assetID, _toCompanyID, _fromCompanyID);
  }

  /* ERC721 implementation */

  function name() public pure returns (string _name) {
    return "Asset";
  }

  function symbol() public pure returns (string _symbol) {
    return "AST";
  }

  function totalSupply() public constant returns (uint _totalSupply) {
    return numAssets;
  }

}
