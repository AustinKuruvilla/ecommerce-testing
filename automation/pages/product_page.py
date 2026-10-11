"""Product listing and search interactions."""

from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class ProductPage:
    SEARCH = (By.ID, "search_product")
    SEARCH_BUTTON = (By.ID, "submit_search")
    SEARCH_RESULTS_HEADING = (
        By.XPATH,
        "//h2[contains(translate(normalize-space(.), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'searched products')]",
    )
    PRODUCT_CARDS = (By.CSS_SELECTOR, ".features_items .product-image-wrapper")
    PRODUCT_NAMES = (By.CSS_SELECTOR, ".features_items .product-image-wrapper p")
    ADD_TO_CART = (By.CSS_SELECTOR, ".features_items .product-image-wrapper a.add-to-cart")

    def __init__(self, driver, base_url, timeout=10):
        self.driver = driver
        self.base_url = base_url.rstrip("/")
        self.wait = WebDriverWait(driver, timeout)

    def open(self):
        self.driver.get(f"{self.base_url}/products")
        self.wait.until(EC.visibility_of_element_located(self.SEARCH))
        return self

    def search(self, term):
        field = self.wait.until(EC.element_to_be_clickable(self.SEARCH))
        field.clear()
        field.send_keys(term)
        self.driver.find_element(*self.SEARCH_BUTTON).click()
        self.wait.until(EC.visibility_of_element_located(self.SEARCH_RESULTS_HEADING))
        return self.product_names()

    def product_names(self):
        return [element.text.strip() for element in self.driver.find_elements(*self.PRODUCT_NAMES)]

    def add_product_to_cart(self, product_name):
        cards = self.wait.until(EC.presence_of_all_elements_located(self.PRODUCT_CARDS))
        for card in cards:
            name = card.find_element(By.CSS_SELECTOR, "p").text.strip()
            if name.casefold() == product_name.casefold():
                card.find_element(By.CSS_SELECTOR, "a.add-to-cart").click()
                return
        raise AssertionError(f"Product not found in the catalog: {product_name}")