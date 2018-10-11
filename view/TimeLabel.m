//
//  TimeLabel.m
//  WeChat
//
//  Created by Tom Xing on 9/18/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "TimeLabel.h"
#import "UIColor+transform.h"

@implementation TimeLabel {
    UIEdgeInsets _edgeInset;
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        _edgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor transformColorFormHex:@"cecece"];
        self.font = [UIFont systemFontOfSize:11];
        self.textColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

-(CGSize) intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width += _edgeInset.left * 2;
    return size;
}

-(void) drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _edgeInset)];
}

@end
