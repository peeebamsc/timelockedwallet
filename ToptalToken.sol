pragma solidity 0.5.16;

import "./TimeLockedWallet.sol";

contract TimeLockedWalletFactory {
    // Mapping of user's address to the array of TimeLockedWallet contracts they created
    mapping(address => address[]) wallets;

    // Get all wallets created by a user
    function getWallets(address _user) public view returns (address[] memory) {
        return wallets[_user];
    }

    // Create a new TimeLockedWallet contract
    function newTimeLockedWallet(address payable _owner, uint256 _unlockDate)
        payable
        public
        returns (address wallet)
    {
        // Create new wallet.
        wallet = address(new TimeLockedWallet(msg.sender, _owner, _unlockDate));

        // Add wallet to sender's wallets.
        wallets[msg.sender].push(wallet);

        // If owner is the same as sender then add wallet to sender's wallets too.
        if (msg.sender != _owner) {
            wallets[_owner].push(wallet);
        }

        // Send ether from this transaction to the created contract.
        address(uint160(address(wallet))).transfer(msg.value);

        // Emit event.
        emit Created(wallet, msg.sender, _owner, now, _unlockDate, msg.value);
    }

    // Fallback function to prevent accidental sending of ether to the factory
    function () external payable {
        revert();
    }

    // Event to track creation of a new TimeLockedWallet contract
    event Created(address wallet, address from, address to, uint256 createdAt, uint256 unlockDate, uint256 amount);
}
