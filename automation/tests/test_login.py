import pytest
from selenium.webdriver.support.ui import WebDriverWait

from pages.login_page import LoginPage
from utils.config import TEST_EMAIL, TEST_PASSWORD
from utils.test_data import INVALID_CREDENTIALS


@pytest.mark.smoke
def test_login_rejects_invalid_credentials(driver, base_url):
    page = LoginPage(driver, base_url).open()
    page.login(*INVALID_CREDENTIALS)
    assert "incorrect" in page.error_message().casefold()


@pytest.mark.smoke
@pytest.mark.requires_account
def test_registered_customer_can_log_in(driver, base_url):
    if not TEST_EMAIL or not TEST_PASSWORD:
        pytest.skip("Set TEST_EMAIL and TEST_PASSWORD to use a pre-created test account")
    LoginPage(driver, base_url).open().login(TEST_EMAIL, TEST_PASSWORD)
    WebDriverWait(driver, 10).until(lambda browser: "Logged in as" in browser.page_source)
    assert "Logged in as" in driver.page_source