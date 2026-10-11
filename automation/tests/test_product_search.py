from pages.product_page import ProductPage
from utils.config import PRODUCT_SEARCH_TERM
from utils.test_data import SEARCH_TERMS


def test_search_returns_matching_products(driver, base_url):
    names = ProductPage(driver, base_url).open().search(PRODUCT_SEARCH_TERM)
    assert names
    assert all(PRODUCT_SEARCH_TERM.casefold() in name.casefold() for name in names)


def test_search_without_matches_shows_no_products(driver, base_url):
    names = ProductPage(driver, base_url).open().search(SEARCH_TERMS["no_match"])
    assert names == []