//
//  InputView.m
//  WeChat
//
//  Created by Tom Xing on 8/20/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "InputView.h"
#import "UIColor+transform.h"

@implementation InputView

-(instancetype) initWithName: (NSString *) labelName placeholder: (NSString *) placeholder
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.textField = [[UITextField alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        
        
        self.textField.placeholder = placeholder;
        self.nameLabel.text = labelName;
        
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [self addSubview:self.textField];
        [self addSubview:self.nameLabel];
        [self customeStyle];
        
    }
    
    return self;
    
}

-(void) customeStyle
{
    [self.nameLabel.leadingAnchor  constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.textField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.textField.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.nameLabel.firstBaselineAnchor constraintEqualToAnchor:self.textField.firstBaselineAnchor].active = YES;
    [self.nameLabel.lastBaselineAnchor constraintEqualToAnchor:self.textField.lastBaselineAnchor].active = YES;
    [self.textField.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:14.0].active = YES;
    [self.textField.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.textField setContentHuggingPriority:1 forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.textField setContentCompressionResistancePriority:1 forAxis:(UILayoutConstraintAxisHorizontal)];
}


-(void) layoutSubviews
{
//    NSLog(@"self frame: %@", [NSValue valueWithCGRect:self.frame]);
//    [self customeStyle];
}

-(void) drawRect:(CGRect)rect
{
    UIBezierPath * bottomBorder = [UIBezierPath bezierPath];
    [bottomBorder moveToPoint:CGPointMake(0, rect.size.height)];
    [bottomBorder addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    bottomBorder.lineWidth = 0.5;
    [[UIColor transformColorFormHex:@"C9C9C9"] setStroke];
    [bottomBorder stroke];
}

@end
