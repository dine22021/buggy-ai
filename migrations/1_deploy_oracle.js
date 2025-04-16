const OracleBounty = artifacts.require("OracleBounty");

module.exports = function (deployer) {
  deployer.deploy(OracleBounty);
};
