//
//  NoticeSound.h
//  WeChat
//
//  Created by Tom Xing on 9/26/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#define VIBRATEKEY @"VIBRATEKEY"
#define SOUNDKEY @"SOUNDKEY"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSound : NSObject
+(instancetype) sharedInstance;
-(void) play;
@end

NS_ASSUME_NONNULL_END
