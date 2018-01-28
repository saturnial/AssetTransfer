import React, { Component } from 'react'
import AssetTransfer from '../build/contracts/AssetTransfer.json'
import getWeb3 from './utils/getWeb3'
// import bluebird from 'bluebird';
// bluebird.promisifyAll(getWeb3);
import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      moreStorage: 0,
      web3: null
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
      .then(results => {
        this.setState({
          web3: results.web3
        })

        // Instantiate contract once web3 provided.
        this.instantiateContract()
        this.getAssetsForCompany();
      })
      .catch(() => {
        console.log('Error finding web3.')
      })
  }

  getCompanyList() {

    const contract = require('truffle-contract')
    const assetTransfer = contract(AssetTransfer)
    assetTransfer.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on assetTransfer.
    var assetTransferInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      assetTransfer.deployed()
      .then((instance) => {
        assetTransferInstance = instance;
        return assetTransferInstance.registerNewCompany(accounts[0], this.state.web3.fromAscii("hello"), this.state.web3.fromAscii("there"), { from: accounts[0], gas: 3000000 });
      })
      .then((res) => {
        // Get the value from the contract to prove it worked.
        return assetTransferInstance.numCompanies.call(accounts[0]);
      })
      .then((result) => {
        return assetTransferInstance.getCompanies.call(accounts[0]);
      })
      .then((result) => {

        return this.setState({ storageValue: result.map((x) => this.state.web3.toAscii(x)) });
      })
    })
  }
  
  getAssetsForCompany() {

    const contract = require('truffle-contract')
    const assetTransfer = contract(AssetTransfer)
    assetTransfer.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on assetTransfer.
    var assetTransferInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      assetTransfer.deployed()
      .then((instance) => {
        assetTransferInstance = instance;
        return assetTransferInstance.registerNewAssetToCompany(accounts[0], this.state.web3.fromAscii("gold"));
      })
      .then((res) => {
        // Get the value from the contract to prove it worked.
        return assetTransferInstance.getCompanyAssets.call(accounts[0], this.state.web3.fromAscii("hello"));
      })
      .then((result) => {

        return this.setState({ moreStorage: result.map((x) => this.state.web3.toAscii(x)) });
      })
    })
  }

  pack(bytes) {
    var str = "";
    for (var i = 0; i < bytes.length; i += 2) {
      var char = bytes[i] << 8;
      if (bytes[i + 1])
        char |= bytes[i + 1];
      str += String.fromCharCode(char);
    }
    return str;
  }

  unpack(str) {
    var bytes = [];
    for (var i = 0; i < str.length; i++) {
      var char = str.charCodeAt(i);
      bytes.push(char >>> 8);
      bytes.push(char & 0xFF);
    }
    return bytes;
  }


  render() {
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
          <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Good to Go!</h1>
              <p>Your Truffle Box is installed and ready.</p>
              <h2>Smart Contract Example</h2>
              <p>If your contracts compiled and migrated successfully, below will show a stored value of 5 (by default).</p>
              <p>Try changing the value stored on <strong>line 59</strong> of App.js.</p>
              <p>The stored value is: {this.state.storageValue}</p>
              <p>The assets for company hello are: {this.state.moreStorage}</p>
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
