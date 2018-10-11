//
//  ImageMsgView.h
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;

@interface ImageMsgView : UIImageView
-(instancetype) initWithMsg: (Message *) msg;
@end
