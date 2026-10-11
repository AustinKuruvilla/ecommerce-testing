# E-commerce Test Plan

## Purpose

Validate the core customer journey for a web storefront: account sign-in, product discovery, cart updates, and checkout. The project is a reusable starter; confirm target-specific behavior and acceptance criteria with the product owner before execution.

## Scope

In scope: valid and invalid login, product search results, adding a product to the cart, cart contents and totals, and checkout completion with valid test data.

Out of scope: payment-provider authorization, production data, load/security testing, and third-party email delivery.

## Approach

- Manual scenarios and detailed cases are maintained in the accompanying workbooks.
- UI regression examples use pytest, Selenium WebDriver, and page objects.
- REST and database artifacts are contract examples and must be aligned with the system under test.
- Run smoke tests on each pull request; run the full suite on the default branch and before release.

## Environment and data

Default UI target: Automation Exercise demo site. Override `BASE_URL` for another environment. Use a dedicated, pre-created test account via `TEST_EMAIL` and `TEST_PASSWORD`; do not use customer or production data. The demo site is external and may be unavailable or change without notice.

## Entry criteria

- Target environment is reachable and its test account is active.
- Browser and Python dependencies are available.
- Test data and endpoint contract have been reviewed for the target.

## Exit criteria

- All planned high-priority cases have a recorded result.
- No open critical or high-severity defects remain without an approved disposition.
- Failures are triaged and the execution report is updated.

## Risks

External demo availability and markup changes can cause false failures. Keep selectors isolated in page objects, capture the target URL and browser version in CI logs, and re-run transient infrastructure failures before filing product defects.