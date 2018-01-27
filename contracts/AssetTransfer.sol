pragma solidity ^0.4.2;

contract AssetTransfer {

  struct Company {
    uint id;
    string name;
    string description;
  }

  struct Asset {
    uint id;
    string name;
  }

  address admin;

  uint public numCompanies;
  mapping (uint => Company) public companies;

  event NewCompanyRegistered(uint id);

  function AssetTransfer() public {
    admin = msg.sender;
  }

  modifier adminOnly() {
    require(msg.sender == admin);
    _;
  }

  function registerNewCompany(string _name, string _description) public adminOnly returns (uint companyID) {
    companyID = numCompanies++; // companyID is return variable.
    companies[companyID] = Company({id: companyID, name: _name, description: _description});
    NewCompanyRegistered(companyID);
  }

}
