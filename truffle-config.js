module.exports = {
  compilers: {
    solc: {
      version: "0.5.16",
    }
  },
  networks: {
    ganache: {
      host: "localhost",
      port: 7545,
      network_id: "*" // Match any network id
    }
  }
};
