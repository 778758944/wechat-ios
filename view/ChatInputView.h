//
//  ChatInputView.h
//  WeChat
//
//  Created by Tom Xing on 8/29/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleBtn.h"
@class RecordBtn;

@interface ChatInputView : UIView
@property(nonatomic, strong) UITextView * textField;
@property(nonatomic, strong) CircleBtn * inputModeBtn;
@property(nonatomic, strong) CircleBtn * emojiBtn;
@property(nonatomic, strong) CircleBtn * moreBtn;
@property(nonatomic, strong, readonly) NSLayoutConstraint * heightForTextField;
@property(nonatomic, strong, readonly) UICollectionView * moreContainer;
@property(nonatomic, strong, readonly) UIPageControl * pageControl;
@property(nonatomic, strong, readonly) NSLayoutConstraint * moreContainerViewHeight;
@property(nonatomic, assign, getter=isShowMore) BOOL showMore;
@property(nonatomic, strong, readonly) RecordBtn * recordBtn;
@end
