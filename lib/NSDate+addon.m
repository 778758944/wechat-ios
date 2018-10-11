//
//  NSDate+addon.m
//  WeChat
//
//  Created by Tom Xing on 9/17/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "NSDate+addon.h"

@implementation NSDate (addon)
-(BOOL) isSameDay
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents * selfComp = [calendar components:unit fromDate: self];
    NSDateComponents * currentComp = [calendar components:unit fromDate:[NSDate date]];
    
    return selfComp.year == currentComp.year && selfComp.month == currentComp.month && selfComp.day == currentComp.day;
}

-(BOOL) isYesterday
{
    NSDate * nowDate = [[NSDate date] dateWithYMD];
    NSDate * selfDate = [self dateWithYMD];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

-(BOOL) isIncludeWeek
{
    NSDate * nowDate = [[NSDate date] dateWithYMD];
    NSDate * selfDate = [self dateWithYMD];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    NSLog(@"cmps: %@", cmps);
    
    return cmps.day < 7;
}

-(NSDate *) dateWithYMD
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString * selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}


@end



































