//
//  TopLineView.m
//  WeChat
//
//  Created by Tom Xing on 9/1/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "TopLineView.h"
#import "UIColor+transform.h"

@implementation TopLineView

-(id) init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void) drawRect:(CGRect)rect
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width, 0)];
    path.lineWidth = 1;
    [[UIColor transformColorFormHex:@"d7d7d9"] setStroke];
    [path stroke];
}

@end
