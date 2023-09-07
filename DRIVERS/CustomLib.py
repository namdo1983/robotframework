from get_chrome_driver import GetChromeDriver
from robot.libraries.OperatingSystem import OperatingSystem
from os.path import join
from pathlib import Path
from robot.api.deco import keyword

myOS = OperatingSystem()
CURDIR = Path(__file__).resolve().parent


class CustomLib:
    @keyword("My Chrome")
    def get_chrome(self):
        """DL chrome driver to current dir"""
        # Adds the downloaded ChromeDriver to path
        MY_CHROME = join(CURDIR, "chrome")
        myOS.create_directory(MY_CHROME)
        get_driver = GetChromeDriver()
        get_driver.install(MY_CHROME)

        full_p = join(MY_CHROME, "chromedriver.exe")
        print("chrome full path", full_p)
        return full_p
