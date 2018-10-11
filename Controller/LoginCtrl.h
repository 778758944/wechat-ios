//
//  LoginCtrl.h
//  WeChat
//
//  Created by Tom Xing on 8/20/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginDelegate.h"
#import "UIViewController+Alert.h"

@interface LoginCtrl : UIViewController
@property(nonatomic, strong) id <LoginDelegate> loginDelegate;
@property(nonatomic, strong) NSManagedObjectContext * ctx;
@end
