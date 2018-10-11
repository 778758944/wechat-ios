//
//  UIColor+transform.m
//  WeChat
//
//  Created by Tom Xing on 8/20/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "UIColor+transform.h"

@implementation UIColor (transform)
+(UIColor *) transformColorFormHex: (NSString *) hexColor
{
    int x;
    int mask = 0xFF;
    sscanf([hexColor cStringUsingEncoding:NSUTF8StringEncoding], "%x", &x);
    
    CGFloat red = ((x >> 16) & mask)/255.0;
    CGFloat green = ((x>>8) & mask)/255.0;
    CGFloat blue = (x & mask)/255.0;
    
    return [UIColor colorWithRed:red green: green blue:blue alpha:1];
}
@end
