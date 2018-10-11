//
//  MoreBtnView.m
//  WeChat
//
//  Created by Tom Xing on 8/31/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "MoreBtnView.h"
#import "UIColor+transform.h"

@interface MoreBtnView()
@property(nonatomic, strong, readwrite) UIImageView * imageView;
@property(nonatomic, strong, readwrite) UILabel * textLabel;
@property(nonatomic, strong) UIView * view;
@end


@implementation MoreBtnView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor transformColorFormHex:@"DCDCDD"].CGColor;
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 10;
        self.view = view;
        
        
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        
        
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.textColor = [UIColor transformColorFormHex:@"8f8f8f"];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        
        
        
        [view addSubview:self.imageView];
        [self.contentView addSubview:view];
        [self.contentView addSubview:self.textLabel];
        [self.textLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        [self.textLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    }
    return self;
}

-(void) setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.view.backgroundColor = [UIColor transformColorFormHex:@"dcdcdd"];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}



















@end
