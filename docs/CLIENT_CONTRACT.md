# Client contract — PactoSimple7702Account

**Audience:** `pacto-app`, `pacto-squad-sponsor`, `pacto-username-nft`, and any client that set-codes roster EOAs for ERC-4337 UserOps.

This repo owns the **sole shared EIP-7702 account** implementation. It does **not** define paymasters, pools, registries, or Hats policy.

---

## Role

Bare EOAs cannot implement `validateUserOp`. Clients set-code the EOA to `PactoSimple7702Account`, then submit a UserOp with `sender ==` that EOA.

| Concern | Value |
|---------|--------|
| Set-code target | `pactoSimple7702Account` in [`deployments/<chainId>/eip7702-account.json`](../deployments/) |
| EntryPoint | `0x0000000071727De22E5E9d8BAf0edAc6f37da032` (v0.7) |
| Nonce | `entryPoint.getNonce(sender, key=0)` |
| Signature | Raw 65-byte ECDSA over EntryPoint `getUserOpHash` (Electrum `v` 27/28) — **not** `personal_sign`, **not** Alchemy MAv2 packing |
| Calldata | `execute(address,uint256,bytes)` wrapping the inner call |

`execute` selector: `0xb61d27f6`.

---

## Validation rules

- Storage-free: no mutable account state; EntryPoint is a constant.
- `_validateSignature` / ERC-1271: `ECDSA.tryRecover(hash, signature)` must equal `address(this)` (the delegated EOA).
- `execute` only from EntryPoint or self (7702 self-call).
- Receivers (empty-revert safe for `_safeMint` / safe transfers):
  - `IERC721Receiver.onERC721Received`
  - `IERC1155Receiver.onERC1155Received` / `onERC1155BatchReceived`
  - `supportsInterface` for IERC721Receiver, IERC1155Receiver, IERC165

---

## Artifact schema

After `pnpm deploy:7702:<network>`, commit:

```json
{
  "chainId": 11155111,
  "deployer": "0x…",
  "entryPoint": "0x0000000071727De22E5E9d8BAf0edAc6f37da032",
  "pactoSimple7702Account": "0x…",
  "salt": "0x0000000000000000000000000000000000000000000000000000000000000000"
}
```

Consumers pin `pactoSimple7702Account` (allowlists, address books). Do **not** copy the Solidity into downstream repos.
