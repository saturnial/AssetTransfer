pragma solidity ^0.4.2;

contract AssetTransfer {

  struct Company {
    uint id;
    string name;
    string description;
  }

  address admin;

  uint public numCompanies;
  mapping (uint => Company) public companies;

  event NewCompanyRegistered(uint id);

  function registerNewCompany(string _name, string _description) public returns (uint companyID) {
  function AssetTransfer() public {
    admin = msg.sender;
  }

  modifier adminOnly() {
    require(msg.sender == admin);
    _;
  }

    companyID = numCompanies++; // companyID is return variable.
    companies[companyID] = Company({id: companyID, name: _name, description: _description});
    NewCompanyRegistered(companyID);
  }

}
