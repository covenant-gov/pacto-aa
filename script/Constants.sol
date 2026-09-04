// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @dev Foundry routes `new Contract{salt:}` in broadcast scripts through Nick's CREATE2 deployer.
address constant CREATE2_DEFAULT_DEPLOYER = 0x4e59b44847b379578588920cA78FbF26c0B4956C;

/// @notice Public chain constants for EIP-7702 account deploys.
/// @dev Private values (RPC URLs, API keys, deployer keystore names) live in `.env` only.
library Constants {
  /**
   * @notice Chain-level deployment configuration.
   * @param chainId The supported network's chain ID.
   * @param entryPoint ERC-4337 EntryPoint v0.7 (canonical address).
   */
  struct ChainConfig {
    uint256 chainId;
    address entryPoint;
  }

  /// @notice Returns chain configuration for `chainId`.
  function getConfig(uint256 chainId) internal pure returns (ChainConfig memory config) {
    if (chainId == 1) return _mainnet();
    if (chainId == 11_155_111) return _sepolia();
    if (chainId == 42_161) return _arbitrum();
    revert UnsupportedChain(chainId);
  }

  /// @notice CREATE2 deployer used by Foundry broadcast scripts (`new Contract{salt:}`).
  function create2Deployer() internal pure returns (address) {
    return CREATE2_DEFAULT_DEPLOYER;
  }

  function _mainnet() private pure returns (ChainConfig memory) {
    return ChainConfig({chainId: 1, entryPoint: 0x0000000071727De22E5E9d8BAf0edAc6f37da032});
  }

  function _sepolia() private pure returns (ChainConfig memory) {
    return ChainConfig({chainId: 11_155_111, entryPoint: 0x0000000071727De22E5E9d8BAf0edAc6f37da032});
  }

  function _arbitrum() private pure returns (ChainConfig memory) {
    return ChainConfig({chainId: 42_161, entryPoint: 0x0000000071727De22E5E9d8BAf0edAc6f37da032});
  }

  error UnsupportedChain(uint256 chainId);
}
