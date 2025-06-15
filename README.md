# 💸 CrowdFunding Smart Contract

**CrowdFunding** is a secure and transparent Ethereum smart contract that enables users to contribute to a fundraising goal. If the target is met before the deadline, the project owner can withdraw the funds. Otherwise, contributors can request refunds after the deadline.

---

## ✨ Features

- 🧾 **Fundraising Campaign Setup**  
  - Owner sets the `fundingGoal`, `deadline`, and `description` during deployment.

- 👥 **User Contributions**  
  - Anyone can contribute funds (above 0).  
  - Tracks each contributor’s total donation.  
  - Prevents address(0) from interacting.

- 🔐 **Security**  
  - Only the contract owner can withdraw funds (if goal is reached).  
  - Contributors can refund if deadline passes **and** goal is not met.  
  - All balance calculations are safe from overflows (Solidity 0.8+).

- 📊 **Transparency**  
  - Public view of `totalRaised`, `goal`, `deadline`, and `purpose`.

---

## ⚙️ Functions

### Public
- `contribute()` — Users send ETH to support the campaign.
- `refund()` — Contributors can get their funds back if goal is not met and deadline has passed.
- `getContribution(address)` — Returns the amount contributed by an address.
- `getDetails()` — Returns goal, raised amount, deadline, and description.

### Owner Only
- `withdraw()` — Owner withdraws funds only if goal is reached before deadline.

---

## 🧪 Test Coverage (Foundry)

The test suite checks the following:
- ✅ Contributors can donate.
- ✅ Reverts on zero-value donations.
- ✅ Only owner can withdraw (after goal is met).
- ✅ Refund works only after deadline if goal is unmet.
- ✅ Prevents unauthorized access or misuse.

---

## 🛠 Tech Stack

- **Solidity**: ^0.8.24  
- **Foundry**: Fast testing and deployment  
- **EVM Compatible**  

---

## 📌 Use Case Example

A project creator wants to raise 100 ETH in 30 days to build a product.  
- Sets the deadline and goal in constructor.  
- Shares contract address publicly.  
- Contributors donate ETH.  
- If 100 ETH is raised in time, creator calls `withdraw()`.  
- If not, contributors call `refund()` to get their ETH back.

---

## 🧠 Ideal For

- Students learning Solidity and smart contract security.
- Demos or Proof-of-Concept (PoC) campaigns.
- Web3 hackathon or charity-style dApps.

---

## 📄 License

MIT — free to use and modify.

---

## 🙌 Acknowledgements

Built as a student-level project to demonstrate core principles of decentralized fundraising and transparency.

---

