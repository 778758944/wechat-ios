//
//  ButtonCell.m
//  WeChat
//
//  Created by Tom Xing on 9/25/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.buttonName = [[UILabel alloc] init];
        _buttonName.translatesAutoresizingMaskIntoConstraints = NO;
        _buttonName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_buttonName];
        [_buttonName.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
        [_buttonName.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor].active = YES;
        [_buttonName.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        [_buttonName.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
