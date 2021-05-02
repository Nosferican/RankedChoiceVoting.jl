using WebDriver
using Base64: base64decode

wd = RemoteWebDriver(Capabilities("chrome"))
session = Session(wd)
navigate!(session, "https://1link.travelsafe.pr.gov/")
element = Element(session, "xpath", """//*[@id='isResidentPr']/label[2]""")
click!(element)
element = Element(session, "xpath", """//*[@id="root"]/div/section/div/div[2]/form/div[4]/div/div/div[2]/div/div/div/div""")
click!(element)
municipios = Element(session, "xpath", """//*[@id="root"]/div/section/div/div[2]/form/div[5]/div[3]/div/div[2]/div/div/div/span""")
click!(municipios)



element = Element(session, "xpath", """/html/body/div[3]/div/div/div/div[2]/div/div/div[13]/div""")
click!(element)


element = Element(session, "xpath", """//*[@id="root"]/div/section/div/div[2]/form/div[5]/div[4]/div/div[2]/div/div/div/div/span[1]""")



ss = write(joinpath("img.png"), base64decode(screenshot(session)))
ss = write(joinpath("img.png"), base64decode(screenshot(element)))
