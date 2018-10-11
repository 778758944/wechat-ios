//
//  InputController.h
//  WeChat
//
//  Created by Tom Xing on 9/24/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoEditDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputController : UIViewController
@property(nonatomic, strong) NSString * content;
@property(nonatomic, strong) NSString * navTitle;
@property(nonatomic, weak) id <UserInfoEditDelegate> delegate;

-(instancetype) initWithContent: (NSString *) content Title: (NSString *) title;
@end

NS_ASSUME_NONNULL_END
