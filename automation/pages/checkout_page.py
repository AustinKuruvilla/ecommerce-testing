"""Checkout and payment page interactions."""

from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class CheckoutPage:
    PLACE_ORDER = (By.CSS_SELECTOR, "a[href='/payment']")
    NAME_ON_CARD = (By.CSS_SELECTOR, "[data-qa='name-on-card']")
    CARD_NUMBER = (By.CSS_SELECTOR, "[data-qa='card-number']")
    CVC = (By.CSS_SELECTOR, "[data-qa='cvc']")
    EXPIRY_MONTH = (By.CSS_SELECTOR, "[data-qa='expiry-month']")
    EXPIRY_YEAR = (By.CSS_SELECTOR, "[data-qa='expiry-year']")
    PAY_BUTTON = (By.CSS_SELECTOR, "[data-qa='pay-button']")
    CONFIRMATION = (By.CSS_SELECTOR, "[data-qa='order-placed']")

    def __init__(self, driver, timeout=10):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def place_order(self):
        self.wait.until(EC.element_to_be_clickable(self.PLACE_ORDER)).click()

    def pay(self, payment):
        fields = (
            (self.NAME_ON_CARD, payment["name_on_card"]),
            (self.CARD_NUMBER, payment["card_number"]),
            (self.CVC, payment["cvc"]),
            (self.EXPIRY_MONTH, payment["expiry_month"]),
            (self.EXPIRY_YEAR, payment["expiry_year"]),
        )
        for locator, value in fields:
            self.wait.until(EC.visibility_of_element_located(locator)).send_keys(value)
        self.driver.find_element(*self.PAY_BUTTON).click()
        return self.wait.until(EC.visibility_of_element_located(self.CONFIRMATION)).text