//
//  VoiceMineMsg.m
//  WeChat
//
//  Created by Tom Xing on 9/10/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "VoiceMineMsg.h"


@implementation VoiceMineMsg

-(instancetype) initWithMessage: (Message *) msg;
{
    self = [super initWithMessage:msg];
    if (self) {
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        NSDictionary * dict = @{
                                @"btn": self.btn,
                                @"duration": self.duration
                                };
        
        NSArray<NSLayoutConstraint *> * h_con = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[duration]-8-[btn]|" options:0 metrics:nil views:dict];
        
        [self.contentView addConstraints:h_con];
        self.icon.transform = CGAffineTransformRotate(self.icon.transform, M_PI);
        
        [self.icon.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5].active = YES;
        
    }
    
    return self;
}

@end





































