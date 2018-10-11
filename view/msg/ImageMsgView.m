//
//  ImageMsgView.m
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "ImageMsgView.h"
#import "Message.h"
#import "UIColor+transform.h"

@interface ImageMsgView()
@property(nonatomic, strong) Message * msg;
@end

@implementation ImageMsgView

-(instancetype) initWithMsg: (Message *) msg
{
    self = [super init];
    if (self) {
        self.msg = msg;
        /*
        CGFloat imgWidth, imgHeight;
        CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat maxWidth = screenWidth * (270.0/640);
        CGFloat minWidth = screenWidth * (114.0/640);
        UIImage * image = [UIImage imageWithData:msg.data];
        CGSize size = image.size;
        if (size.width > size.height) {
            imgWidth = maxWidth;
            imgHeight = size.height * (maxWidth/size.width);
            imgHeight = imgHeight < minWidth ? minWidth : imgHeight;
        } else {
            imgHeight = maxWidth;
            imgWidth = size.width * (maxWidth/size.height);
            imgWidth = imgWidth < minWidth ? minWidth : imgWidth;
        }
        
        self.frame = CGRectMake(50, 5, imgWidth, imgHeight);
        */
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor transformColorFormHex:@"d4d4d4"].CGColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.image = [UIImage imageWithData:msg.data];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

-(CGSize) intrinsicContentSize
{
    CGFloat imgWidth, imgHeight;
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat maxWidth = screenWidth * (270.0/640);
    CGFloat minWidth = screenWidth * (114.0/640);
    UIImage * image = [UIImage imageWithData:self.msg.data];
    CGSize size = image.size;
    if (size.width > size.height) {
        imgWidth = maxWidth;
        imgHeight = size.height * (maxWidth/size.width);
        imgHeight = imgHeight < minWidth ? minWidth : imgHeight;
    } else {
        imgHeight = maxWidth;
        imgWidth = size.width * (maxWidth/size.height);
        imgWidth = imgWidth < minWidth ? minWidth : imgWidth;
    }
    
    return CGSizeMake(imgWidth, imgHeight);
}

@end
