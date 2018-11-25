//
//  DrawView.h
//  WeChat
//
//  Created by Tom Xing on 10/11/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawView : UIView
@property(nonatomic, strong) UIButton * clearBtn;
@property(nonatomic, strong) UIButton * closeBtn;
@property(nonatomic, strong) NSMutableArray * pointArr;

@end

NS_ASSUME_NONNULL_END
