import pytest

from pages.cart_page import CartPage
from pages.checkout_page import CheckoutPage
from pages.product_page import ProductPage
from utils.config import PRODUCT_SEARCH_TERM
from utils.test_data import CHECKOUT_DATA


@pytest.mark.smoke
@pytest.mark.requires_account
def test_signed_in_customer_can_complete_checkout(signed_in_customer, base_url):
    products = ProductPage(signed_in_customer, base_url).open().search(PRODUCT_SEARCH_TERM)
    assert products, f"No product found for search term {PRODUCT_SEARCH_TERM!r}"
    ProductPage(signed_in_customer, base_url).add_product_to_cart(products[0])

    cart = CartPage(signed_in_customer, base_url).open()
    assert products[0] in cart.product_names()
    cart.proceed_to_checkout()

    checkout = CheckoutPage(signed_in_customer)
    checkout.place_order()
    confirmation = checkout.pay(CHECKOUT_DATA)
    assert "order placed" in confirmation.casefold()