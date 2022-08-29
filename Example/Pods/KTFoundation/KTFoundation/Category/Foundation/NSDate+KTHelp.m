//
//  NSDate+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSDate+KTHelp.h"
#import <time.h>

@implementation NSDate (KTHelp)

- (NSInteger)kt_year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)kt_month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)kt_day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)kt_hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)kt_minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)kt_second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)kt_nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)kt_weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)kt_weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)kt_weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)kt_weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)kt_yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)kt_quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)kt_isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)kt_isLeapYear {
    NSUInteger year = self.kt_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)kt_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].kt_day == self.kt_day;
}

- (BOOL)kt_isYesterday {
    NSDate *added = [self kt_dateByAddingDays:1];
    return [added kt_isToday];
}

- (NSDate *)kt_dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)kt_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)kt_dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)kt_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)kt_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)kt_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)kt_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSString *)kt_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)kt_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

- (NSString *)kt_stringWithISOFormat {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter stringFromDate:self];
}

+ (NSDate *)kt_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)kt_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)kt_dateWithISOFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter dateFromString:dateString];
}

#pragma mark - Date relative
+ (NSDate *)kt_weekFirstDayWithDate:(NSDate *)date
{
	NSTimeInterval interval = 0;
	NSDate *firstDay;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	[calendar setFirstWeekday:2];
	BOOL success = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&firstDay interval:&interval forDate:date];
	return success ? firstDay : nil;
}

+ (NSDate *)kt_weekLastDayWithDate:(NSDate *)date
{
	double interval = 0;
	NSDate *firstDay;
	NSDate *lastDay;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	[calendar setFirstWeekday:2];
	BOOL success = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&firstDay interval:&interval forDate:date];
	if (success) {
		lastDay = [firstDay dateByAddingTimeInterval:interval - 1];
	}
	return success ? lastDay : nil;
}

+ (NSDate *)kt_monthFirstDayWithDate:(NSDate *)date
{
	NSTimeInterval interval = 0;
	NSDate *firstDay;
	BOOL success = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:&interval forDate:date];
	return success ? firstDay : nil;
}

+ (NSDate *)kt_monthLastDayWithDate:(NSDate *)date
{
	double interval = 0;
	NSDate *firstDay;
	NSDate *lastDay;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	BOOL success = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:&interval forDate:date];
	if (success) {
		lastDay = [firstDay dateByAddingTimeInterval:interval - 1];
	}
	return success ? lastDay : nil;
}

- (nullable NSDate *)kt_firstDayInTheWeek
{
	return [NSDate kt_weekFirstDayWithDate:self];
}

- (nullable NSDate *)kt_lastDayInTheWeek
{
	return [NSDate kt_weekLastDayWithDate:self];
}

- (nullable NSDate *)kt_firstDayInTheMonth
{
	return [NSDate kt_monthFirstDayWithDate:self];
}

- (nullable NSDate *)kt_lastDayInTheMonth
{
	return [NSDate kt_monthLastDayWithDate:self];
}

- (NSDate *)kt_yesterday
{
	return [self kt_dateByAddingDays:-1];
}

- (NSDate *)kt_tomorrow
{
	return [self kt_dateByAddingDays:1];
}

@end
