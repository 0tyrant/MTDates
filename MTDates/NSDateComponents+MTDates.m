//
//  NSDateComponents+NSDateComponents_MTDates.m
//  MTDates
//
//  Created by Adam Kirk (@atomkirk) on 9/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NSDateComponents+MTDates.h"
#import "NSDate+MTDates.h"

@implementation NSDateComponents (MTDates)


+ (NSDateComponents *)componentsFromString:(NSString *)string
{
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  if (!string) return comps;

  NSArray *parts = [string componentsSeparatedByString:@" "];
  for (NSString *part in parts) {
    if (part.length == 4 && [part rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
      [comps setYear:[[NSDate dateFromString:part usingFormat:@"yyyy"] year]];
      continue;
    }
    if ([part rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound) {
      [comps setMonth:[[NSDate dateFromString:part usingFormat:@"MMMM"] monthOfYear]];
      continue;
    }
    if (part.length == 2) {
      [comps setDay:[[NSDate dateFromString:part usingFormat:@"dd"] dayOfMonth]];
      continue;
    }
  }

  // if the day was set but the month wasn't, interpret the two digits as the month
  if ([comps month] == NSDateComponentUndefined && [comps day] != NSDateComponentUndefined) {
    [comps setMonth:MIN([comps day], 12)];
    [comps setDay:NSDateComponentUndefined];
  }

  return comps;
}

- (NSString *)stringValue
{
  NSMutableArray *partsArray = [NSMutableArray array];
  NSDateComponents *required = [self copy];
  required.year = self.year   == NSDateComponentUndefined ? 1970  : self.year;
  required.month  = self.month  == NSDateComponentUndefined ? 1   : self.month;
  required.day  = self.day    == NSDateComponentUndefined ? 1   : self.day;
  NSDate *date = [NSDate dateFromComponents:required];

  if ([self day] != NSDateComponentUndefined) {
    [partsArray addObject:[date stringFromDateWithFormat:@"dd" localized:NO]];
  }
  if ([self month] != NSDateComponentUndefined) {
    [partsArray addObject:[date stringFromDateWithFormat:@"MMMM" localized:NO]];
  }
  if ([self year] != NSDateComponentUndefined) {
    [partsArray addObject:[date stringFromDateWithFormat:@"yyyy" localized:NO]];
  }
  return [partsArray componentsJoinedByString:@" "];
}

- (BOOL)isEqualToDateComponents:(NSDateComponents *)components
{
  BOOL era    = self.era                == components.era;
  BOOL year   = self.year               == components.year;
  BOOL month  = self.month              == components.month;
  BOOL day    = self.day                == components.day;
  BOOL hour   = self.hour               == components.hour;
  BOOL min    = self.minute             == components.minute;
  BOOL sec    = self.second             == components.second;
  BOOL wkday  = self.weekday            == components.weekday;
  BOOL wkOrd  = self.weekdayOrdinal     == components.weekdayOrdinal;
  BOOL quart  = self.quarter            == components.quarter;
  BOOL wkofM  = self.weekOfMonth        == components.weekOfMonth;
  BOOL wkofY  = self.weekOfYear         == components.weekOfYear;
  BOOL YfWoY  = self.yearForWeekOfYear  == components.yearForWeekOfYear;
  return era && year && month && month && day && hour && min && sec && wkday && wkOrd && quart && wkofM && wkofY && YfWoY;
}

#if MTDATES_NO_PREFIX

#pragma mark - NO PREFIX

+ (NSDateComponents *)componentsFromString:(NSString *)string
{
    return [self componentsFromString:string];
}

- (NSString *)stringValue
{
    return [self stringValue];
}

- (BOOL)isEqualToDateComponents:(NSDateComponents *)components
{
    return [self isEqualToDateComponents:components];
}

#endif

@end
