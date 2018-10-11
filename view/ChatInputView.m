//
//  ChatInputView.m
//  WeChat
//
//  Created by Tom Xing on 8/29/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "ChatInputView.h"
#import "CircleBtn.h"
#import "UIColor+transform.h"
#import "MoreContainerLayout.h"
#import "TopLineView.h"
#import "RecordBtn.h"

@interface ChatInputView()
@property(nonatomic, strong, readwrite) NSLayoutConstraint * heightForTextField;
@property(nonatomic, strong) TopLineView * mainContainer;
@property(nonatomic, strong, readwrite) RecordBtn * recordBtn;
@property(nonatomic, getter=isSoundMode) BOOL soundMode;
@end

@implementation ChatInputView

-(id) init
{
    self = [super init];
    if (self) {
        self.soundMode = NO;
        self.showMore = NO;
        _mainContainer = [[TopLineView alloc] init];
        _mainContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        _textField = [[UITextView alloc] init];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.layer.borderColor = [UIColor transformColorFormHex:@"dddddd"].CGColor;
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 5;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.returnKeyType = UIReturnKeySend;
        _textField.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0);
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 1.0;
        _textField.hidden = NO;
        
//        paragraphStyle.lineSpacing = 10;
        //NSMutableAttributedString * textAttr = _textField.textStorage;
//        [textAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 0)];
        /*
        NSAttributedString * attr = [[NSAttributedString alloc] initWithString:@"test" attributes:@{
                                                                                                    NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                                    NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                    NSForegroundColorAttributeName: [UIColor redColor]
                                                                                            
                                                                                                    }];
        [textAttr setAttributedString:attr];
         */
        
        /*record btn*/
        self.recordBtn = [RecordBtn buttonWithType:(UIButtonTypeCustom)];
        self.recordBtn.translatesAutoresizingMaskIntoConstraints = NO;
        self.recordBtn.layer.borderColor = [UIColor transformColorFormHex:@"dddddd"].CGColor;
        self.recordBtn.layer.borderWidth = 0.5;
        self.recordBtn.layer.cornerRadius = 5;
        self.recordBtn.layer.masksToBounds = YES;
        self.recordBtn.backgroundColor = [UIColor whiteColor];
        [self.recordBtn setTitleColor:[UIColor transformColorFormHex:@"565656"] forState:(UIControlStateNormal)];
        NSAttributedString * recordTitle = [[NSAttributedString alloc] initWithString:@"Hold to Talk" attributes:@{
                                                                                                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                                                                                                
                                                                                NSForegroundColorAttributeName: [UIColor transformColorFormHex:@"565656"],
                                                                                                            }];
        
        NSAttributedString * recordSendTitle = [[NSAttributedString alloc] initWithString:@"Release to Send" attributes:@{
                                                                                                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                                                                                                   
                                                                                                                   NSForegroundColorAttributeName: [UIColor transformColorFormHex:@"565656"],
                                                                                                                   }];
        [self.recordBtn setAttributedTitle:recordTitle forState:(UIControlStateNormal)];
        [self.recordBtn setAttributedTitle:recordSendTitle forState:(UIControlStateHighlighted)];
        self.recordBtn.hidden = YES;
        
        
        
        _inputModeBtn = [CircleBtn buttonWithImage:[UIImage imageNamed:@"voice.png"]];
        _emojiBtn = [CircleBtn buttonWithImage:[UIImage imageNamed:@"emoji.png"]];
        _moreBtn = [CircleBtn buttonWithImage:[UIImage imageNamed:@"add.png"]];
        
        
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor transformColorFormHex:@"f5f5f6"];
        [self.mainContainer addSubview:_inputModeBtn];
        [self.mainContainer addSubview:_textField];
        [self.mainContainer addSubview:_recordBtn];
        [self.mainContainer addSubview:_emojiBtn];
        [self.mainContainer addSubview:_moreBtn];
        [self addSubview:_mainContainer];
        [self customStyle];
    }
    return self;
}

-(void) customStyle
{
    [_mainContainer.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_mainContainer.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_mainContainer.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_mainContainer.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    [_inputModeBtn.leadingAnchor constraintEqualToAnchor:self.mainContainer.leadingAnchor constant:10].active = YES;
    [_inputModeBtn.bottomAnchor constraintEqualToAnchor:self.mainContainer.bottomAnchor constant:-10].active = YES;
    
    [_textField.leadingAnchor constraintEqualToAnchor:_inputModeBtn.trailingAnchor constant:10].active = YES;
    _heightForTextField = [_textField.heightAnchor constraintEqualToConstant:36];
    _heightForTextField.active = YES;
    [_textField.topAnchor constraintEqualToAnchor:self.mainContainer.topAnchor constant:7].active = YES;
    [_textField.bottomAnchor constraintEqualToAnchor:self.mainContainer.bottomAnchor constant:-7].active = YES;
    [_textField.centerYAnchor constraintEqualToAnchor:self.mainContainer.centerYAnchor].active = YES;
    
    [_recordBtn.leadingAnchor constraintEqualToAnchor:_inputModeBtn.trailingAnchor constant:10].active = YES;
    [_recordBtn.heightAnchor constraintEqualToConstant: 36].active = YES;
    [_recordBtn.topAnchor constraintEqualToAnchor:self.mainContainer.topAnchor constant:7].active = YES;
    
    
    
    
    
    [_emojiBtn.leadingAnchor constraintEqualToAnchor:_textField.trailingAnchor constant:10].active = YES;
    [_emojiBtn.leadingAnchor constraintEqualToAnchor:_recordBtn.trailingAnchor constant:10].active = YES;
    [_emojiBtn.bottomAnchor constraintEqualToAnchor:self.mainContainer.bottomAnchor constant:-10].active = YES;
    
    [_moreBtn.leadingAnchor constraintEqualToAnchor:_emojiBtn.trailingAnchor constant:10].active = YES;
    [_moreBtn.bottomAnchor constraintEqualToAnchor:self.mainContainer.bottomAnchor constant:-10].active = YES;
    [_moreBtn.trailingAnchor constraintEqualToAnchor:self.mainContainer.trailingAnchor constant:-10].active = YES;
}











@end
