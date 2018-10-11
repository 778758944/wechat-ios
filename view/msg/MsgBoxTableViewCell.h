//
//  MsgBoxTableViewCell.h
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;

@interface MsgBoxTableViewCell : UITableViewCell
@property(nonatomic, weak) Message * msg;
@property(nonatomic, strong) UIView * msgContainer;

-(instancetype) initWithMessage:(Message *) msg reuseIdentifier:(NSString *)reuseIdentifier MineAvator: (UIImage *) mineAvator OtherAvator: (UIImage *) otherAvator;

@end
