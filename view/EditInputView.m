//
//  EditInputView.m
//  WeChat
//
//  Created by Tom Xing on 9/24/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "EditInputView.h"
#import "UIColor+transform.h"

UIEdgeInsets _inset;

@implementation EditInputView

+(void) initialize
{
    _inset = UIEdgeInsetsMake(0, 10, 0, 0);
}

-(CGRect) textRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, _inset);
}

-(CGRect) editingRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, _inset);
}
/*
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, 20, 44);
}
 */

-(void) drawRect:(CGRect)rect
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:rect.origin];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.origin.y)];
    [path moveToPoint:CGPointMake(rect.origin.x, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    
    [[UIColor transformColorFormHex:@"d9d9d9"] setStroke];
    [path stroke];
}
@end
