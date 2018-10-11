//
//  VoiceRecordNotice.m
//  WeChat
//
//  Created by Tom Xing on 9/9/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "VoiceRecordNotice.h"
#import "UIColor+transform.h"

@interface VoiceRecordNotice ()
@property(nonatomic, strong, readwrite) UIProgressView * volume;
@property(nonatomic, strong) UILabel * noticeLabel;
@property(nonatomic, strong) UIImageView * icon;
@property(nonatomic, strong) UIView * contentView;
@end


@implementation VoiceRecordNotice


-(instancetype) init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"record.png"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.clipsToBounds = YES;
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        self.noticeLabel = [[UILabel alloc] init];
        _noticeLabel.text = @"Slide up to cancel";
        _noticeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noticeLabel.textColor = [UIColor whiteColor];
        _noticeLabel.font = [UIFont systemFontOfSize:14];
        
        self.volume = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//        _volume.translatesAutoresizingMaskIntoConstraints = NO;
        _volume.frame = CGRectMake(0, 0, 40, 10);
        _volume.progress = 0.5;
        _volume.progressTintColor = [UIColor transformColorFormHex:@"e3e3e3"];
        _volume.trackTintColor = [UIColor clearColor];
        
        self.contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
        
        [self.contentView addSubview: _icon];
        [self.contentView addSubview: _noticeLabel];
        [self.contentView addSubview: _volume];
        [self addSubview:_contentView];
        
        _volume.transform = CGAffineTransformTranslate(_volume.transform, 72, 55);
        _volume.transform = CGAffineTransformRotate(_volume.transform, M_PI/-2);
        
        [_contentView.widthAnchor constraintEqualToConstant:150].active = YES;
        [_contentView.heightAnchor constraintEqualToConstant:150].active = YES;
        [_contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
        [_icon.widthAnchor constraintEqualToConstant:40].active = YES;
        [_icon.topAnchor constraintEqualToAnchor:_contentView.topAnchor].active = YES;
        [_icon.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor].active = YES;
        [_icon.centerYAnchor constraintEqualToAnchor:_contentView.centerYAnchor constant:-20].active = YES;
        
        [_noticeLabel.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor].active = YES;
        [_noticeLabel.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor constant:-14].active = YES;
        
        /*
        [_volume.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor].active = YES;
        [_volume.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor].active = YES;
        [_volume.heightAnchor constraintEqualToConstant:5].active = YES;
        [_volume.topAnchor constraintEqualToAnchor:_contentView.topAnchor constant:80].active = YES;
         */
        
        
    }
    
    return self;
}

@end
