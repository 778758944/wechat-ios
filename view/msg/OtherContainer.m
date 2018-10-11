//
//  OtherContainer.m
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "OtherContainer.h"
#import "Message.h"
#import "TextMsgView.h"
#import "VoiceOtherMsg.h"
#import "ImageMsgView.h"
#import "UIColor+transform.h"
#import <AVFoundation/AVFoundation.h>
#import "Arrow.h"

@interface OtherContainer()
@property(nonatomic, strong) UIView * contentView;
@end

@implementation OtherContainer

-(instancetype) initWithMsg: (Message *) msg
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.avator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
//        _avator.image = [UIImage imageNamed:@"girl.jpg"];
        _avator.contentMode = UIViewContentModeScaleAspectFill;
        _avator.clipsToBounds = YES;
        [self addSubview:_avator];
        
        // msg
        if ([msg.msgType isEqualToString:@"0"]) {
            NSString * text = [[NSString alloc] initWithData:msg.data encoding:(NSUTF8StringEncoding)];
            self.contentView = [[TextMsgView alloc] initWithText:text];
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.contentView.layer.borderColor = [UIColor transformColorFormHex:@"d4d4d4"].CGColor;
            [self addSubview:_contentView];
            [_contentView.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor].active = YES;
            [self addArrow];
        } else if ([msg.msgType isEqualToString:@"img"]) {
            self.contentView = [[ImageMsgView alloc] initWithMsg:msg];
            [self addSubview:_contentView];
            
        } else if ([msg.msgType isEqualToString:@"wav"]) {
            self.contentView = [[VoiceOtherMsg alloc] initWithMessage:msg];
            [self addSubview:_contentView];
            [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
            [self.contentView.heightAnchor constraintEqualToConstant:40].active = YES;
            [self addSubview:_contentView];
            [self addArrow];
        }
        [self customStyle];
    }
    
    return self;
}

-(void) customStyle
{
    [_contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:50].active = YES;
    [_contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor].active = YES;
}

-(void) addArrow
{
    UIImage * arrow = [Arrow getOtherArrow];
    UIImageView * arrowView = [[UIImageView alloc] initWithImage:arrow];
    arrowView.frame = CGRectMake(45, 5+(40-arrowHeight)/2, 6, 11);
    [self addSubview:arrowView];
}

@end
