//
//  UserSetting.h
//  WeChat
//
//  Created by Tom Xing on 9/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface UserSetting : UITableViewController
@property(nonatomic, strong) User * currentUser;
@end

NS_ASSUME_NONNULL_END
