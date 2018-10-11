//
//  VoiceMsg.m
//  WeChat
//
//  Created by Tom Xing on 9/11/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "VoiceMsg.h"
#import "VoiceMineMsg.h"
#import "UIColor+transform.h"
#import "Message.h"
#import "VoiceMsgPlayer.h"
#import "RecordBtn.h"

@implementation VoiceMsg

-(instancetype) initWithMessage: (Message *) msg
{
    self = [super init];
    if (self) {
        self.msg = msg;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.btn = [RecordBtn buttonWithType:(UIButtonTypeCustom)];
        _btn.translatesAutoresizingMaskIntoConstraints = NO;
        _btn.backgroundColor = [UIColor transformColorFormHex:@"a0e75a"];
        _btn.layer.cornerRadius = 5;
        _btn.layer.borderWidth = 1;
        _btn.layer.borderColor = [UIColor transformColorFormHex:@"6fb44d"].CGColor;
        _btn.layer.masksToBounds = YES;
        [_btn addTarget:self action:@selector(playSound) forControlEvents:(UIControlEventTouchDown)];
        
        self.icon = [[UIImageView alloc] init];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
        _icon.image = [UIImage imageNamed:@"voice.png"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.clipsToBounds = YES;
        
        
        self.duration = [[UILabel alloc] init];
        _duration.translatesAutoresizingMaskIntoConstraints = NO;
        _duration.text = [NSString stringWithFormat:@"%.0f'", [VoiceMsgPlayer getDurationOfData:msg.data]];
        _duration.textColor = [UIColor transformColorFormHex:@"afafaf"];
        _duration.font = [UIFont systemFontOfSize:12];
        
        self.contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_contentView addSubview:_duration];
        [_contentView addSubview:_btn];
        
        [self addSubview:_contentView];
        [self addSubview:_icon];
        [self commonStyle];
        
        
    }
    
    return self;
}

-(void) commonStyle
{
    CGFloat ratio = [VoiceMsgPlayer getRatioWithData:self.msg.data];
    [_contentView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:ratio].active = YES;
    [_contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [_contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    
    
    [self.icon.widthAnchor constraintEqualToConstant:24].active = YES;
    [self.icon.heightAnchor constraintEqualToConstant:24].active = YES;
    [self.icon.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    
    [self.btn.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor].active = YES;
    [self.btn.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.duration.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    
    [self.duration setContentHuggingPriority:1000 forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.duration setContentCompressionResistancePriority:1000 forAxis:(UILayoutConstraintAxisHorizontal)];
    
    
    
}

-(void) playSound
{
    [VoiceMsgPlayer playWithData: _msg.data];
}

@end
