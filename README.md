# E-commerce Testing

Sample functional QA project for an online store. The UI suite uses Selenium and pytest against [Automation Exercise](https://automationexercise.com/) by default; set `BASE_URL` to point it at another compatible test application.

## Project contents

- `documentation/`: test plan, requirements, scenarios, cases, traceability, defects, and execution report.
- `api/`: Postman collection template for a REST e-commerce API.
- `sql/`: sample MySQL schema, seed data, and validation queries.
- `automation/`: Selenium page objects and pytest UI tests.
- `.github/workflows/tests.yml`: CI workflow for the automation suite.

## Run the UI tests

Use Python 3.10 or newer. From `automation/`, install dependencies and run:

```powershell
python -m pip install -r requirements.txt
python -m pytest
```

Selenium Manager downloads a compatible browser driver when needed. Chrome runs headless by default. Override `BASE_URL` to test another deployment. Tests that require an existing account are skipped unless `TEST_EMAIL` and `TEST_PASSWORD` are set in the environment. Never commit real credentials.

Optional environment variables are listed in `automation/utils/config.py`; start from `automation/.env.example` and save local values in `automation/.env` (ignored by Git).

## API collection

Import `api/postman_collection.json` into Postman and set the collection variable `baseUrl` to the API under test. The collection describes a conventional REST contract and is a template; adapt endpoint paths and payloads to the target service.

## Database samples

The SQL scripts target MySQL 8. Run `schema.sql`, then `test_data.sql`, and use `validation_queries.sql` to inspect sample order and inventory consistency.
