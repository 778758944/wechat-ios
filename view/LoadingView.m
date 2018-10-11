//
//  LoadingView.m
//  WeChat
//
//  Created by Tom Xing on 8/27/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property(nonatomic, strong) UIActivityIndicatorView * loadingView;
@property(nonatomic, strong) UILabel * textLabel;
@property(nonatomic, copy) NSString * text;
@property(nonatomic, strong) UIView * backView;
@end

@implementation LoadingView

-(instancetype) init
{
    self = [super init];
    if (self) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        [_loadingView startAnimating];
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"Loading";
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 8;
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_backView addSubview:_loadingView];
        [_backView addSubview:_textLabel];
        
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _backView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_backView];
        self.alpha = 0;
        [self customStyle];
    }
    
    return self;
}

-(void) customStyle {
    CGRect winFrame = [[UIScreen mainScreen] bounds];
    self.frame = winFrame;
    
    [_backView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.375].active = YES;
    [_backView.heightAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.375].active = YES;
    [_backView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [_backView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    [_loadingView.centerXAnchor constraintEqualToAnchor:_backView.centerXAnchor].active = YES;
    [_loadingView.topAnchor constraintEqualToAnchor:_backView.topAnchor constant:25].active = YES;
    
    [_textLabel.leadingAnchor constraintEqualToAnchor:_backView.leadingAnchor constant:19].active = YES;
    [_textLabel.trailingAnchor constraintEqualToAnchor:_backView.trailingAnchor constant:-19].active = YES;
    [_textLabel.bottomAnchor constraintEqualToAnchor:_backView.bottomAnchor constant:-20].active = YES;
}



@end
