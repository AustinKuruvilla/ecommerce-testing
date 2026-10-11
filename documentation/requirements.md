# E-commerce Requirements

These sample requirements define the contract exercised by the project. Replace or confirm them against the actual product before sign-off.

| ID | Requirement | Priority | Acceptance summary |
|---|---|---|---|
| REQ-001 | Customer authentication | High | A registered customer can sign in with valid credentials; invalid credentials do not create a session. |
| REQ-002 | Product search | High | Search returns products whose displayed names match the submitted term; no-match searches show an empty state. |
| REQ-003 | Cart management | High | A customer can add a product, see its name and price in the cart, and remove it. |
| REQ-004 | Cart totals | High | Subtotal and order total reflect the current quantities and applicable charges. |
| REQ-005 | Checkout validation | High | Required delivery and payment fields are validated before order submission. |
| REQ-006 | Order confirmation | High | A successful checkout creates one order and displays a confirmation to the customer. |
| REQ-007 | Inventory integrity | Medium | An order cannot reduce available inventory below zero. |
| REQ-008 | Data protection | High | Passwords and payment details are not exposed in logs or stored as plain text. |