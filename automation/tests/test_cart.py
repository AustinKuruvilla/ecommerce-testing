from pages.cart_page import CartPage
from pages.product_page import ProductPage
from utils.config import PRODUCT_SEARCH_TERM


def test_customer_can_add_searched_product_to_cart(driver, base_url):
    products = ProductPage(driver, base_url).open().search(PRODUCT_SEARCH_TERM)
    assert products, f"No product found for search term {PRODUCT_SEARCH_TERM!r}"
    selected_product = products[0]

    ProductPage(driver, base_url).add_product_to_cart(selected_product)
    cart = CartPage(driver, base_url).open()

    assert selected_product in cart.product_names()
    assert "1" in cart.quantities()