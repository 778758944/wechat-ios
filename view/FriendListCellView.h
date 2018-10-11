//
//  FriendListCellView.h
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListCellView : UITableViewCell
@property(nonatomic, strong) UIImageView * avator;
@property(nonatomic, strong) UILabel * username;
@property(nonatomic, strong) UILabel * lastMsg;
@property(nonatomic, strong) UILabel * time;
@property(nonatomic, strong) UILabel * unreadMsg;
@end
