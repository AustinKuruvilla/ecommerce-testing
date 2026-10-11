"""Shared browser setup and account fixtures."""

import pytest
from selenium import webdriver

from pages.login_page import LoginPage
from utils.config import BASE_URL, BROWSER, HEADLESS, PAGE_LOAD_TIMEOUT, TEST_EMAIL, TEST_PASSWORD


@pytest.fixture
def driver():
    if BROWSER != "chrome":
        pytest.fail(f"Unsupported BROWSER={BROWSER!r}; this project currently configures Chrome only")
    options = webdriver.ChromeOptions()
    if HEADLESS:
        options.add_argument("--headless=new")
    options.add_argument("--window-size=1440,1000")
    options.add_argument("--no-sandbox")
    browser = webdriver.Chrome(options=options)
    browser.set_page_load_timeout(PAGE_LOAD_TIMEOUT)
    yield browser
    browser.quit()


@pytest.fixture
def base_url():
    return BASE_URL


@pytest.fixture
def signed_in_customer(driver, base_url):
    if not TEST_EMAIL or not TEST_PASSWORD:
        pytest.skip("Set TEST_EMAIL and TEST_PASSWORD for account-dependent tests")
    LoginPage(driver, base_url).open().login(TEST_EMAIL, TEST_PASSWORD)
    return driver