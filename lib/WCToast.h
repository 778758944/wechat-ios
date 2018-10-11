//
//  WCToast.h
//  WeChat
//
//  Created by Tom Xing on 8/27/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCToast : UIView

+(void) showWithTitle: (NSString *) title timeout: (NSTimeInterval) time;

@end
