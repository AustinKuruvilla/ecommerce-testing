"""Login page actions and observable state."""

from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class LoginPage:
    EMAIL = (By.CSS_SELECTOR, "[data-qa='login-email']")
    PASSWORD = (By.CSS_SELECTOR, "[data-qa='login-password']")
    SUBMIT = (By.CSS_SELECTOR, "[data-qa='login-button']")
    ERROR = (By.CSS_SELECTOR, "form[action='/login'] p")

    def __init__(self, driver, base_url, timeout=10):
        self.driver = driver
        self.base_url = base_url.rstrip("/")
        self.wait = WebDriverWait(driver, timeout)

    def open(self):
        self.driver.get(f"{self.base_url}/login")
        self.wait.until(EC.visibility_of_element_located(self.EMAIL))
        return self

    def login(self, email, password):
        self.driver.find_element(*self.EMAIL).send_keys(email)
        self.driver.find_element(*self.PASSWORD).send_keys(password)
        self.driver.find_element(*self.SUBMIT).click()

    def error_message(self):
        return self.wait.until(EC.visibility_of_element_located(self.ERROR)).text