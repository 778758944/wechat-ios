//
//  InputView.h
//  WeChat
//
//  Created by Tom Xing on 8/20/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView

@property(nonatomic, strong) UITextField * textField;
@property(nonatomic, strong) UILabel * nameLabel;
@property(nonatomic, strong) NSString * labelText;
@property(nonatomic, strong) NSString * placeholder;

-(instancetype) initWithName: (NSString *) labelName placeholder: (NSString *) placeholder;

@end
