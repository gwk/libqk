// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "NSDate+QK.h"


@implementation NSDate (QK)


+ (NSTimeInterval)refTime {
  return [self timeIntervalSinceReferenceDate];
}


+ (NSTimeInterval)posixTime {
  static NSTimeInterval offset = 0;
  if (!offset) {
    NSDate* ref = [self dateWithTimeIntervalSinceReferenceDate:0];
    offset = [ref timeIntervalSince1970];
  }
  return [self timeIntervalSinceReferenceDate] + offset;
}


+ (NSDate*)withRefTime:(NSTimeInterval)refTime {
  return [self dateWithTimeIntervalSinceReferenceDate:refTime];
}


+ (NSDate*)withPosixTime:(NSTimeInterval)posixTime {
  return [self dateWithTimeIntervalSince1970:posixTime];
}


- (NSTimeInterval)refInterval {
    return self.timeIntervalSinceReferenceDate;
}


- (NSTimeInterval)posixInterval {
    return self.timeIntervalSince1970;
}


- (BOOL)isSameDayAs:(NSDate *)date {
    NSCalendarUnit units = (NSCalendarUnit)(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDateComponents *d = [[NSCalendar currentCalendar] components:units fromDate:self];
    NSDateComponents *s = [[NSCalendar currentCalendar] components:units fromDate:date];
    return (d.day == s.day && d.month == s.month && d.year == s.year && d.era == s.era);
}


@end

