//
//  ChatView.m
//  WeChat
//
//  Created by Tom Xing on 8/29/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "ChatView.h"
#import "ChatInputView.h"
#import "MoreContainer.h"
#import "UIColor+transform.h"
#import "RecordBtn.h"
#import "VoiceRecordNotice.h"

@interface ChatView()
@property(nonatomic, strong, readwrite) NSLayoutConstraint * bottomForInputView;
@property(nonatomic, strong, readwrite) MoreContainer * moreContainer;
@property(nonatomic, strong, readwrite) UIView * dynamicView;
@property(nonatomic, strong, readwrite) NSLayoutConstraint * topForDynamicView;
@property(nonatomic, strong, readwrite) VoiceRecordNotice * recordNotice;
@end

@implementation ChatView

-(id) init
{
    self = [super init];
    if (self) {
        self.soundMode = NO;
        self.showDynamicView = NO;
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor transformColorFormHex:@"ebebeb"];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(msgListTap)];
//        [_tableView addGestureRecognizer:tap];
        
        UIScreenEdgePanGestureRecognizer * edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(disableEdgePan)];
        edgePan.edges = UIRectEdgeLeft;
        
        
        _inputView = [[ChatInputView alloc] init];
//        [_inputView.inputModeBtn addTarget:self action:@selector(changeInputMode:) forControlEvents:(UIControlEventTouchDown)];
        
//        [_inputView.moreBtn addTarget:self action:@selector(toggleView) forControlEvents:(UIControlEventTouchDown)];
        
        self.moreContainer = [[MoreContainer alloc] init];
        _moreContainer.frame = CGRectMake(0, 0, _moreContainer.itemContiner.frame.size.width, 230);
        
        self.dynamicView = [[UIView alloc] init];
        _dynamicView.translatesAutoresizingMaskIntoConstraints = NO;
        _dynamicView.backgroundColor = [UIColor transformColorFormHex:@"f5f5f6"];
        
        [self.dynamicView addGestureRecognizer:edgePan];
        
        [_dynamicView addSubview:_moreContainer];
        
        self.recordNotice = [[VoiceRecordNotice alloc] init];
        self.recordNotice.hidden = YES;
        
        
        
        [self addSubview:_tableView];
        [self addSubview:_inputView];
        [self addSubview:_dynamicView];
        [self addSubview:_recordNotice];
        self.backgroundColor = [UIColor whiteColor];
        [self customStyle];
    }
    return self;
}

-(void) customStyle
{
    [_tableView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
    [_tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
//    [_inputView.heightAnchor constraintEqualToConstant:50].active = YES;
    self.bottomForInputView = [_inputView.bottomAnchor constraintEqualToAnchor:_dynamicView.topAnchor constant:0];
    _bottomForInputView.active = YES;
    [_inputView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_inputView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_tableView.bottomAnchor constraintEqualToAnchor:_inputView.topAnchor].active = YES;
    
    self.topForDynamicView = [_dynamicView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:0];
    self.topForDynamicView.active = YES;
    [_dynamicView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_dynamicView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [_dynamicView.heightAnchor constraintEqualToConstant:230].active = YES;
    NSDictionary * dict = @{
                            @"recordNotice": _recordNotice
                            };
    
    NSArray<NSLayoutConstraint *> * h_con = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[recordNotice]|" options:0 metrics:nil views:dict];
                                             
    NSArray<NSLayoutConstraint *> * v_con = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[recordNotice]|" options:0 metrics:nil views:dict];
    
    [self addConstraints:h_con];
    [self addConstraints:v_con];
}

-(void) toggleView
{
    if (self.isSoundMode) [self changeInputMode: self.inputView.inputModeBtn];
    if (self.isShowDynamicView) {
        if ([_inputView.textField isFirstResponder]) {
            [_inputView.textField resignFirstResponder];
        } else {
            [_inputView.textField becomeFirstResponder];
        }
    } else {
        self.showDynamicView = YES;
        if ([self.inputView.textField isFirstResponder]) {
            [self.inputView.textField resignFirstResponder];
        } else {
            self.topForDynamicView.constant = -230;
            [UIView setAnimationCurve:7];
            [UIView animateWithDuration:0.25 animations:^{
                [self layoutIfNeeded];
            }];
        }
    }
}


-(void) msgListTap
{
    NSLog(@"tap");
    
    if (self.isShowDynamicView) {
        self.showDynamicView = NO;
        if ([self.inputView.textField isFirstResponder]) {
            [self.inputView.textField resignFirstResponder];
        } else {
            self.topForDynamicView.constant = 0;
            [UIView setAnimationCurve:7];
            [UIView animateWithDuration:0.25 animations:^{
                [self layoutIfNeeded];
            }];
        }
    }
    
    if ([self.inputView.textField isFirstResponder]) {
        [self.inputView.textField resignFirstResponder];
    }
}


-(void) changeInputMode: (UIButton *) btn
{
    if (self.isSoundMode) {
        self.inputView.textField.hidden = NO;
        self.inputView.recordBtn.hidden = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"voice.png"] forState:(UIControlStateNormal)];
        CGSize size = self.inputView.textField.contentSize;
        self.inputView.heightForTextField.constant = size.height;
        [self.inputView.textField becomeFirstResponder];
    } else {
        self.inputView.recordBtn.hidden = NO;
        self.inputView.textField.hidden = YES;
        self.inputView.heightForTextField.constant = 36;
        [btn setBackgroundImage:[UIImage imageNamed:@"keyboard.png"] forState:(UIControlStateNormal)];
        [self msgListTap];
    }
    self.soundMode = !self.soundMode;
}

-(void) disableEdgePan
{
    NSLog(@"edgePan");
}


-(void) dealloc
{
    NSLog(@"dedede");
}

-(void) layoutSubviews
{
    NSLog(@"safe area: %@", [NSValue valueWithUIEdgeInsets: self.safeAreaInsets]);
    UIEdgeInsets inset = self.safeAreaInsets;
//    self.bottomForInputView.constant = -inset.bottom;
//    self.topForDynamicView.constant = inset.bottom;
}






























@end
