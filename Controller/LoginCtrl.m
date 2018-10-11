//
//  LoginCtrl.m
//  WeChat
//
//  Created by Tom Xing on 8/20/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "LoginCtrl.h"
#import "LoginView.h"
#import "ButtonView.h"
#import "NetWork.h"
#import "FriendListCtrl.h"
#import "WCLoading.h"
#import "NetWorkDelegate.h"
#import "User+addon.h"

@interface LoginCtrl ()<NetWorkDelegate>
@property(nonatomic, weak) InputView * username;
@property(nonatomic, weak) InputView * password;
@property(nonatomic, weak) UIButton * closeBtn;
@property(nonatomic, weak) ButtonView * loginBtn;
@property(nonatomic, weak) UIScrollView * loginViewContainer;
@end

@implementation LoginCtrl

-(void) loadView
{
    self.view = [[LoginView alloc] init];
}


-(void) viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    NSLog(@"insets %@", [NSValue valueWithUIEdgeInsets:insets]);
    if ([self.view isKindOfClass:[LoginView class]]) {
        LoginView * vc = (LoginView *) self.view;
        self.closeBtn = vc.closeBtn;
        self.password = vc.password;
        self.username = vc.username;
        self.loginBtn = vc.loginBtn;
        self.loginViewContainer = vc.loginViewContainer;
        
        [self.closeBtn addTarget:self action:@selector(closeLogin) forControlEvents:(UIControlEventTouchDown)];
        [self.loginBtn addTarget:self action:@selector(login:) forControlEvents:(UIControlEventTouchDown)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginBtnStatus:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContentSize:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContentSize:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void) closeLogin
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) login:(id) sender
{
    NSString * username = self.username.textField.text;
    NSString * password = self.password.textField.text;
    
    NSLog(@"username: %@ password: %@", username, password);
    
    NSDictionary * loginData = @{
        @"email": username,
        @"password": password
    };
    
    [WCLoading show];
    
    NetWork * net = [[NetWork alloc] init];
    net.delegate = self;
    [net postWithUrl:@"/yonghus/login" Data:loginData completion:^(NSError *err, NSDictionary *response) {
        NSLog(@"response: %@", response);
        dispatch_async(dispatch_get_main_queue(), ^{
            [WCLoading hide];
            if (!err) {
                [[NSUserDefaults standardUserDefaults] setInteger:[response[@"userId"] integerValue] forKey:WC_CURRENT_USER];
                [User addUser:response inContext:self.ctx];
                [self.loginDelegate CallbackForLogin];
                [self closeLogin];
            } else {
                if ([err.domain isEqualToString:NSUserNetWorkCustomDomain]) {
                    [self alertWithTitle:@"Error" Message:err.localizedDescription];
                }
            }
        });
    }];
    
}

-(void) updateLoginBtnStatus: (NSNotification *) notification
{
    NSLog(@"change");
    NSString * username = self.username.textField.text;
    NSString * password = self.password.textField.text;
    
    if ([username length] && [password length]) {
        [self.loginBtn activeBtn];
    } else {
        [self.loginBtn disableBtn];
    }
}

-(void) updateContentSize: (NSNotification *) notification
{
    
    NSValue * keyboardFrame = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    CGRect rect = keyboardFrame.CGRectValue;
    CGSize contentSize = self.loginViewContainer.contentSize;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
       self.loginViewContainer.contentSize = CGSizeMake(contentSize.width, contentSize.height + rect.size.height);
    } else {
       self.loginViewContainer.contentSize = CGSizeMake(contentSize.width, contentSize.height - rect.size.height);
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    NSLog(@"insets %@", [NSValue valueWithUIEdgeInsets:insets]);
}


@end
