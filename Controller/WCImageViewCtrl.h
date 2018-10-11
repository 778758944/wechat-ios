//
//  WCImageViewCtrl.h
//  WeChat
//
//  Created by Tom Xing on 9/27/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoEditDelegate.h"
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface WCImageViewCtrl : UIViewController
@property(nonatomic, strong) UIImage * image;
@property(nonatomic, weak) id<UserInfoEditDelegate> delegate;
@property(nonatomic, strong) User * currentUser;
@end

NS_ASSUME_NONNULL_END
