pragma solidity ^0.4.18;

contract AssetTransfer {

  struct Company {
    uint id;
    address owner;
    bytes32 name;
    bytes32 description;
    mapping (uint => Asset) assets;
    bytes32[10] companyAssets;
    uint assetIdx;
    uint numAssets;
  }

  struct Asset {
    uint id;
    bytes32 name;
  }

  address admin;

  uint public numCompanies;
  uint public numAssets;
  mapping (uint => address) public assetRegistry;
  mapping (address => Company) public companies;
  bytes32[10] public allCompanies;
  bytes32[10] public allAssets;

  mapping(address => mapping (address => uint)) allowed;

  event NewCompanyRegistered(address _owner, uint _companyID);
  event NewAssetRegisteredToCompany(address _owner, uint _assetID);

  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function AssetTransfer() public {
    admin = msg.sender;
  }

  modifier adminOnly() {
    require(msg.sender == admin);
    _;
  }

  function registerNewCompany(address _owner, bytes32 _name, bytes32 _description) public adminOnly returns (uint companyID) {
    companyID = numCompanies++;
    companies[_owner].id = companyID;
    companies[_owner].owner = _owner;
    companies[_owner].name = _name;
    companies[_owner].description = _description;
    allCompanies[numCompanies] = companies[_owner].name;
    NewCompanyRegistered(_owner, companyID);
  }

  function registerNewAssetToCompany(address _owner, bytes32 _name) public returns (uint assetID) {
    assetID = numAssets++;
    companies[_owner].assets[assetID] = Asset(assetID, _name);
    companies[_owner].companyAssets[companies[_owner].assetIdx] = _name;
    companies[_owner].assetIdx++;
    assetRegistry[assetID] = _owner;
    NewAssetRegisteredToCompany(_owner, assetID);
  }

  function validateAssetId(uint _assetId) internal view returns (bool valid) {
    return _assetId <= numAssets;
  }

  function transferAsset(uint _assetId, address _from, address _to) internal {
    require(validateAssetId(_assetId));
    require(_from != _to);
    require(allowed[_from][_to] == _assetId);

    assetRegistry[_assetId] = _to;

    companies[_to].assets[_assetId] = companies[_from].assets[_assetId];
    delete companies[_from].assets[_assetId];

    companies[_to].numAssets++;
    companies[_from].numAssets--;

    Transfer(_from, _to, _assetId);
  }

  /* ERC721 implementation */

  function name() public pure returns (bytes32 _name) {
    return "Asset";
  }

  function symbol() public pure returns (bytes32 _symbol) {
    return "AST";
  }

  function totalSupply() public constant returns (uint _totalSupply) {
    return numAssets;
  }

  function balanceOf(address _owner) public constant returns (uint balance) {
    return companies[_owner].numAssets;
  }

  function ownerOf(uint _tokenId) public constant returns (address owner) {
    return assetRegistry[_tokenId];
  }

  function approve(address _to, uint _tokenId) public {
    require(validateAssetId(_tokenId));
    require(msg.sender == ownerOf(_tokenId));
    require(msg.sender != _to);

    allowed[msg.sender][_to] = _tokenId;
    Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint _tokenId) public {
    address oldOwner = ownerOf(_tokenId);
    address newOwner = msg.sender;
    transferAsset(_tokenId, oldOwner, newOwner);
  }

  function transfer(address _to, uint _tokenId) public {
    address oldOwner = ownerOf(_tokenId);
    transferAsset(_tokenId, oldOwner, _to);
  }

  function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint tokenId) {
    return companies[_owner].assets[_index].id;
  }

  function tokenMetadata(uint _tokenId) public view returns (bytes32 _info) {
    require(validateAssetId(_tokenId));
    address owner = ownerOf(_tokenId);
    return companies[owner].assets[_tokenId].name;
  }

  function getCompanies() public view returns(bytes32[10]) {
    return allCompanies;
  }

  function getCompanyAssets(address _owner) public view returns(bytes32[10]) {
    return companies[_owner].companyAssets;
  }

}
