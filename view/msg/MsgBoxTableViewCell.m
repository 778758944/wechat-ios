//
//  MsgBoxTableViewCell.m
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "MsgBoxTableViewCell.h"
#import "MineContainer.h"
#import "OtherContainer.h"
#import "Message.h"

@interface MsgBoxTableViewCell()
@end

@implementation MsgBoxTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithMessage:(Message *) msg reuseIdentifier:(NSString *)reuseIdentifier MineAvator: (UIImage *) mineAvator OtherAvator: (UIImage *) otherAvator
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (msg.type.integerValue == 1) {
            self.msgContainer = [[MineContainer alloc] initWithMsg:msg];
            MineContainer * mineContainer = (MineContainer *) self.msgContainer;
            mineContainer.avator.image = mineAvator;
            [self.contentView addSubview:_msgContainer];
            [_msgContainer.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:39].active = YES;
            [_msgContainer.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10].active = YES;
        } else {
            self.msgContainer = [[OtherContainer alloc] initWithMsg:msg];
            OtherContainer * otherContainer = (OtherContainer *) self.msgContainer;
            otherContainer.avator.image = otherAvator;
            [self.contentView addSubview:_msgContainer];
            [_msgContainer.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10].active = YES;
            [_msgContainer.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-39].active = YES;
        }
    }
    [self customStyle];
    
    return self;
}

-(void) customStyle
{
    
    [_msgContainer.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [_msgContainer.heightAnchor constraintGreaterThanOrEqualToConstant:40].active = YES;
    
    [self.contentView.bottomAnchor constraintEqualToAnchor:_msgContainer.bottomAnchor constant: 10].active = YES;
}


@end
