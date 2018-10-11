//
//  MineContainer.h
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;

@interface MineContainer : UIView
@property(nonatomic, strong) UIImageView * avator;
-(instancetype) initWithMsg: (Message *) msg;
@end
