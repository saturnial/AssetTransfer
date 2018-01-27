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

}
