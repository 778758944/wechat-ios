//
//  LoginView.h
//  WeChat
//
//  Created by Tom Xing on 8/21/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"
#import "ButtonView.h"

@interface LoginView : UIView
@property(nonatomic, strong) InputView * password;
@property(nonatomic, strong) InputView * username;
@property(nonatomic, strong) ButtonView * loginBtn;
@property(nonatomic, strong) ButtonView * switchLoginModeBtn;
@property(nonatomic, strong) UIButton * closeBtn;
@property(nonatomic, strong) UIScrollView * loginViewContainer;
@property(nonatomic, strong) InputView * regionNumber;
@property(nonatomic, strong) InputView * phoneNumber;
@property(nonatomic) BOOL isMailActive;
@end
