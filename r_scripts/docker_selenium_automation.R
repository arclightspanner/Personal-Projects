###############################Install and set up docker and selenium server#########################

library(RSelenium)
shell('docker run -d -p 4445:4444 selenium/standalone-chrome')
remDr <- remoteDriver(remoteServerAddr = "192.168.99.100", port = 4445L,browserName = "chrome")
Sys.sleep(20)
remDr$open()

#####################################AUTOMATED ORDER CANCELLER######################################

#navigate to login page and #test
remDr$navigate("<<backend portal of site>>")
remDr$findElement(using = "css selector", value = ".secondary")$clickElement()

#send username
username <- remDr$findElement(using = "id", value = "ap_email")
username$sendKeysToElement(list("<<username>>"))

#send password and Enter
passwd <- remDr$findElement(using = "id", value = "ap_password")
passwd$sendKeysToElement(list("<<password>>", "\uE007"))
remDr$screenshot(display = TRUE)

-----------------------------------------------------------------------------------------
#send password and Entertwo step verification code
code <- "<<two-step verification code>>"
twstp<- remDr$findElement(using = "id", value = "auth-mfa-otpcode")
twstp$sendKeysToElement(list(code, "\uE007"))
remDr$screenshot(display = TRUE)
-----------------------------------------------------------------------------------------


##Action. Navigate to order refund page
remDr$navigate("https://<<site backend portal link>>/refund?orderID=<<specific order number>>")
remDr$findElement(using = 'id', value ='a-autoid-0-announce')$clickElement()
Sys.sleep(1)
remDr$sendKeysToActiveElement(list(key = 'tab'))
Sys.sleep(1)
remDr$sendKeysToActiveElement(list(key = 'enter'))
Sys.sleep(1)
remDr$findElement(using = "css selector", value = ".a-checkbox-label")$clickElement()
Sys.sleep(1)
remDr$findElement(using = "css selector", value = ".a-button-input")$clickElement()
remDr$screenshot(display = TRUE)
elem<-remDr$findElement(using = "css selector", value = ".a-alert-heading") 
elemtxt <- elem$getElementAttribute("outerHTML")[[1]]
gsub('^.*<h4 class=\"a-alert-heading\">\\s*|\\s*</h4>.*$', '',elemtxt)

##Action. Loop through a list of orders copied to clipboard
##Action. Depending on order status, decide whether to cancel/refund order
library(XML)
lnk<-read.delim("clipboard",header=FALSE)
lnk<-unique(lnk)
results <- matrix(NA, nrow=NROW(lnk), ncol=3)
for(i in 1:NROW(lnk)){
  tryCatch({
    remDr$navigate(paste0(lnk$V1[[i]]))
    remDr$findElement(using = "class", value ='refundFullAmount')$clickElement()
    Sys.sleep(1)
    elem<-remDr$findElement(using = "id", value = "total-amount-to-refund")
    Sys.sleep(1)
    elemtxt <- elem$getElementAttribute("outerHTML")[[1]]
    Sys.sleep(1)
    status1<- as.numeric(gsub('^.*a-size-base a-color-price floatRight a-text-bold\">\\s*|\\s*</span>.*$', '',elemtxt))
      if (status1 > 0){
        remDr$findElement(using = "class", value = "a-button-input")$clickElement()
        remDr$screenshot(display = TRUE) 
        elem<-remDr$findElement(using = "css selector", value = ".a-alert-heading") 
        elemtxt <- elem$getElementAttribute("outerHTML")[[1]]
        status2<- gsub('^.*<h4 class=\"a-alert-heading\">\\s*|\\s*</h4>.*$', '',elemtxt)
        elem2<-remDr$findElement(using = "css selector", value = ".a-alert-content") 
        elemtxt2 <- elem2$getElementAttribute("outerHTML")[[1]]
        status3<- gsub('^.*class="a-alert-content">\\s*|\\s*</div>.*$', '',elemtxt2)
        results[i,]<-c(paste0(lnk$V1[[i]]),status2,status3)
        Sys.sleep(3)}
      else {
        results[i,]<-c(paste0(lnk$V1[[i]]),"Order Refunded Already","")
      }
    },
 error=function(error_message){
   message(error_message)
   return(NULL)
 }
 )}

# copy results to clipboard
library(clipr)
write_clip(results)


#####################################PULL ORDERS######################################
##Action.1 Pull and Match Order Number to Order ID
library(XML)
library(readr)
Document_Provided_for_Pull <- read_csv("<<csv file location>>")

library(sqldf)
tp_result<-sqldf("SELECT * FROM tp LEFT JOIN Document_Provided_for_Pull ON tp.V1 = Document_Provided_for_Pull.`Doc Number`")
tp_result$link<-paste0("<<second portal link>>&DocumentID=",tp_result$`Document ID`)
tp_result <- tp_result[,c(3:5)]
results <- matrix(NA, nrow=NROW(tp_result), ncol=3)

-----------------------------------------------------------------------------
#navigate to login page
remDr$navigate("<<second portal login page>>")

#send username
username <- remDr$findElement(using = "id", value = "username")
username$sendKeysToElement(list("<<second portal username>>"))

#send password and Enter
passwd <- remDr$findElement(using = "id", value = "password")
passwd$sendKeysToElement(list("<<second portal password>>", "\uE007"))
remDr$screenshot(display = TRUE)
------------------------------------------------------------------------------
##Action. Loop Status, check if non-refunded order has been shipped or not
tp_result <- read.delim("clipboard",header = FALSE)
colnames(tp_result)[1] <- "link"
tp_result <- unique(tp_result)
results2 <- matrix(NA, nrow=NROW(tp_result), ncol=2)
for(i in 1:NROW(tp_result)){
  tryCatch({
    remDr$navigate(paste0(tp_result$link[[i]]))
    elem <- remDr$findElement(using = 'id', value ='dlblStatus_lblData')
    elemtxt <- elem$getElementAttribute("outerHTML")[[1]]
    currentstat<- gsub('^.*dlblStatus_lblData\" class=\"tsDataLabel\">\\s*|\\s*</span>.*$', '',elemtxt)
    if (currentstat == "OPEN" | currentstat == "SHIPPED INCOMPLETE"){
      remDr$findElement(using = 'id', value ='btnCancel')$clickElement()
      remDr$acceptAlert()
      elem2<-remDr$findElement(using = "id", value = "successLabel") 
      elemtxt2 <- elem2$getElementAttribute("outerHTML")[[1]]
      status2<- gsub('^.*successLabel\" class=\"Success\">\\s*|\\s*</span>.*$', '',elemtxt2)
      results2[i,]<-c(paste0(tp_result$link[[i]]),status2)
    }
    else if (currentstat == "CANCELED"){
      results2[i,]<-c(paste0(tp_result$link[[i]]),"Already Cancelled")
    }
    else if (currentstat == "PICKED COMPLETE" | currentstat == "PICKED INCOMPLETE"){
      results2[i,]<-c(paste0(tp_result$link[[i]]),"Picked Unable to Cancel")
    }
    else {
      results2[i,]<-c(paste0(tp_result$link[[i]]),"Other Error")
    }
    Sys.sleep(3)},
    error=function(error_message){
      message(error_message)
      return(NA)
    }
  )}
library(clipr)
write_clip(results2)

############################CLOSE ALL################################
remDr$closeall()

#stop all containers:
docker kill $(docker ps -q)

# remove all containers
docker rm $(docker ps -a -q)

#remove all docker images
docker rmi $(docker images -q)


