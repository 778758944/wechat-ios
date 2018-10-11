//
//  VoiceMsgPlayer.h
//  WeChat
//
//  Created by Tom Xing on 9/8/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceMsgPlayer : NSObject
+(void) playWithData: (NSData *) data;
+(NSTimeInterval) getDurationOfData: (NSData *) data;
+(void) stop;
+(double) getRatioWithData: (NSData *) data;
@end
