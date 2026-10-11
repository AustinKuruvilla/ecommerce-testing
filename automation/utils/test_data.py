"""Non-sensitive data used by the UI tests."""

INVALID_CREDENTIALS = ("invalid-user@example.test", "not-a-real-password")
SEARCH_TERMS = {
    "matching": "Blue Top",
    "no_match": "product-name-that-does-not-exist-987654",
}
CHECKOUT_DATA = {
    "name_on_card": "QA Test Customer",
    "card_number": "4111111111111111",
    "cvc": "123",
    "expiry_month": "12",
    "expiry_year": "2030",
}