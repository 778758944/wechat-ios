//
//  FriendListPopCtrl.m
//  WeChat
//
//  Created by Tom Xing on 8/26/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "FriendListPopCtrl.h"
#import "PopImageBtn.h"
#import <AudioToolbox/AudioToolbox.h>

@interface FriendListPopCtrl ()
@property(nonatomic, strong) PopImageBtn * createChat;
@property(nonatomic, strong) PopImageBtn * addContact;
@property(nonatomic, strong) PopImageBtn * scanBtn;
@property(nonatomic, strong) PopImageBtn * moneyBtn;
@property(nonatomic, strong) UIStackView * stackView;
@end

@implementation FriendListPopCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _createChat = [PopImageBtn buttonWithTitle:@"New Chat" Image:@"close"];
    _addContact = [PopImageBtn buttonWithTitle:@"Add Contacts" Image:@"close"];
    _scanBtn = [PopImageBtn buttonWithTitle:@"Scan" Image:@"close"];
    _moneyBtn = [PopImageBtn buttonWithTitle:@"Money" Image:@"close"];
    
    _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_createChat, _addContact, _scanBtn, _moneyBtn]];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.alignment = UIStackViewAlignmentFill;
    _stackView.distribution = UIStackViewDistributionFillEqually;
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_stackView];
    self.view.backgroundColor = [UIColor blackColor];
    [self customStyle];
    
}

-(void) customStyle
{
    [_stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [_stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
