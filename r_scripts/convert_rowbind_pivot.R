Original Source: https://stackoverflow.com/questions/30826200/dynamically-converting-a-list-of-excel-files-to-csv-files-in-r

###Please remember to backup your files before using this code!

## convert xlsx into csv
#setup the working directory to where your excel files are stored
setwd(C:/Users/Desktop/Folder)

#check if user has installed the "rio" package
if (!require(rio)) install.packages('rio')

#load the rio package
library(rio)

#create a list of all excel files in folder
xls<-dir(pattern = "xlsx") 

#apply "convert" function from "rio" onto list "xls", create new csv files by converting excel files
created<-mapply(convert,xls,gsub("xlsx","csv",xls)) 

#delete remaining excels files in the folder
unlink(xls)


## rowbind all csv files together
#list all files in folder
file_list <- list.files(path="C:/Users/Desktop/Folder", pattern="*.csv", full.names=T, recursive=FALSE)

#create a blank dataframe 
results_final = data.frame()

#create a "for" loop where all CSV files in folder will be processed and row bound
for (i in file_list) {
  
  # read the file into results
  results <- read.csv(i,
                      header = TRUE,
                      sep = ",")
  
  results_final<-rbind(results_final,results)
}

#create a CSV file with the row bound results
write.csv(results_final,"results_final.csv")


## create a pivot table
#load all necessary libraries
library(readr)
library(pivottabler)
library(openxlsx)

#load data into a table
sales_pivot <- read_csv("C:/Users/alanl/Desktop/sales_pivot.csv", 
                        col_types = cols(Year = col_date(format = "%Y")))
View(sales_pivot)

#create revenue column for the table
sales_pivot$revenue = sales_pivot$Price * sales_pivot$Quantity

#build the framework for the pivot table
pt <- PivotTable$new()
pt$addData(sales_pivot)

#add columns
pt$addColumnDataGroups("Type")

#add rows
pt$addRowDataGroups("Year")

#add calculations
pt$defineCalculation(calculationName="total_revenue", caption="Total Revenue", 
                     summariseExpression="sum(revenue, na.rm=TRUE)")
pt$defineCalculation(calculationName="average_price", caption="Average Price", 
                     summariseExpression="mean(Price, na.rm=TRUE)")
pt$defineCalculation(calculationName="quantity_sold", caption="Quanaity Sold", 
                     summariseExpression="sum(Quantity, na.rm=TRUE)")

#render final results
pt$renderPivot()

#save pivot table results to your working directory as an excel file
library(openxlsx)
wb <- createWorkbook(creator = Sys.getenv("USERNAME"))
addWorksheet(wb, "Data")
pt$writeToExcelWorksheet(wb=wb, wsName="Data", 
                         topRowNumber=1, leftMostColumnNumber=1, 
                         applyStyles=TRUE, mapStylesFromCSS=TRUE)
saveWorkbook(wb, file="sales_report.xlsx")