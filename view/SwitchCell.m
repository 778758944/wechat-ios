//
//  SwitchCell.m
//  WeChat
//
//  Created by Tom Xing on 9/25/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10].active = YES;
        [_nameLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        
        self.switchView = [[UISwitch alloc] init];
        _switchView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_switchView];
        
        [_switchView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15].active = YES;
        [_switchView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
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
