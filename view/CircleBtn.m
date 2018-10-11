//
//  CircleBtn.m
//  WeChat
//
//  Created by Tom Xing on 8/29/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "CircleBtn.h"
#import "UIColor+transform.h"

@implementation CircleBtn

+(id) buttonWithImage: (UIImage *) image;
{
    CircleBtn * btn = [CircleBtn buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn.widthAnchor constraintEqualToConstant:30].active = YES;
    [btn.heightAnchor constraintEqualToConstant:30].active = YES;
    btn.layer.cornerRadius = 15;
    btn.layer.borderColor = [UIColor transformColorFormHex:@"83868c"].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    return btn;
}

-(CGRect) backgroundRectForBounds:(CGRect)bounds
{
    return CGRectMake(3, 3, 24, 24);
}

-(void) setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundColor = [UIColor transformColorFormHex:@"dcdcdd"];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}



@end
