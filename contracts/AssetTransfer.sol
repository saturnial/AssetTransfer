pragma solidity ^0.4.2;

contract AssetTransfer {

  struct Company {
    uint id;
    string name;
    string description;
  }

  uint numCompanies;
  mapping (uint => Company) companies;

  event NewCompanyRegistered(uint id);

  function registerNewCompany(string _name, string _description) public returns (uint companyID) {
    companyID = numCompanies++; // companyID is return variable.
    companies[companyID] = Company({id: companyID, name: _name, description: _description});
    NewCompanyRegistered(companyID);
  }

}
