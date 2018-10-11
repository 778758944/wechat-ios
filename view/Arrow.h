//
//  otherArrow.h
//  WeChat
//
//  Created by Tom Xing on 9/14/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern CGFloat arrowWidth;
extern CGFloat arrowHeight;

@interface Arrow : NSObject
+(UIImage *) getOtherArrow;
+(UIImage *) getMineArrow;
@end
