# Library Load
library(RSelenium)

# Set Filepath for download location
downloadPath <- "~/Downloads"

# Build Firefox Profile.
fprof <- makeFirefoxProfile(list(
    browser.download.folderList = 2L,
    browser.download.manager.showWhenStarting = FALSE,
    browser.download.dir = downloadPath,
    browser.helperApps.neverAsk.openFile = "application/excel",
    browser.helperApps.neverAsk.saveToDisk = "application/excel",
    browser.helperApps.alwaysAsk.force = FALSE,
    browser.download.manager.showAlertOnComplete = FALSE,
    browser.download.manager.closeWhenDone = TRUE )
)

# Set Website URL
url <- "http://usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en"

# Create Remote Driver Object
remDr <- remoteDriver(remoteServerAddr = 'localhost',
                      port = 4440,
                      browser = "firefox",
                      extraCapabilities = fprof)

# Open Browser & Navigate to Webpage.
remDr$open(silent = TRUE)
remDr$navigate(url)

# Interact With Webpage ----

# Make Sure Indivual Times are Selected
time_type <- remDr$findElement(using = "id", value = "ctl82_rbIndividual")
time_type$clickElement()

# Turn Off Long Course and Short Course Meter times
lcm <- remDr$findElement(using = "id", value = "ctl82_cblCourses_0")
lcm$clickElement()

scm <- remDr$findElement(using = "id", value = "ctl82_cblCourses_1")
scm$clickElement()

# Trun off altitude adjustment
altitude <- remDr$findElement(using = "id",
                              value = "ctl82_cbUseAltitudeAdjTime")
altitude$clickElement()

# Submit report search
search <- remDr$findElement(using = "id", value = "ctl82_btnCreateReport")
search$clickElement()

Sys.sleep(5)

# Change The Output To CSV & Save!
output_select <- remDr$findElement(using = "id",
                                   value = "ctl82_ucReportViewer_ddViewerType")

output_select$sendKeysToElement(list("E", "E", "E"))

change_output <- remDr$findElement(using = "id",
                              value = "ctl82_ucReportViewer_lbChangeOutputType")

Sys.sleep(5) # Need to pause to get the export click to work
change_output$clickElement()

Sys.sleep(10) # Give Time for Down Load
remDr$close()
remDr$serverClose()