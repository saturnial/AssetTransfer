pragma solidity ^0.4.2;

contract AssetTransfer {

  struct Company {
    uint id;
    address owner;
    string name;
    string description;
    mapping (uint => Asset) assets;
    uint numAssets;
  }

  struct Asset {
    uint id;
    string name;
    uint price;
  }

  address admin;

  uint public numCompanies;
  uint public numAssets;
  mapping (uint => address) public assetRegistry;
  mapping (address => Company) public companies;

  mapping (address => uint) balances;

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

  function registerNewCompany(address _owner, string _name, string _description) public adminOnly returns (uint companyID) {
    companyID = numCompanies++;
    companies[_owner].id = companyID;
    companies[_owner].owner = _owner;
    companies[_owner].name = _name;
    companies[_owner].description = _description;
    NewCompanyRegistered(_owner, companyID);
  }

  function registerNewAssetToCompany(address _owner, string _name, uint _price) public returns (uint assetID) {
    assetID = numAssets++;
    companies[_owner].assets[assetID]= Asset(assetID, _name, _price);
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

  function priceOf(uint _assetId) internal view returns (uint _price) {
    return companies[ownerOf(_assetId)].assets[_assetId].price;
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

  function balanceOf(address _owner) public constant returns (uint balance) {
    return companies[_owner].numAssets;
  }

  function ownerOf(uint _tokenId) public constant returns (address owner) {
    return assetRegistry[_tokenId];
  }

  function approve(address _to, uint _tokenId) public payable {
    require(validateAssetId(_tokenId));

    address owner = ownerOf(_tokenId);
    uint price = priceOf(_tokenId);

    require(msg.sender == owner);
    require(msg.sender != _to);
    require(msg.value >= price);

    owner.transfer(price);

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

  function tokenMetadata(uint _tokenId) public view returns (string _info) {
    require(validateAssetId(_tokenId));
    address owner = ownerOf(_tokenId);
    return companies[owner].assets[_tokenId].name;
  }

}
