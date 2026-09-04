# pacto-aa

Sole owner of **`PactoSimple7702Account`** — the shared storage-free EIP-7702 account used by squad and username sponsorship.

Part of epic [covenant-gov/pacto-aa#1](https://github.com/covenant-gov/pacto-aa/issues/1). Client signing contract: [`docs/CLIENT_CONTRACT.md`](docs/CLIENT_CONTRACT.md).

## What this is

| | |
|-|-|
| Account | `PactoSimple7702Account` — EP v0.7, bare ECDSA, IERC721 + IERC1155 receivers |
| Artifact | `deployments/<chainId>/eip7702-account.json` |
| Out of scope | Paymasters, pools, registry, Hats |

Downstream repos (`pacto-squad-sponsor`, `pacto-username-nft`, `pacto-app`) **pin this artifact** (and/or git-depend on this package). They must not maintain a local fork of the account.

## Setup

```bash
pnpm install
```

Requires [Foundry](https://book.getfoundry.sh/getting-started/installation). Copy `.env.example` → `.env` for deploy RPCs and keystore names.

## Build & test

```bash
pnpm build
pnpm test:unit
```

## Deploy (CREATE2)

Writes `deployments/<chainId>/eip7702-account.json` (`chainId`, `entryPoint`, `pactoSimple7702Account`, `salt`, `deployer`), then verifies on explorers.

```bash
# Sepolia (live broadcast — typically AA-2)
pnpm deploy:7702:sepolia

# Simulate only
pnpm simulate-deploy:7702:sepolia

# Stubs (same script, other chains)
pnpm deploy:7702:mainnet
pnpm deploy:7702:arbitrum
```

Salt: `PACTO_7702_ACCOUNT_SALT` (default `bytes32(0)`).

## Consumers

1. Read `pactoSimple7702Account` from the committed artifact for the target chain.
2. Use that address as the EIP-7702 set-code target and paymaster/registry allowlist value.
3. Sign UserOps per [`docs/CLIENT_CONTRACT.md`](docs/CLIENT_CONTRACT.md) (bare ECDSA over `userOpHash`).

## Dependencies

- `@account-abstraction/contracts@0.7.0`
- `@openzeppelin/contracts@5.1.0`
- `forge-std` v1.9.2
- Solidity `0.8.30`, EVM `prague`

## License

[MIT](LICENSE)
