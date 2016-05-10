## Set the current working directory to your working directory
setwd("C:/Users/yyan-koo/Data Science Specification/Courses/Course 5 Reproducible Research/Week 2/Assignment/Data")


## Load the data 
amd <- read.csv("activity.csv", header=T, sep=",")

## Check the dataframe
head(amd)

##------------------------------------------------------------
## What is mean total number of steps taken per day?
## 1. Make a histogram of the total number of steps taken each day. 
##    Calculate the total number of steps taken per day and remove the  missing value
total_steps <- aggregate(steps ~ date, amd, sum, na.rm=TRUE)

barplot(total_steps$steps, names.arg=total_steps$date, ylim=c(0, 25000), 
        xlab="Date", ylab="Total Number of Steps", 
        main = "Total Number of Steps Taken Each Day",col="blue")

## 2. Calculate and report the mean and median of the total number of steps taken per day
mean(total_steps$steps, na.rm=TRUE)
median(total_steps$steps, na.rm=TRUE)

##--------------------------------------------------------------
## What is the average daily activity pattern?
## 1. Make a time series plot
avg_steps <- aggregate(steps ~ interval, amd, mean, na.rm=TRUE)

plot(y=avg_steps$steps, x=avg_steps$interval, xlab="5-Minute Interval", 
     ylab="Average Number of Steps Taken", 
     main = "Average Number of Steps Taken Averaged Across All Days", 
     type="l")

## 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
avg_steps[avg_steps$steps==max(avg_steps$steps),]

##--------------------------------------------------------------
## Imputing missing values
## 1. Calculate and report the total number of missing values in the dataset 
##    sum of missing data
sum(is.na(amd$steps))

## 2. Devise a strategy for filling in all of the missing values in the dataset.
##    Steps to Impute missing values:
##    - use mean of the day to fill in all of the missing values in the dataset
##    - use the original dataset to create a new one with the missing data filled in
##    - install Hmisc package using Tools -> intall packages
##    - use impute() from package Hmisc 

## 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
require(Hmisc)
amdImputed <- amd   ## create a new dataset
amdImputed$steps <- impute(amd$steps, fun=mean)    ## impute missing values
sum(is.na(amdImputed$steps)) ## check any missing values in the new dataset

## 4. Make a histogram of the total number of steps taken each day.
total_stepsImputed <- aggregate(steps ~ date, amdImputed, sum, na.rm=TRUE)
barplot(total_stepsImputed$steps, names.arg=total_stepsImputed$date, ylim=c(0, 25000), 
        xlab="Date", ylab="Total Number of Steps", 
        main = "Total Number of Steps Taken Each Day",col="red")

##    Mean of the total number of steps taken per day
mean(total_stepsImputed$steps, na.rm=TRUE)
##    Median of the total number of steps taken per day
median(total_stepsImputed$steps, na.rm=TRUE)

##--------------------------------------------------------------
## Are there differences in activity patterns between weekdays and weekends?
## 1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend"
amdImputed$date <- as.Date(amdImputed$date)
weekdays1 <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
amdImputed$wDay <- c('weekend', 'weekday')[(weekdays(amdImputed$date) %in% weekdays1)+1L]

## 2. Make a panel plot containing a time series plot 
new_amdImputed <- aggregate(steps ~ interval + wDay, amdImputed, mean, na.rm=TRUE)

library(lattice)
xyplot(
  new_amdImputed$steps ~ new_amdImputed$interval | new_amdImputed$wDay,
  type = "l",
  layout = c(1,2),
  main = "Average Number of Steps Taken Across All Weekend Days",
  xlab = "5-Minute Interval",
  ylab = "Average Number of Steps Taken"
)

