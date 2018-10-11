//
//  VoiceOtherMsg.m
//  WeChat
//
//  Created by Tom Xing on 9/11/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "VoiceOtherMsg.h"
#import "UIColor+transform.h"


@implementation VoiceOtherMsg

-(instancetype) initWithMessage:(Message *)msg
{
    self = [super initWithMessage:msg];
    
    if (self) {
        self.btn.backgroundColor = [UIColor whiteColor];
        self.btn.layer.borderColor = [UIColor transformColorFormHex:@"d4d4d4"].CGColor;
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        NSDictionary * dict = @{
                                @"btn": self.btn,
                                @"duration": self.duration,
                                };
        
        NSArray<NSLayoutConstraint *> * h_con = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btn]-8-[duration]|" options:0 metrics:nil views:dict];
        
        [self.contentView addConstraints:h_con];
        
        [self.icon.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5].active = YES;
    }
    
    return self;
}

@end

































