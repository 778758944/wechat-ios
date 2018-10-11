//
//  UserSettingCell.m
//  WeChat
//
//  Created by Tom Xing on 9/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "UserSettingCell.h"
#import "UIColor+transform.h"

@implementation UserSettingCell {
    UILabel * contentLabel;
    UIImageView * imageView;
}

-(void) setContent:(id)content
{
    if ([content isKindOfClass:[NSString class]]) {
        if (!contentLabel) {
            contentLabel = [[UILabel alloc] init];
            contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
            contentLabel.textColor = [UIColor transformColorFormHex:@"888888"];
            [self.contentView addSubview:contentLabel];
            [contentLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
            [contentLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        }
        contentLabel.text = content;
    } else if ([content isKindOfClass:[UIImage class]]) {
        if (!imageView) {
            imageView = [[UIImageView alloc] init];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:imageView];
            [imageView.widthAnchor constraintEqualToConstant:65].active = YES;
            [imageView.heightAnchor constraintEqualToConstant:65].active = YES;
            [imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
            [imageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        }
        imageView.image = content;
    }
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftTextLabel = [[UILabel alloc] init];
        _leftTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_leftTextLabel];
        
        [_leftTextLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15].active = YES;
        [_leftTextLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    }
    
    return self;
}
@end
