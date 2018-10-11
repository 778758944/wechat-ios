//
//  MineContainer.m
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "MineContainer.h"
#import "Message.h"
#import "TextMsgView.h"
#import "VoiceMineMsg.h"
#import "ImageMsgView.h"
#import "UIColor+transform.h"
#import "Arrow.h"
#import "User+addon.h"

@interface MineContainer()
@property(nonatomic, strong) UIView * msgView;
@end

@implementation MineContainer

-(instancetype) initWithMsg:(Message *)msg
{
    self = [super init];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.avator = [[UIImageView alloc] init];
        _avator.translatesAutoresizingMaskIntoConstraints = NO;
//        _avator.image = [UIImage imageNamed:@"girl.jpg"];
        _avator.contentMode = UIViewContentModeScaleAspectFill;
        _avator.clipsToBounds = YES;
        [self addSubview:_avator];
        
        if ([msg.msgType isEqualToString:@"0"]) {
            NSString * text = [[NSString alloc] initWithData:msg.data encoding:(NSUTF8StringEncoding)];
            self.msgView = [[TextMsgView alloc] initWithText:text];
            self.msgView.backgroundColor = [UIColor transformColorFormHex:@"a0e75a"];
            [self addSubview:self.msgView];
            [self.msgView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant: 0].active = YES;
            [self addArrow];
        } else if ([msg.msgType isEqualToString:@"img"]) {
            self.msgView = [[ImageMsgView alloc] initWithMsg:msg];
            [self addSubview:_msgView];
        } else if ([msg.msgType isEqualToString:@"wav"]) {
            
            self.msgView = [[VoiceMineMsg alloc] initWithMessage:msg];
            [self addSubview:self.msgView];
            [self.msgView.heightAnchor constraintEqualToConstant:40].active = YES;
            [self.msgView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
            [self addArrow];
        }
        
        [self customStyle];
    }
    
    return self;
}

-(void) customStyle
{
    [self.avator.widthAnchor constraintEqualToConstant:40].active = YES;
    [self.avator.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.avator.topAnchor constraintEqualToAnchor:self.topAnchor constant: 5].active = YES;
    [self.avator.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    [self.msgView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-50].active = YES;
    [self.msgView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.msgView.bottomAnchor].active = YES;
}

-(void) addArrow
{
    UIImage * arrow = [Arrow getMineArrow];
    UIImageView * arrowView = [[UIImageView alloc] initWithImage:arrow];
    arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    [arrowView.widthAnchor constraintEqualToConstant:arrowWidth].active = YES;
    [arrowView.heightAnchor constraintEqualToConstant:arrowHeight].active = YES;
    [self addSubview:arrowView];
        [arrowView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5 + (40-arrowHeight)/2].active = YES;
    [arrowView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-45].active = YES;
}


@end
