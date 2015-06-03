//
//  NSDate+MTDates.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "NSDate+MTDates.h"


@implementation NSDate (MTDates)


static NSCalendar                   *__calendar             = nil;
static NSDateComponents             *__components           = nil;
static NSDateFormatter              *__formatter            = nil;

static NSString                     *__calendarType         = nil;
static NSLocale                     *__locale               = nil;
static NSTimeZone                   *__timeZone             = nil;
static NSInteger                    __firstWeekday          = 0;
static MTDateWeekNumberingSystem    __weekNumberingSystem   = 0;

static NSDateFormatterStyle         __dateStyle             = NSDateFormatterShortStyle;
static NSDateFormatterStyle         __timeStyle             = NSDateFormatterShortStyle;


+ (NSDateFormatter *)sharedFormatter
{
	[[NSDate sharedRecursiveLock] lock];
    [self prepareDefaults];

    if (!__formatter) {
        __formatter           = [[NSDateFormatter alloc] init];
        __formatter.calendar  = [self calendar];
        __formatter.locale    = __locale;
        __formatter.timeZone  = __timeZone;
        [__formatter setDateStyle:__dateStyle];
        [__formatter setTimeStyle:__timeStyle];
    }

    NSDateFormatter *formatter = __formatter;
    [[NSDate sharedRecursiveLock] unlock];
    return formatter;
}


#pragma mark - GLOBAL CONFIG

+ (void)setCalendarIdentifier:(NSString *)identifier
{
	[[NSDate sharedRecursiveLock] lock];
    __calendarType = identifier;
    [self reset];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)setLocale:(NSLocale *)locale
{
	[[NSDate sharedRecursiveLock] lock];
    __locale = locale;
    [self reset];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)setTimeZone:(NSTimeZone *)timeZone
{
	[[NSDate sharedRecursiveLock] lock];
    __timeZone = timeZone;
    [self reset];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)setFirstDayOfWeek:(NSInteger)firstDay
{
	[[NSDate sharedRecursiveLock] lock];
    __firstWeekday = firstDay;
    [self reset];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)setWeekNumberingSystem:(MTDateWeekNumberingSystem)system
{
	[[NSDate sharedRecursiveLock] lock];
    __weekNumberingSystem = system;
    [self reset];
	[[NSDate sharedRecursiveLock] unlock];
}


#pragma mark - CONSTRUCTORS

+ (NSDate *)dateFromISOString:(NSString *)ISOString
{
	[[NSDate sharedRecursiveLock] lock];
    if (ISOString == nil || (NSNull *)ISOString == [NSNull null]) {
        [[NSDate sharedRecursiveLock] unlock];
        return nil;
    }

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    NSArray *formatsToTry = @[ @"yyyy-MM-dd'T'HH:mm.ss.SSS'Z'", @"yyyy-MM-dd HH:mm:ss ZZZ", @"yyyy-MM-dd HH:mm:ss Z", @"yyyy-MM-dd HH:mm:ss", @"yyyy-MM-dd'T'HH:mm:ss'Z'", @"yyyy-MM-dd" ];

    NSDate *result = nil;
    for (NSString *format in formatsToTry) {
        [formatter setDateFormat:format];
        result = [formatter dateFromString:ISOString];
        if (result) break;
    }
	[[NSDate sharedRecursiveLock] unlock];
    return result;
}

+ (NSDate *)dateFromString:(NSString *)string usingFormat:(NSString *)format
{
	[[NSDate sharedRecursiveLock] lock];
    if (string == nil || (NSNull *)string == [NSNull null]) {
        [[NSDate sharedRecursiveLock] unlock];
        return nil;
    }
    NSDateFormatter* formatter = [self sharedFormatter];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateFromYear:year
                                   month:month
                                     day:day
                                    hour:[NSDate minValueForUnit:NSCalendarUnitHour]
                                  minute:[NSDate minValueForUnit:NSCalendarUnitMinute]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateFromYear:year
                                   month:month
                                     day:day
                                    hour:hour
                                  minute:minute
                                  second:[NSDate minValueForUnit:NSCalendarUnitSecond]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [NSDate components];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSDate *date = [[NSDate calendar] dateFromComponents:comps];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateFromYear:year
                                    week:week
                                 weekday:weekday
                                    hour:[NSDate minValueForUnit:NSCalendarUnitHour]
                                  minute:[NSDate minValueForUnit:NSCalendarUnitMinute]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateFromYear:year
                                    week:week
                                 weekday:weekday
                                    hour:hour
                                  minute:minute
                                  second:[NSDate minValueForUnit:NSCalendarUnitSecond]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [NSDate components];
    [comps setYear:year];
    [comps setWeekOfYear:week];
    [comps setWeekday:weekday];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSDate *date = [[NSDate calendar] dateFromComponents:comps];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [NSDate components];
    if (years)      [comps setYear:years];
    if (months)     [comps setMonth:months];
    if (weeks)      [comps setWeekOfYear:weeks];
    if (days)       [comps setDay:days];
    if (hours)      [comps setHour:hours];
    if (minutes)    [comps setMinute:minutes];
    if (seconds)    [comps setSecond:seconds];
    NSDate *date = [[NSDate calendar] dateByAddingComponents:comps toDate:self options:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)dateFromComponents:(NSDateComponents *)components
{
    if (!components) return nil;
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate calendar] dateFromComponents:components];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)startOfToday
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] startOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)startOfYesterday
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] startOfPreviousDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)startOfTomorrow
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] startOfNextDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)endOfToday
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] endOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)endOfYesterday
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] endOfPreviousDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)endOfTomorrow
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] endOfNextDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


#pragma mark - SYMBOLS

+ (NSArray *)shortWeekdaySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate sharedFormatter] shortWeekdaySymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)weekdaySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate sharedFormatter] weekdaySymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)veryShortWeekdaySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate sharedFormatter] veryShortWeekdaySymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)shortMonthlySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate sharedFormatter] shortMonthSymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)monthlySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate sharedFormatter] monthSymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)veryShortMonthlySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate sharedFormatter] veryShortMonthSymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}


#pragma mark - COMPONENTS

- (NSInteger)year
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitYear fromDate:self];
    NSInteger year = [components year];
	[[NSDate sharedRecursiveLock] unlock];
    return year;
}

- (NSInteger)weekOfYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitWeekOfYear | NSCalendarUnitYear fromDate:self];
    NSInteger weekOfYear = [comps weekOfYear];
	[[NSDate sharedRecursiveLock] unlock];
    return weekOfYear;
}

- (NSInteger)dayOfYear
{
    [[NSDate sharedRecursiveLock] lock];
    NSInteger dayOfYear = [[NSDate calendar] ordinalityOfUnit:NSCalendarUnitDay
                                                           inUnit:NSCalendarUnitYear
                                                          forDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return dayOfYear;
}

- (NSInteger)weekOfMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitWeekOfMonth fromDate:self];
    NSInteger weekOfMonth = [components weekOfMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return weekOfMonth;
}

- (NSInteger)weekdayOfWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger weekdayOfWeek = [[NSDate calendar] ordinalityOfUnit:NSCalendarUnitWeekday
                                                               inUnit:NSCalendarUnitWeekOfYear
                                                              forDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return weekdayOfWeek;
}

- (NSInteger)monthOfYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitMonth fromDate:self];
    NSInteger monthOfYear = [components month];
	[[NSDate sharedRecursiveLock] unlock];
    return monthOfYear;
}

- (NSInteger)dayOfMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitDay fromDate:self];
    NSInteger dayOfMonth = [components day];
	[[NSDate sharedRecursiveLock] unlock];
    return dayOfMonth;
}

- (NSInteger)hourOfDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitHour fromDate:self];
    NSInteger hourOfDay = [components hour];
	[[NSDate sharedRecursiveLock] unlock];
    return hourOfDay;
}

- (NSInteger)minuteOfHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitMinute fromDate:self];
    NSInteger minuteOfHour = [components minute];
	[[NSDate sharedRecursiveLock] unlock];
    return minuteOfHour;
}

- (NSInteger)secondOfMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitSecond fromDate:self];
    NSInteger secondOfMinute = [components second];
	[[NSDate sharedRecursiveLock] unlock];
    return secondOfMinute;
}

- (NSTimeInterval)secondsIntoDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger date = [self timeIntervalSinceDate:[self startOfCurrentDay]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDateComponents *)components
{
	[[NSDate sharedRecursiveLock] lock];
    NSCalendarUnit units = (NSCalendarUnitYear |
                            NSCalendarUnitMonth |
                            NSCalendarUnitWeekOfYear |
                            NSCalendarUnitWeekday |
                            NSCalendarUnitDay |
                            NSCalendarUnitHour |
                            NSCalendarUnitMinute |
                            NSCalendarUnitSecond);
    NSDateComponents *dateComponents = [[NSDate calendar] components:units fromDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return dateComponents;
}


#pragma mark - RELATIVES


#pragma mark years

- (NSDate *)startOfPreviousYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneYearPrevious] startOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfCurrentYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate dateFromYear:[self year]
                                     month:[NSDate minValueForUnit:NSCalendarUnitMonth]
                                       day:[NSDate minValueForUnit:NSCalendarUnitDay]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfNextYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneYearNext] startOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfPreviousYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfPreviousYear] middleOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfCurrentYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self startOfCurrentYear];
    NSTimeInterval timeInterval = [[self endOfCurrentYear] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfNextYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfNextYear] middleOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)endOfPreviousYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneYearPrevious] endOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfCurrentYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfCurrentYear] dateByAddingYears:1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfNextYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneYearNext] endOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)oneYearPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:-1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneYearNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)dateYearsBefore:(NSInteger)years
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:-years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateYearsAfter:(NSInteger)years
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)yearsSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitYear fromDate:date toDate:self options:0];
    NSInteger years = [comps year];
	[[NSDate sharedRecursiveLock] unlock];
    return years;
}


- (NSInteger)yearsUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitYear fromDate:self toDate:date options:0];
    NSInteger years = [comps year];
	[[NSDate sharedRecursiveLock] unlock];
    return years;
}


#pragma mark months

- (NSDate *)startOfPreviousMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneMonthPrevious] startOfCurrentMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfCurrentMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate dateFromYear:[self year]
                                     month:[self monthOfYear]
                                       day:[NSDate minValueForUnit:NSCalendarUnitDay]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfNextMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneMonthNext] startOfCurrentMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)middleOfPreviousMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfPreviousMonth] middleOfCurrentMonth];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfCurrentMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self startOfCurrentMonth];
    NSTimeInterval timeInterval = [[self endOfCurrentMonth] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfNextMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfNextMonth] middleOfCurrentMonth];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)endOfPreviousMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneMonthPrevious] endOfCurrentMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfCurrentMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfCurrentMonth] dateByAddingYears:0 months:1 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfNextMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneMonthNext] endOfCurrentMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)oneMonthPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:-1 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneMonthNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:1 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)dateMonthsBefore:(NSInteger)months
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:-months weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateMonthsAfter:(NSInteger)months
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:months weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)monthsSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitMonth fromDate:date toDate:self options:0];
    NSInteger months = [components month];
	[[NSDate sharedRecursiveLock] unlock];
    return months;
}


- (NSInteger)monthsUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitMonth fromDate:self toDate:date options:0];
    NSInteger months = [components month];
	[[NSDate sharedRecursiveLock] unlock];
    return months;
}


#pragma mark weeks

- (NSDate *)startOfPreviousWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneWeekPrevious] startOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfCurrentWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger weekday = [self weekdayOfWeek];
    NSDate *date = [self dateDaysAfter:-(weekday - 1)];
    NSDate *startOfCurrentWeek = [NSDate dateFromYear:[date year]
                                                   month:[date monthOfYear]
                                                     day:[date dayOfMonth]
                                                    hour:[NSDate minValueForUnit:NSCalendarUnitHour]
                                                  minute:[NSDate minValueForUnit:NSCalendarUnitMinute]
                                                  second:[NSDate minValueForUnit:NSCalendarUnitSecond]];
	[[NSDate sharedRecursiveLock] unlock];
    return startOfCurrentWeek;
}

- (NSDate *)startOfNextWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneWeekNext] startOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)middleOfPreviousWeek
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfPreviousWeek] middleOfCurrentWeek];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfCurrentWeek
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self startOfCurrentWeek];
    NSTimeInterval timeInterval = [[self endOfCurrentWeek] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfNextWeek
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfNextWeek] middleOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)endOfPreviousWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneWeekPrevious] endOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfCurrentWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfCurrentWeek] dateByAddingYears:0 months:0 weeks:1 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfNextWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneWeekNext] endOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)oneWeekPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:-1 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneWeekNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:1 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateWeeksBefore:(NSInteger)weeks
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:-weeks days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateWeeksAfter:(NSInteger)weeks
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:weeks days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)weeksSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitWeekOfYear fromDate:date toDate:self options:0];
    NSInteger weeks = [components weekOfYear];
	[[NSDate sharedRecursiveLock] unlock];
    return weeks;
}

- (NSInteger)weeksUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate calendar] components:NSCalendarUnitWeekOfYear fromDate:self toDate:date options:0];
    NSInteger weeks = [components weekOfYear];
	[[NSDate sharedRecursiveLock] unlock];
    return weeks;
}


#pragma mark days

- (NSDate *)startOfPreviousDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneDayPrevious] startOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfCurrentDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate dateFromYear:[self year]
                                     month:[self monthOfYear]
                                       day:[self dayOfMonth]
                                      hour:[NSDate minValueForUnit:NSCalendarUnitHour]
                                    minute:[NSDate minValueForUnit:NSCalendarUnitMinute]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfNextDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneDayNext] startOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)middleOfPreviousDay
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfPreviousDay] middleOfCurrentDay];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfCurrentDay
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self startOfCurrentDay];
    NSTimeInterval timeInterval = [[self endOfCurrentDay] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfNextDay
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfNextDay] middleOfCurrentDay];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)endOfPreviousDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneDayPrevious] endOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfCurrentDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfCurrentDay] dateByAddingYears:0 months:0 weeks:0 days:1 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfNextDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneDayNext] endOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)oneDayPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:-1 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneDayNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:1 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)dateDaysBefore:(NSInteger)days
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:-days hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateDaysAfter:(NSInteger)days
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:days hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)daysSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitDay fromDate:date toDate:self options:0];
    NSInteger days = [comps day];
	[[NSDate sharedRecursiveLock] unlock];
    return days;
}


- (NSInteger)daysUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitDay fromDate:self toDate:date options:0];
    NSInteger days = [comps day];
	[[NSDate sharedRecursiveLock] unlock];
    return days;
}


#pragma mark hours

- (NSDate *)startOfPreviousHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneHourPrevious] startOfCurrentHour];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfCurrentHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate dateFromYear:[self year]
                                     month:[self monthOfYear]
                                       day:[self dayOfMonth]
                                      hour:[self hourOfDay]
                                    minute:[NSDate minValueForUnit:NSCalendarUnitMinute]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfNextHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneHourNext] startOfCurrentHour];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)middleOfPreviousHour
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfPreviousHour] middleOfCurrentHour];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfCurrentHour
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self startOfCurrentHour];
    NSTimeInterval timeInterval = [[self endOfCurrentHour] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfNextHour
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfNextHour] middleOfCurrentHour];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)endOfPreviousHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneHourPrevious] endOfCurrentHour];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfCurrentHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfCurrentHour] dateByAddingYears:0 months:0 weeks:0 days:0 hours:1 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfNextHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneHourNext] endOfCurrentHour];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneHourPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:-1 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneHourNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:1 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)dateHoursBefore:(NSInteger)hours
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:-hours minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateHoursAfter:(NSInteger)hours
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:hours minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)hoursSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitHour fromDate:date toDate:self options:0];
    NSInteger hours = [comps hour];
	[[NSDate sharedRecursiveLock] unlock];
    return hours;
}


- (NSInteger)hoursUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitHour fromDate:self toDate:date options:0];
    NSInteger hours = [comps hour];
	[[NSDate sharedRecursiveLock] unlock];
    return hours;
}

#pragma mark minutes

- (NSDate *)startOfPreviousMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneMinutePrevious] startOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfCurrentMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate dateFromYear:[self year]
                                     month:[self monthOfYear]
                                       day:[self dayOfMonth]
                                      hour:[self hourOfDay]
                                    minute:[self minuteOfHour]
                                    second:[NSDate minValueForUnit:NSCalendarUnitSecond]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfNextMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneMinuteNext] startOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)middleOfPreviousMinute
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfPreviousMinute] middleOfCurrentMinute];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfCurrentMinute
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self startOfCurrentMinute];
    NSTimeInterval timeInterval = [[self endOfCurrentMinute] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)middleOfNextMinute
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfNextMinute] middleOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)endOfPreviousMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneMinutePrevious] endOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfCurrentMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self startOfCurrentMinute] dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:1 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)endOfNextMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self oneMinuteNext] endOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneMinutePrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:-1 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneMinuteNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:1 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)dateMinutesBefore:(NSInteger)minutes
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:-minutes seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateMinutesAfter:(NSInteger)minutes
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:minutes seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)minutesSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitMinute fromDate:date toDate:self options:0];
    NSInteger minutes = [comps minute];
	[[NSDate sharedRecursiveLock] unlock];
    return minutes;
}


- (NSInteger)minutesUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitMinute fromDate:self toDate:date options:0];
    NSInteger minutes = [comps minute];
	[[NSDate sharedRecursiveLock] unlock];
    return minutes;
}


#pragma mark seconds

- (NSDate *)startOfPreviousSecond
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingTimeInterval:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)startOfNextSecond
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingTimeInterval:1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneSecondPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)oneSecondNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)dateSecondsBefore:(NSInteger)seconds
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-seconds];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)dateSecondsAfter:(NSInteger)seconds
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:seconds];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)secondsSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitSecond fromDate:date toDate:self options:0];
    NSInteger seconds = [comps second];
	[[NSDate sharedRecursiveLock] unlock];
    return seconds;
}


- (NSInteger)secondsUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitSecond fromDate:self toDate:date options:0];
    NSInteger seconds = [comps second];
	[[NSDate sharedRecursiveLock] unlock];
    return seconds;
}

#pragma mark - COMPARES

- (BOOL)isAfter:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isAfter = [self compare:date] == NSOrderedDescending;
	[[NSDate sharedRecursiveLock] unlock];
    return isAfter;
}

- (BOOL)isBefore:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isBefore = [self compare:date] == NSOrderedAscending;
	[[NSDate sharedRecursiveLock] unlock];
    return isBefore;
}

- (BOOL)isOnOrAfter:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isOnOrAfter = [self compare:date] == NSOrderedDescending || [date compare:self] == NSOrderedSame;
	[[NSDate sharedRecursiveLock] unlock];
    return isOnOrAfter;
}

- (BOOL)isOnOrBefore:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isOnOrBefore = [self compare:date] == NSOrderedAscending || [self compare:date] == NSOrderedSame;
	[[NSDate sharedRecursiveLock] unlock];
    return isOnOrBefore;
}

- (BOOL)isWithinSameYear:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameYear = [self year] == [date year];
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameYear;
}

- (BOOL)isWithinSameMonth:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameMonth = [self year] == [date year] && [self monthOfYear] == [date monthOfYear];
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameMonth;
}

- (BOOL)isWithinSameWeek:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameWeek = ([self isOnOrAfter:[date startOfCurrentWeek]] &&
                             [self isOnOrBefore:[date endOfCurrentWeek]]);
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameWeek;
}

- (BOOL)isWithinSameDay:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameDay = ([self year] == [date year] &&
                            [self monthOfYear] == [date monthOfYear] &&
                            [self dayOfMonth] == [date dayOfMonth]);
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameDay;
}

- (BOOL)isWithinSameHour:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameHour = ([self year] == [date year] &&
                             [self monthOfYear] == [date monthOfYear] &&
                             [self dayOfMonth] == [date dayOfMonth] &&
                             [self hourOfDay] == [date hourOfDay]);
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameHour;
}

- (BOOL)isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isBetweenDates = NO;
    if ([self isOnOrAfter:date1] && [self isOnOrBefore:date2]) {
        isBetweenDates = YES;
    }
    else if ([self isOnOrAfter:date2] && [self isOnOrBefore:date1]) {
        isBetweenDates = YES;
    }
    [[NSDate sharedRecursiveLock] unlock];
    return isBetweenDates;
}


#pragma mark - STRINGS

+ (void)setFormatterDateStyle:(NSDateFormatterStyle)style
{
	[[NSDate sharedRecursiveLock] lock];
    __dateStyle = style;
    [[NSDate sharedFormatter] setDateStyle:style];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)setFormatterTimeStyle:(NSDateFormatterStyle)style
{
	[[NSDate sharedRecursiveLock] lock];
    __timeStyle = style;
    [[NSDate sharedFormatter] setTimeStyle:style];
	[[NSDate sharedRecursiveLock] unlock];
}

- (NSString *)stringValue
{
	[[NSDate sharedRecursiveLock] lock];
    NSString *stringValue = [[NSDate sharedFormatter] stringFromDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return stringValue;
}

- (NSString *)stringValueWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
	[[NSDate sharedRecursiveLock] lock];
    [[NSDate sharedFormatter] setDateStyle:dateStyle];
    [[NSDate sharedFormatter] setTimeStyle:timeStyle];
    NSString *str = [[NSDate sharedFormatter] stringFromDate:self];
    [[NSDate sharedFormatter] setDateStyle:__dateStyle];
    [[NSDate sharedFormatter] setTimeStyle:__timeStyle];
	[[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = nil;
    if (format == MTDateHourFormat24Hour) {
        str = [self stringFromDateWithFormat:@"HH:mm" localized:YES];
    }
    else {
        str = [self stringFromDateWithFormat:@"hh:mma" localized:YES];
    }
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithShortMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self stringFromDateWithFormat:@"MMM" localized:YES];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithFullMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self stringFromDateWithFormat:@"MMMM" localized:YES];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithAMPMSymbol
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self stringFromDateWithFormat:@"a" localized:NO];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithShortWeekdayTitle
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self stringFromDateWithFormat:@"E" localized:YES];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithFullWeekdayTitle
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self stringFromDateWithFormat:@"EEEE" localized:YES];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithFormat:(NSString *)format localized:(BOOL)localized
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateFormatter *formatter = [NSDate sharedFormatter];
    if (localized) format = [NSDateFormatter dateFormatFromTemplate:format options:0 locale:__locale];
    [formatter setDateFormat:format];
    NSString *str = [formatter stringFromDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithISODateTime
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* result = [formatter stringFromDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return result;
}

- (NSString *)stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval
{
	[[NSDate sharedRecursiveLock] lock];

    NSMutableString *s = [NSMutableString string];
    NSTimeInterval absInterval = interval > 0 ? interval : -interval;

    NSInteger months = floor(absInterval / (float)MTDateConstantSecondsInMonth);
    if (months > 0) {
        [s appendFormat:@"%ld months, ", (long)months];
        absInterval -= months * MTDateConstantSecondsInMonth;
    }

    NSInteger days = floor(absInterval / (float)MTDateConstantSecondsInDay);
    if (days > 0) {
        [s appendFormat:@"%ld days, ", (long)days];
        absInterval -= days * MTDateConstantSecondsInDay;
    }

    NSInteger hours = floor(absInterval / (float)MTDateConstantSecondsInHour);
    if (hours > 0) {
        [s appendFormat:@"%ld hours, ", (long)hours];
        absInterval -= hours * MTDateConstantSecondsInHour;
    }

    NSInteger minutes = floor(absInterval / (float)MTDateConstantSecondsInMinute);
    if (minutes > 0) {
        [s appendFormat:@"%ld minutes, ", (long)minutes];
        absInterval -= minutes * MTDateConstantSecondsInMinute;
    }

    NSInteger seconds = absInterval;
    if (seconds > 0) {
        [s appendFormat:@"%ld seconds, ", (long)seconds];
    }

    NSString *preString = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];
    NSString *str = (interval < 0 ?
                     [NSString stringWithFormat:@"%@ before", preString] :
                     [NSString stringWithFormat:@"%@ after", preString]);
	[[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)stringFromDateWithGreatestComponentsUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSMutableArray *s = [NSMutableArray array];
    NSTimeInterval interval = [date timeIntervalSinceDate:self];
    NSTimeInterval absInterval = interval > 0 ? interval : -interval;

    NSInteger months = floor(absInterval / (float)MTDateConstantSecondsInMonth);
    if (months > 0) {
        NSString *formatString = months == 1 ? @"%ld month" : @"%ld months";
        [s addObject:[NSString stringWithFormat:formatString, (long)months]];
        absInterval -= months * MTDateConstantSecondsInMonth;
    }

    NSInteger days = floor(absInterval / (float)MTDateConstantSecondsInDay);
    if (days > 0) {
        NSString *formatString = days == 1 ? @"%ld day" : @"%ld days";
        [s addObject:[NSString stringWithFormat:formatString, (long)days]];
        absInterval -= days * MTDateConstantSecondsInDay;
    }

    NSInteger hours = floor(absInterval / (float)MTDateConstantSecondsInHour);
    if (hours > 0) {
        NSString *formatString = hours == 1 ? @"%ld hour" : @"%ld hours";
        [s addObject:[NSString stringWithFormat:formatString, (long)hours]];
        absInterval -= hours * MTDateConstantSecondsInHour;
    }

    NSInteger minutes = floor(absInterval / (float)MTDateConstantSecondsInMinute);
    if (minutes > 0) {
        NSString *formatString = minutes == 1 ? @"%ld minute" : @"%ld minutes";
        [s addObject:[NSString stringWithFormat:formatString, (long)minutes]];
    }

    NSString *preString = [s componentsJoinedByString:@", "];
    NSString *string = interval < 0 ? [NSString stringWithFormat:@"%@ Ago", preString] : [NSString stringWithFormat:@"In %@", preString];
	[[NSDate sharedRecursiveLock] unlock];
    return string;
}


#pragma mark - MISC

+ (NSArray *)datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger days = [endDate daysSinceDate:startDate];
    NSMutableArray *datesArray = [NSMutableArray array];

    for (int i = 0; i < days; i++) {
        [datesArray addObject:[startDate dateDaysAfter:i]];
    }

    NSArray *array = [NSArray arrayWithArray:datesArray];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

- (NSArray *)hoursInCurrentDayAsDatesCollection
{
	[[NSDate sharedRecursiveLock] lock];
    NSMutableArray *hours = [NSMutableArray array];
    for (int i = 23; i >= 0; i--) {
        [hours addObject:[NSDate dateFromYear:[self year]
                                           month:[self monthOfYear]
                                             day:[self dayOfMonth]
                                            hour:i
                                          minute:0]];
    }
    NSArray *array = [NSArray arrayWithArray:hours];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

- (BOOL)isInAM
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isInAM = [self hourOfDay] > 11 ? NO : YES;
	[[NSDate sharedRecursiveLock] unlock];
    return isInAM;
}

- (BOOL)isStartOfAnHour
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isStartOfAnHour = ([self minuteOfHour] == (NSInteger)[NSDate minValueForUnit:NSCalendarUnitMinute] &&
                            [self secondOfMinute] == (NSInteger)[NSDate minValueForUnit:NSCalendarUnitSecond]);
	[[NSDate sharedRecursiveLock] unlock];
    return isStartOfAnHour;
}

- (NSInteger)weekdayStartOfCurrentMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger weekdayStartOfCurrentMonth = [[self startOfCurrentMonth] weekdayOfWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return weekdayStartOfCurrentMonth;
}

- (NSInteger)daysInCurrentMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger daysInCurrentMonth = [[self endOfCurrentMonth] dayOfMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return daysInCurrentMonth;
}

- (NSInteger)daysInPreviousMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger daysInPreviousMonth = [[self endOfPreviousMonth] dayOfMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return daysInPreviousMonth;
}

- (NSInteger)daysInNextMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger daysInNextMonth = [[self endOfNextMonth] dayOfMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return daysInNextMonth;
}

- (NSDate *)inTimeZone:(NSTimeZone *)timezone
{
	[[NSDate sharedRecursiveLock] lock];
    NSTimeZone *current             = __timeZone ? __timeZone : [NSTimeZone defaultTimeZone];
    NSTimeInterval currentOffset    = [current secondsFromGMTForDate:self];
    NSTimeInterval toOffset         = [timezone secondsFromGMTForDate:self];
    NSTimeInterval diff             = toOffset - currentOffset;
    NSDate *date = [self dateByAddingTimeInterval:diff];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSInteger)minValueForUnit:(NSCalendarUnit)unit
{
	[[NSDate sharedRecursiveLock] lock];
    NSRange r = [[self calendar] minimumRangeOfUnit:unit];
    NSInteger minValueForUnit = r.location;
	[[NSDate sharedRecursiveLock] unlock];
    return minValueForUnit;
}

+ (NSInteger)maxValueForUnit:(NSCalendarUnit)unit
{
	[[NSDate sharedRecursiveLock] lock];
    NSRange r = [[self calendar] maximumRangeOfUnit:unit];
    NSInteger maxValueForUnit = r.length - 1;
	[[NSDate sharedRecursiveLock] unlock];
    return maxValueForUnit;
}


#pragma mark - Private

+ (void)prepareDefaults
{
    NSCalendar *currentCalendar = (NSCalendar *)[NSCalendar currentCalendar];

    if (!__calendarType) {
        __calendarType = [currentCalendar calendarIdentifier];
    }

    if (__weekNumberingSystem == 0) {
        NSCalendar *currentCalendar = (NSCalendar *)[NSCalendar currentCalendar];
        __weekNumberingSystem = [currentCalendar minimumDaysInFirstWeek];
    }

    if (__firstWeekday == 0) {
        NSCalendar *currentCalendar = (NSCalendar *)[NSCalendar currentCalendar];
        __firstWeekday = [currentCalendar firstWeekday];
    }

    if (!__locale) {
        __locale = [NSLocale currentLocale];
    }

    if (!__timeZone) {
        __timeZone = [NSTimeZone localTimeZone];
    }
}

+ (NSCalendar *)calendar
{
    [self prepareDefaults];

    if (!__calendar) {
        __calendar                            = [[NSCalendar alloc] initWithCalendarIdentifier:__calendarType];
        __calendar.firstWeekday               = __firstWeekday;
        __calendar.minimumDaysInFirstWeek     = (NSInteger)__weekNumberingSystem;
        __calendar.timeZone                   = __timeZone;
    }

    return __calendar;
}

+ (NSDateComponents *)components
{
    [self prepareDefaults];

    if (!__components) {
        __components = [[NSDateComponents alloc] init];
        __components.calendar = [self calendar];
        if (__timeZone) __components.timeZone = __timeZone;
    }

    [__components setEra:NSDateComponentUndefined];
    [__components setYear:NSDateComponentUndefined];
    [__components setMonth:NSDateComponentUndefined];
    [__components setDay:NSDateComponentUndefined];
    [__components setHour:NSDateComponentUndefined];
    [__components setMinute:NSDateComponentUndefined];
    [__components setSecond:NSDateComponentUndefined];
    [__components setWeekOfYear:NSDateComponentUndefined];
    [__components setWeekday:NSDateComponentUndefined];
    [__components setWeekdayOrdinal:NSDateComponentUndefined];
    [__components setQuarter:NSDateComponentUndefined];

    return __components;
}

+ (void)reset
{
    [[NSDate sharedRecursiveLock] lock];
    __calendar      = nil;
    __components    = nil;
    __formatter     = nil;
    [[NSDate sharedRecursiveLock] unlock];
}

+ (NSRecursiveLock *)sharedRecursiveLock
{
    static NSRecursiveLock *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [NSRecursiveLock new];
    });
    return lock;
}

@end


#pragma mark - Common Date Formats

NSString *const MTDatesFormatDefault        = @"EE, MMM dd, yyyy, HH:mm:ss";    // Sat Jun 09 2007 17:46:21
NSString *const MTDatesFormatShortDate      = @"M/d/yy";                        // 6/9/07
NSString *const MTDatesFormatMediumDate     = @"MMM d, yyyy";                   // Jun 9, 2007
NSString *const MTDatesFormatLongDate       = @"MMMM d, yyyy";                  // June 9, 2007
NSString *const MTDatesFormatFullDate       = @"EEEE, MMMM d, yyyy";            // Saturday, June 9, 2007
NSString *const MTDatesFormatShortTime      = @"h:mm a";                        // 5:46 PM
NSString *const MTDatesFormatMediumTime     = @"h:mm:ss a";                     // 5:46:21 PM
NSString *const MTDatesFormatLongTime       = @"h:mm:ss a zzz";                 // 5:46:21 PM EST
NSString *const MTDatesFormatISODate        = @"yyyy-MM-dd";                    // 2007-06-09
NSString *const MTDatesFormatISOTime        = @"HH:mm:ss";                      // 17:46:21
NSString *const MTDatesFormatISODateTime    = @"yyyy-MM-dd HH:mm:ss";           // 2007-06-09 17:46:21
