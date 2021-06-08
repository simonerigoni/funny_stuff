# Example of google search using selenium: try to convert USD in EURO
#
# python example_selenium_google_search.py


import time
from selenium import webdriver


URL = 'http://www.google.com'
SLEEP_TIME = 5
DOLLARS = 1000

if __name__ == '__main__':
    print('Connect to: {}'.format(URL))
    driver = webdriver.Firefox()
    driver.get(URL)
    #print(driver.title)
    assert 'Google' in driver.title

    time.sleep(SLEEP_TIME)
    print('Accept cookies')
    driver.switch_to.frame(driver.find_element_by_xpath('/html/body/div/div[3]/div[3]/div/div[2]/span/div/div/iframe'))
    accept_cookies_button = driver.find_element_by_id('introAgreeButton')
    accept_cookies_button.click()
    driver.switch_to.default_content()

    time.sleep(SLEEP_TIME)
    search_box = driver.find_element_by_name('q')
    search_box.send_keys('{} USD to EURO'.format(DOLLARS))
    search_box.submit()

    try:
        time.sleep(SLEEP_TIME)
        result = driver.find_element_by_xpath('/html/body/div[7]/div[2]/div[10]/div[1]/div[2]/div/div[2]/div[2]/div/div/div[1]/div/div/div/div/div/div[1]/div[3]/table/tbody/tr[3]/td[1]/input')
        euro = result.get_attribute('value')
        print('Now {} USD are equivalent to {} EURO'.format(DOLLARS, euro))
    except:
        print('Error during currency conversion')
        
    time.sleep(SLEEP_TIME)
    driver.close()