//
//  ChatView.h
//  WeChat
//
//  Created by Tom Xing on 8/29/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInputView.h"
@class MoreContainer;
@class VoiceRecordNotice;

@interface ChatView : UIView
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) ChatInputView * inputView;
@property(nonatomic, strong, readonly) NSLayoutConstraint * bottomForInputView;
@property(nonatomic, strong, readonly) MoreContainer * moreContainer;
@property(nonatomic, strong, readonly) UIView * dynamicView;
@property(nonatomic, strong, readonly) NSLayoutConstraint * topForDynamicView;
@property(nonatomic, getter=isShowDynamicView) BOOL showDynamicView;
@property(nonatomic, getter=isSoundMode) BOOL soundMode;
@property(nonatomic, strong, readonly) VoiceRecordNotice * recordNotice;
@end
