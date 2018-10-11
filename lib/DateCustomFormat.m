//
//  DateCustomFormat.m
//  WeChat
//
//  Created by Tom Xing on 9/17/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "DateCustomFormat.h"
#import "NSDate+addon.h"

@implementation DateCustomFormat
+(NSString *) formatForListWithDate: (NSDate *) date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    if ([date isSameDay]) {
        dateFormatter.dateFormat = @"hh:mm a";
    } else if ([date isYesterday]) {
        return @"Yesterday";
    } else if ([date isIncludeWeek]) {
        dateFormatter.dateFormat = @"cccc";
    } else {
        dateFormatter.dateFormat = @"M/d/yyyy";
    }
    return [dateFormatter stringFromDate:date];
}


+(NSString *) formatForMessageWithDate: (NSDate *) date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    if ([date isSameDay]) {
        dateFormatter.dateFormat = @"hh:mm a";
    } else if ([date isYesterday]) {
        dateFormatter.dateFormat = @"hh:mm a";
        return [NSString stringWithFormat:@"Yesterday %@", [dateFormatter stringFromDate:date]];
    } else if ([date isIncludeWeek]) {
        dateFormatter.dateFormat = @"cccc hh:mm a";
    } else {
        dateFormatter.dateFormat = @"LLL d, yyyy hh:mm a";
    }
    return [dateFormatter stringFromDate:date];
}



@end
































