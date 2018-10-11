//
//  DateCustomFormat.h
//  WeChat
//
//  Created by Tom Xing on 9/17/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateCustomFormat : NSObject
+(NSString *) formatForListWithDate: (NSDate *) date;
+(NSString *) formatForMessageWithDate: (NSDate *) date;
@end
