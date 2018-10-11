//
//  LoginView.m
//  WeChat
//
//  Created by Tom Xing on 8/21/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "LoginView.h"

@interface LoginView() <UITextFieldDelegate>
@property(nonatomic, strong) UIView * phoneLoginView;
@property(nonatomic, strong) UIView * mailLoginView;
@property(nonatomic, strong) UILabel * loginTitle;
@property(nonatomic, strong) UILabel * phoneLoginTitle;
@property(nonatomic, strong) UIView * topBar;
@property(nonatomic, strong) NSLayoutConstraint * mailLeading;
@property(nonatomic, strong) NSLayoutConstraint * topBarTop;
@end

@implementation LoginView

-(instancetype) init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.isMailActive = YES;
        self.loginViewContainer = [[UIScrollView alloc] init];
        self.loginViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
        self.loginViewContainer.alwaysBounceVertical = YES;
        // self.loginViewContainer.backgroundColor = [UIColor redColor];
        self.loginViewContainer.showsVerticalScrollIndicator = NO;
        // self.loginViewContainer.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.username = [[InputView alloc] initWithName:@"Account" placeholder:@"Enter Username"];
        self.password = [[InputView alloc] initWithName:@"Password" placeholder:@"Enter Password"];
        
        self.username.textField.delegate = self;
        self.password.textField.delegate = self;
        
        self.loginTitle = [[UILabel alloc] init];
        self.loginTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.loginTitle.text = @"Log in via WeChat ID/Email/QQ ID";
        self.loginTitle.font = [UIFont boldSystemFontOfSize:25];
        self.loginTitle.numberOfLines = 2;
        
        self.loginBtn = [[ButtonView alloc] initWithTitle:@"Login" isActive:NO style: WCNormal];
        
        self.switchLoginModeBtn = [[ButtonView alloc] initWithTitle:@"Login via Phone" isActive:YES style:WCLink];
        [self.switchLoginModeBtn addTarget:self action:@selector(changeLoginMode) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.mailLoginView = [[UIView alloc] init];
        
        self.mailLoginView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.topBar = [[UIView alloc] init];
        self.topBar.backgroundColor = [UIColor whiteColor];
        self.topBar.alpha = 0.8;
        self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:(UIControlStateNormal)];
        self.closeBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        //phone login view
        self.regionNumber = [[InputView alloc] initWithName:@"Regin" placeholder:@"Enter Regin Number"];
        
        self.phoneNumber = [[InputView alloc] initWithName:@"Phone" placeholder:@"Enter Phone Number"];
        
        self.phoneLoginTitle = [[UILabel alloc] init];
        self.phoneLoginTitle.text = @"Login via Phone";
        self.phoneLoginTitle.font = [UIFont boldSystemFontOfSize:25];
        self.phoneLoginTitle.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.phoneLoginView = [[UIView alloc] init];
        self.phoneLoginView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        
        
        
        [self.mailLoginView addSubview:self.loginTitle];
        [self.mailLoginView addSubview:self.username];
        [self.mailLoginView addSubview:self.password];
        
        [self.phoneLoginView addSubview:self.phoneLoginTitle];
        [self.phoneLoginView addSubview:self.regionNumber];
        [self.phoneLoginView addSubview:self.phoneNumber];
        
        
        [self.loginViewContainer addSubview:self.phoneLoginView];
        [self.loginViewContainer addSubview:self.mailLoginView];
        [self.loginViewContainer addSubview:self.switchLoginModeBtn];
        [self.loginViewContainer addSubview:self.loginBtn];
        [self addSubview:self.loginViewContainer];
        [self addSubview:self.topBar];
        [self addSubview:self.closeBtn];
        
        [self customStyle];
    }
    return self;
}

-(void) customStyle
{
    //layout start
    UIEdgeInsets insets = self.safeAreaInsets;
    NSLog(@"insets %@", [NSValue valueWithUIEdgeInsets:insets]);
     
    /* loginViewContainer constraint */
    [self.loginViewContainer.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.loginViewContainer.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.loginViewContainer.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.loginViewContainer.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    
    // mailLogin constraint
    [self.mailLoginView.topAnchor constraintEqualToAnchor:self.loginViewContainer.topAnchor constant:104].active = YES;
    [self.mailLoginView.widthAnchor constraintEqualToAnchor:self.loginViewContainer.widthAnchor].active = YES;
    [self.mailLoginView.heightAnchor constraintEqualToConstant:180].active = YES;
    self.mailLeading = [self.mailLoginView.leadingAnchor constraintEqualToAnchor:self.loginViewContainer.leadingAnchor constant:0];
    self.mailLeading.active = YES;
    
    // input constraint
    [self.username.leadingAnchor constraintEqualToAnchor:self.mailLoginView.leadingAnchor constant:21].active = YES;
    [self.username.trailingAnchor constraintEqualToAnchor:self.mailLoginView.trailingAnchor constant:-21].active = YES;
    [self.username.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.password.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.password.leadingAnchor constraintEqualToAnchor:self.username.leadingAnchor].active = YES;
    [self.password.trailingAnchor constraintEqualToAnchor:self.username.trailingAnchor].active = YES;
    [self.password.topAnchor constraintEqualToAnchor:self.username.bottomAnchor constant: 0].active = YES;
    
    [self.password.bottomAnchor constraintEqualToAnchor:self.mailLoginView.bottomAnchor].active = YES;
    
    [self.password.textField setSecureTextEntry:YES];
    
    [self.password.nameLabel.widthAnchor constraintEqualToAnchor: self.username.nameLabel.widthAnchor].active = YES;
    
    
    // title constraint
    [self.loginTitle.leadingAnchor constraintEqualToAnchor:self.username.leadingAnchor].active = YES;
    [self.loginTitle.trailingAnchor constraintEqualToAnchor:self.username.trailingAnchor].active = YES;
    
    [self.loginTitle.topAnchor constraintEqualToAnchor:self.mailLoginView.topAnchor].active = YES;
    [self.loginTitle.leftAnchor constraintEqualToAnchor:self.username.leftAnchor].active = YES;
    
    // loginBtn
    [self.loginBtn.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:21].active = YES;
    [self.loginBtn.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-21].active = YES;
    [self.loginBtn.heightAnchor constraintEqualToConstant: 48].active = YES;
    [self.loginBtn.topAnchor constraintEqualToAnchor:self.switchLoginModeBtn.bottomAnchor constant:39].active = YES;
    
    //switchLoginModeBtn
    [self.switchLoginModeBtn.leadingAnchor constraintEqualToAnchor:self.loginViewContainer.leadingAnchor constant:21].active = YES;
    [self.switchLoginModeBtn.topAnchor constraintEqualToAnchor:self.loginViewContainer.topAnchor constant:300].active = YES;
    
    //topBar
    [self.topBar.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.topBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.topBar.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    self.topBarTop = [self.topBar.heightAnchor constraintEqualToConstant:60];
    self.topBarTop.active = YES;
    
    // closeBtn
    
    [self.closeBtn.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:30].active = YES;
    [self.closeBtn.leadingAnchor constraintEqualToAnchor:self.topBar.leadingAnchor constant:21].active = YES;
    [self.closeBtn.widthAnchor constraintEqualToConstant:20].active = YES;
    [self.closeBtn.heightAnchor constraintEqualToConstant:20].active = YES;
    
    //phone login view
    [self.phoneLoginView.topAnchor constraintEqualToAnchor:self.loginViewContainer.topAnchor constant:104].active = YES;
    [self.phoneLoginView.widthAnchor constraintEqualToAnchor:self.loginViewContainer.widthAnchor].active = YES;
    [self.phoneLoginView.heightAnchor constraintEqualToAnchor:self.mailLoginView.heightAnchor].active = YES;
    [self.phoneLoginView.leadingAnchor constraintEqualToAnchor:self.mailLoginView.trailingAnchor].active = YES;
    
    // regionNumber
    [self.regionNumber.leadingAnchor constraintEqualToAnchor:self.phoneLoginView.leadingAnchor constant:21].active = YES;
    [self.regionNumber.trailingAnchor constraintEqualToAnchor:self.phoneLoginView.trailingAnchor constant:-21].active = YES;
    [self.phoneNumber.leadingAnchor constraintEqualToAnchor:self.regionNumber.leadingAnchor].active = YES;
    [self.phoneNumber.trailingAnchor constraintEqualToAnchor:self.regionNumber.trailingAnchor].active = YES;
    [self.phoneNumber.bottomAnchor constraintEqualToAnchor:self.phoneLoginView.bottomAnchor].active = YES;
    [self.regionNumber.bottomAnchor constraintEqualToAnchor:self.phoneNumber.topAnchor].active = YES;
    [self.regionNumber.heightAnchor constraintEqualToConstant:44].active = YES;
    [self.phoneNumber.heightAnchor constraintEqualToConstant:44].active = YES;
    [self.regionNumber.nameLabel.widthAnchor constraintEqualToAnchor:self.phoneNumber.nameLabel.widthAnchor].active = YES;
    
    // phone login title
    [self.phoneLoginTitle.topAnchor constraintEqualToAnchor:self.phoneLoginView.topAnchor].active = YES;
    [self.phoneLoginTitle.leadingAnchor constraintEqualToAnchor:self.regionNumber.leadingAnchor].active = YES;
    
    
    
    
    
}

-(void) layoutSubviews
{
   //
}

#pragma debug ui
-(void) testui: (id) sender
{
    NSLog(@"test ui");
    [self.closeBtn exerciseAmbiguityInLayout];
}

#pragma textField delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) changeLoginMode
{
    NSLog(@"change login mode");
    CGFloat screenWidth = self.frame.size.width;
    NSString * btnText;
    NSLog(@"screenWidth = %.2f", screenWidth);
    if (self.isMailActive) {
        self.mailLeading.constant = -(screenWidth);
//        self.phoneLeading.constant = -(screenWidth);
        [UIView animateWithDuration:0.3 animations:^{
            [self.loginViewContainer layoutIfNeeded];
        }];
        btnText = @"Login Via Email";
    } else {
        self.mailLeading.constant = 0;
//        self.phoneLeading.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self.loginViewContainer layoutIfNeeded];
        }];
        btnText = @"Login Via Phone";
    }
    
    self.isMailActive = !self.isMailActive;
    [self.switchLoginModeBtn setTitle:btnText forState:UIControlStateNormal];
}

-(void) safeAreaInsetsDidChange
{
    self.topBarTop.constant = 60 + self.safeAreaInsets.top;
}






























@end
