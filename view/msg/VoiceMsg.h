//
//  VoiceMsg.h
//  WeChat
//
//  Created by Tom Xing on 9/11/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;
@class RecordBtn;

@interface VoiceMsg : UIView
@property(nonatomic, strong, readwrite) UIButton * btn;
@property(nonatomic, strong) UIImageView * icon;
@property(nonatomic, strong) UILabel * duration;
@property(nonatomic, weak) Message * msg;
@property(nonatomic, strong) UIView * contentView;

-(instancetype) initWithMessage: (Message *) msg;
@end
