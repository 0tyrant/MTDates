//
//  NSDate+MTDates.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Week numbering systems.
 */
typedef NS_ENUM(NSInteger, MTDateWeekNumberingSystem) {
    /**
     *  First week contains January 1st.
     */
    MTDateWeekNumberingSystemUS = 1,
    /**
     *  First week contains january 4th.
     */
    MTDateWeekNumberingSystemISO = 4,
    /**
     *  First week starts on January 1st, next on Jan 8th, etc.
     */
    MTDateWeekNumberingSystemSimple = 8
};

/**
 *  Hour format
 */
typedef NS_ENUM(NSInteger, MTDateHourFormat) {
    /**
     *  e.g. 23:00
     */
    MTDateHourFormat24Hour,
    /**
     *  e.g. 11:00pm
     */
    MTDateHourFormat12Hour
};


/**
 *  Common number of seconds for larger time components. Some of these values are approximations
 *  and/or are not always true, like because of leap year or Daylight Savings Time for example. 
 *  The purpose of them is to provide a rough estimate for breaking down large time spans into 
 *  more understandable components, like for a UI.
 */

// This is exact.
static NSInteger const MTDateConstantSecondsInMinute   = 60;

// This is exact.
static NSInteger const MTDateConstantSecondsInHour     = 60 * 60;

// This is not always true. Leap year/DST.
static NSInteger const MTDateConstantSecondsInDay      = 60 * 60 * 24;

// This is not always true. Leap year/DST.
static NSInteger const MTDateConstantSecondsInWeek     = 60 * 60 * 24 * 7;

// This is an approximation and rarely true.
static NSInteger const MTDateConstantSecondsInMonth    = 60 * 60 * 24 * 7 * 30;

// This is true 3 out of 4 years. Leap years have 366 days.
static NSInteger const MTDateConstantSecondsInYear     = 60 * 60 * 24 * 7 * 365;

// This is exact.
static NSInteger const MTDateConstantDaysInWeek        = 7;

// This is not always true. Daylight savings time can increate/decrease a days hours by 1.
static NSInteger const MTDateConstantHoursInDay        = 24;




@interface NSDate (MTDates)


+ (NSDateFormatter *)sharedFormatter;


# pragma mark - GLOBAL CONFIG

+ (void)setCalendarIdentifier:(NSString *)identifier;
+ (void)setLocale:(NSLocale *)locale;
+ (void)setTimeZone:(NSTimeZone *)timeZone;
+ (void)setFirstDayOfWeek:(NSInteger)firstDay; // Sunday: 1, Saturday: 7
+ (void)setWeekNumberingSystem:(MTDateWeekNumberingSystem)system;


#pragma mark - CONSTRUCTORS

+ (NSDate *)dateFromISOString:(NSString *)ISOString;
+ (NSDate *)dateFromString:(NSString *)string usingFormat:(NSString *)format;
+ (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday;
+ (NSDate *)dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
- (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
+ (NSDate *)dateFromComponents:(NSDateComponents *)components;

+ (NSDate*)startOfToday;
+ (NSDate*)startOfYesterday;
+ (NSDate*)startOfTomorrow;
+ (NSDate*)endOfToday;
+ (NSDate*)endOfYesterday;
+ (NSDate*)endOfTomorrow;


#pragma mark - SYMBOLS

+ (NSArray *)shortWeekdaySymbols;
+ (NSArray *)weekdaySymbols;
+ (NSArray *)veryShortWeekdaySymbols;
+ (NSArray *)shortMonthlySymbols;
+ (NSArray *)monthlySymbols;
+ (NSArray *)veryShortMonthlySymbols;


#pragma mark - COMPONENTS

- (NSInteger)year;
- (NSInteger)weekOfYear;
- (NSInteger)dayOfYear;
- (NSInteger)weekdayOfWeek;
- (NSInteger)weekOfMonth;
- (NSInteger)monthOfYear;
- (NSInteger)dayOfMonth;
- (NSInteger)hourOfDay;
- (NSInteger)minuteOfHour;
- (NSInteger)secondOfMinute;
- (NSTimeInterval)secondsIntoDay;
- (NSDateComponents *)components;


#pragma mark - RELATIVES


#pragma mark years

- (NSDate *)startOfPreviousYear;
- (NSDate *)startOfCurrentYear;
- (NSDate *)startOfNextYear;

- (NSDate *)middleOfPreviousYear;
- (NSDate *)middleOfCurrentYear;
- (NSDate *)middleOfNextYear;

- (NSDate *)endOfPreviousYear;
- (NSDate *)endOfCurrentYear;
- (NSDate *)endOfNextYear;

- (NSDate *)oneYearPrevious;
- (NSDate *)oneYearNext;

- (NSDate *)dateYearsBefore:(NSInteger)years;
- (NSDate *)dateYearsAfter:(NSInteger)years;

- (NSInteger)yearsSinceDate:(NSDate *)date;
- (NSInteger)yearsUntilDate:(NSDate *)date;


#pragma mark months

- (NSDate *)startOfPreviousMonth;
- (NSDate *)startOfCurrentMonth;
- (NSDate *)startOfNextMonth;

- (NSDate *)middleOfPreviousMonth;
- (NSDate *)middleOfCurrentMonth;
- (NSDate *)middleOfNextMonth;

- (NSDate *)endOfPreviousMonth;
- (NSDate *)endOfCurrentMonth;
- (NSDate *)endOfNextMonth;

- (NSDate *)oneMonthPrevious;
- (NSDate *)oneMonthNext;

- (NSDate *)dateMonthsBefore:(NSInteger)months;
- (NSDate *)dateMonthsAfter:(NSInteger)months;

- (NSInteger)monthsSinceDate:(NSDate *)date;
- (NSInteger)monthsUntilDate:(NSDate *)date;


#pragma mark weeks

- (NSDate *)startOfPreviousWeek;
- (NSDate *)startOfCurrentWeek;
- (NSDate *)startOfNextWeek;

- (NSDate *)middleOfPreviousWeek;
- (NSDate *)middleOfCurrentWeek;
- (NSDate *)middleOfNextWeek;

- (NSDate *)endOfPreviousWeek;
- (NSDate *)endOfCurrentWeek;
- (NSDate *)endOfNextWeek;

- (NSDate *)oneWeekPrevious;
- (NSDate *)oneWeekNext;

- (NSDate *)dateWeeksBefore:(NSInteger)weeks;
- (NSDate *)dateWeeksAfter:(NSInteger)weeks;

- (NSInteger)weeksSinceDate:(NSDate *)date;
- (NSInteger)weeksUntilDate:(NSDate *)date;


#pragma mark days

- (NSDate *)startOfPreviousDay;
- (NSDate *)startOfCurrentDay;
- (NSDate *)startOfNextDay;

- (NSDate *)middleOfPreviousDay;
- (NSDate *)middleOfCurrentDay;
- (NSDate *)middleOfNextDay;

- (NSDate *)endOfPreviousDay;
- (NSDate *)endOfCurrentDay;
- (NSDate *)endOfNextDay;

- (NSDate *)oneDayPrevious;
- (NSDate *)oneDayNext;

- (NSDate *)dateDaysBefore:(NSInteger)days;
- (NSDate *)dateDaysAfter:(NSInteger)days;

- (NSInteger)daysSinceDate:(NSDate *)date;
- (NSInteger)daysUntilDate:(NSDate *)date;


#pragma mark hours

- (NSDate *)startOfPreviousHour;
- (NSDate *)startOfCurrentHour;
- (NSDate *)startOfNextHour;

- (NSDate *)middleOfPreviousHour;
- (NSDate *)middleOfCurrentHour;
- (NSDate *)middleOfNextHour;

- (NSDate *)endOfPreviousHour;
- (NSDate *)endOfCurrentHour;
- (NSDate *)endOfNextHour;

- (NSDate *)oneHourPrevious;
- (NSDate *)oneHourNext;

- (NSDate *)dateHoursBefore:(NSInteger)hours;
- (NSDate *)dateHoursAfter:(NSInteger)hours;

- (NSInteger)hoursSinceDate:(NSDate *)date;
- (NSInteger)hoursUntilDate:(NSDate *)date;

#pragma mark minutes

- (NSDate *)startOfPreviousMinute;
- (NSDate *)startOfCurrentMinute;
- (NSDate *)startOfNextMinute;

- (NSDate *)middleOfPreviousMinute;
- (NSDate *)middleOfCurrentMinute;
- (NSDate *)middleOfNextMinute;

- (NSDate *)endOfPreviousMinute;
- (NSDate *)endOfCurrentMinute;
- (NSDate *)endOfNextMinute;

- (NSDate *)oneMinutePrevious;
- (NSDate *)oneMinuteNext;

- (NSDate *)dateMinutesBefore:(NSInteger)minutes;
- (NSDate *)dateMinutesAfter:(NSInteger)minutes;

- (NSInteger)minutesSinceDate:(NSDate *)date;
- (NSInteger)minutesUntilDate:(NSDate *)date;

#pragma mark seconds

- (NSDate *)startOfPreviousSecond;
- (NSDate *)startOfNextSecond;

- (NSDate *)oneSecondPrevious;
- (NSDate *)oneSecondNext;

- (NSDate *)dateSecondsBefore:(NSInteger)seconds;
- (NSDate *)dateSecondsAfter:(NSInteger)seconds;

- (NSInteger)secondsSinceDate:(NSDate *)date;
- (NSInteger)secondsUntilDate:(NSDate *)date;


#pragma mark - COMPARES

- (BOOL)isAfter:(NSDate *)date;
- (BOOL)isBefore:(NSDate *)date;
- (BOOL)isOnOrAfter:(NSDate *)date;
- (BOOL)isOnOrBefore:(NSDate *)date;
- (BOOL)isWithinSameYear:(NSDate *)date;
- (BOOL)isWithinSameMonth:(NSDate *)date;
- (BOOL)isWithinSameWeek:(NSDate *)date;
- (BOOL)isWithinSameDay:(NSDate *)date;
- (BOOL)isWithinSameHour:(NSDate *)date;
- (BOOL)isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;


#pragma mark - STRINGS

+ (void)setFormatterDateStyle:(NSDateFormatterStyle)style;
+ (void)setFormatterTimeStyle:(NSDateFormatterStyle)style;

- (NSString *)stringValue;
- (NSString *)stringValueWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format;
- (NSString *)stringFromDateWithShortMonth;
- (NSString *)stringFromDateWithFullMonth;
- (NSString *)stringFromDateWithAMPMSymbol;
- (NSString *)stringFromDateWithShortWeekdayTitle;
- (NSString *)stringFromDateWithFullWeekdayTitle;
- (NSString *)stringFromDateWithFormat:(NSString *)format localized:(BOOL)localized;    // http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
- (NSString *)stringFromDateWithISODateTime;
- (NSString *)stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval;
- (NSString *)stringFromDateWithGreatestComponentsUntilDate:(NSDate *)date;


#pragma mark - MISC

+ (NSArray *)datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate;
- (NSArray *)hoursInCurrentDayAsDatesCollection;
- (BOOL)isInAM;
- (BOOL)isStartOfAnHour;
- (NSInteger)weekdayStartOfCurrentMonth;
- (NSInteger)daysInCurrentMonth;
- (NSInteger)daysInPreviousMonth;
- (NSInteger)daysInNextMonth;
- (NSDate *)inTimeZone:(NSTimeZone *)timezone;
+ (NSInteger)minValueForUnit:(NSCalendarUnit)unit;
+ (NSInteger)maxValueForUnit:(NSCalendarUnit)unit;

@end


#pragma mark - Common Date Formats
// for use with stringFromDateWithFormat:

extern NSString *const MTDatesFormatDefault;          // Sat Jun 09 2007 17:46:21
extern NSString *const MTDatesFormatShortDate;        // 6/9/07
extern NSString *const MTDatesFormatMediumDate;       // Jun 9, 2007
extern NSString *const MTDatesFormatLongDate;         // June 9, 2007
extern NSString *const MTDatesFormatFullDate;         // Saturday, June 9, 2007
extern NSString *const MTDatesFormatShortTime;        // 5:46 PM
extern NSString *const MTDatesFormatMediumTime;       // 5:46:21 PM
extern NSString *const MTDatesFormatLongTime;         // 5:46:21 PM EST
extern NSString *const MTDatesFormatISODate;          // 2007-06-09
extern NSString *const MTDatesFormatISOTime;          // 17:46:21
extern NSString *const MTDatesFormatISODateTime;      // 2007-06-09T17:46:21
//extern NSString *const MTDatesFormatISOUTCDateTime;   // 2007-06-09T22:46:21Z
