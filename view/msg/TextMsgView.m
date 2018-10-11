//
//  TextMsgView.m
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "TextMsgView.h"
#import "UIColor+transform.h"
const NSInteger padding = 10;

@interface TextMsgView()
@property(nonatomic, assign) UIEdgeInsets insets;
@end

@implementation TextMsgView

-(instancetype) initWithText: (NSString *) text
{
    self = [super init];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.text = text;
        self.font = [UIFont systemFontOfSize:16];
//        self.backgroundColor = [UIColor transformColorFormHex:@"a0e75a"];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor transformColorFormHex:@"6fb44d"].CGColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.numberOfLines = 0;
        self.insets = UIEdgeInsetsMake(padding, padding, padding, padding);
    }
    
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, self.insets);
    [super drawTextInRect:insetRect];
}

-(CGSize) intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width += padding * 2;
    size.height += padding * 2;
    
    return size;
}

@end
