//
//  FriendListCellView.m
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "FriendListCellView.h"
#import "UIColor+transform.h"

@implementation FriendListCellView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.avator = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        self.avator.contentMode =  UIViewContentModeScaleAspectFill;
        self.avator.layer.cornerRadius = 3;
        self.avator.layer.masksToBounds = YES;
        
        self.unreadMsg = [[UILabel alloc] initWithFrame:CGRectMake(45, 2, 19, 19)];
        self.unreadMsg.layer.cornerRadius = 10;
        self.unreadMsg.backgroundColor = [UIColor transformColorFormHex:@"f43530"];
        self.unreadMsg.layer.masksToBounds = YES;
//        self.unreadMsg.text = @"9+";
        self.unreadMsg.hidden = YES;
        self.unreadMsg.textColor = [UIColor whiteColor];
        self.unreadMsg.textAlignment = NSTextAlignmentCenter;
        self.unreadMsg.font = [UIFont systemFontOfSize:13];
        
        
        self.username = [[UILabel alloc] init];
        self.username.translatesAutoresizingMaskIntoConstraints = NO;
        self.username.textColor = [UIColor blackColor];
        self.username.font = [UIFont systemFontOfSize:18];
        
        self.time = [[UILabel alloc] init];
        self.time.translatesAutoresizingMaskIntoConstraints = NO;
        self.time.textColor = [UIColor transformColorFormHex:@"9b9b9b"];
        self.time.font = [UIFont systemFontOfSize:12];
        
        self.lastMsg = [[UILabel alloc] init];
        self.lastMsg.translatesAutoresizingMaskIntoConstraints = NO;
        self.lastMsg.textColor = [UIColor transformColorFormHex:@"9b9b9b"];
        
        [self.contentView addSubview:self.avator];
        [self.contentView addSubview:self.username];
        [self.contentView addSubview:self.lastMsg];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.unreadMsg];
        
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        [self customStyle];
    }
    return self;
}

-(void) customStyle
{
    [self.username.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:67].active = YES;
    [self.username.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:11].active = YES;
    [self.time.centerYAnchor constraintEqualToAnchor:self.username.centerYAnchor].active = YES;
    [self.time.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10].active = YES;
    [self.lastMsg.leadingAnchor constraintEqualToAnchor:self.username.leadingAnchor].active = YES;
    [self.lastMsg.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10].active = YES;
    [self.lastMsg.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-11].active = YES;
    [self.username.trailingAnchor constraintEqualToAnchor:self.time.leadingAnchor constant:-5].active = YES;
    [self.username setContentHuggingPriority:1 forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.username setContentCompressionResistancePriority:1 forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView.heightAnchor constraintEqualToConstant:65].active = YES;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor transformColorFormHex:@"d9d9d9"];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
