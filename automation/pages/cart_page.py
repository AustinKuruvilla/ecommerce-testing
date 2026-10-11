"""Shopping cart page interactions."""

from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class CartPage:
    CART_ROWS = (By.CSS_SELECTOR, "#cart_info_table tbody tr[id^='product-']")
    PRODUCT_NAME = (By.CSS_SELECTOR, ".cart_description h4 a")
    QUANTITY = (By.CSS_SELECTOR, ".cart_quantity button")
    CHECKOUT = (By.CSS_SELECTOR, "a.check_out")

    def __init__(self, driver, base_url, timeout=10):
        self.driver = driver
        self.base_url = base_url.rstrip("/")
        self.wait = WebDriverWait(driver, timeout)

    def open(self):
        self.driver.get(f"{self.base_url}/view_cart")
        self.wait.until(EC.visibility_of_element_located((By.ID, "cart_info_table")))
        return self

    def product_names(self):
        return [element.text.strip() for element in self.driver.find_elements(*self.PRODUCT_NAME)]

    def quantities(self):
        return [element.text.strip() for element in self.driver.find_elements(*self.QUANTITY)]

    def proceed_to_checkout(self):
        self.wait.until(EC.element_to_be_clickable(self.CHECKOUT)).click()