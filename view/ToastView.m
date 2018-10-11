//
//  ToastView.m
//  WeChat
//
//  Created by Tom Xing on 8/27/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "ToastView.h"
@interface ToastView()
@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UILabel * textLabel;
@end

@implementation ToastView

-(instancetype) init
{
    self = [super init];
    if (self) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backView.translatesAutoresizingMaskIntoConstraints = NO;
        _backView.layer.cornerRadius = 5;
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:20];
        _textLabel.numberOfLines = 10;
        
        [_backView addSubview:_textLabel];
        [self addSubview:_backView];
        [self customStyle];
    }
    return self;
}


-(void) customStyle
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
    
    [_backView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [_backView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [_backView.leadingAnchor constraintGreaterThanOrEqualToSystemSpacingAfterAnchor:self.leadingAnchor multiplier:1].active = YES;
    [_backView.trailingAnchor constraintLessThanOrEqualToSystemSpacingAfterAnchor:self.trailingAnchor multiplier:1].active = YES;
    
    _backView.layoutMargins = UIEdgeInsetsMake(10, 20, 10, 20);
    
    NSDictionary * dic = @{
                           @"textLabel": _textLabel
                           };
    
    NSArray<NSLayoutConstraint *> * h_t = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:nil views:dic];
    NSArray<NSLayoutConstraint *> * v_t = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textLabel]-|" options:0 metrics:nil views:dic];
    [_backView addConstraints:h_t];
    [_backView addConstraints:v_t];
    
    
}

-(void) setText: (NSString *) text
{
    _textLabel.text = text;
}

@end
