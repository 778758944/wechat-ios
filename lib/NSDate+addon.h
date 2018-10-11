//
//  NSDate+addon.h
//  WeChat
//
//  Created by Tom Xing on 9/17/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (addon)
-(BOOL) isSameDay;
-(BOOL) isYesterday;
-(BOOL) isIncludeWeek;
-(NSDate *) dateWithYMD;
@end
