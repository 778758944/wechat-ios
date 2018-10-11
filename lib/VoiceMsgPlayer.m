//
//  VoiceMsgPlayer.m
//  WeChat
//
//  Created by Tom Xing on 9/8/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "VoiceMsgPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "WCToast.h"
static AVAudioPlayer * player;


@implementation VoiceMsgPlayer
+(void) playWithData: (NSData *) data;
{
    NSError * err;
    if (player) {
        player = nil;
    }
    
    player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:@"wav" error: &err];
    if (err) {
        [WCToast showWithTitle:err.localizedDescription timeout:2];
    }
    [player play];
}

+(NSTimeInterval) getDurationOfData: (NSData *) data
{
    NSError * err;
    
    AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:@"wav" error: &err];
    if (err) {
        [WCToast showWithTitle:err.localizedDescription timeout:2];
    }
    
    
    return player.duration;
}

+(void) stop
{
    if (player) {
        [player stop];
        player = nil;
    }
}

+(double) getRatioWithData: (NSData *) data
{
    NSError * err;
    AVAudioPlayer * playerForDuration = [[AVAudioPlayer alloc] initWithData:data error: &err];
    if (err) {
        [WCToast showWithTitle:err.localizedDescription timeout:2];
    }
    
    CGFloat ratio = playerForDuration.duration/60;
    
    ratio += 0.25;
    
    if (ratio > 1) {
        ratio = 1;
    }
    
    return ratio;
}


@end
