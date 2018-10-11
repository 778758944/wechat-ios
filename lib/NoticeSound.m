//
//  NoticeSound.m
//  WeChat
//
//  Created by Tom Xing on 9/26/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "NoticeSound.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NotificationConstant.h"

static NoticeSound * _inAppNotice;

@implementation NoticeSound {
    SystemSoundID _soundId;
    BOOL _isVirbate;
    BOOL _isSound;
}

+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inAppNotice = [[NoticeSound alloc] init];
    });
    return _inAppNotice;
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        NSURL * soundUrl = [[NSBundle mainBundle] URLForResource:@"9411" withExtension:@"wav"];
        CFURLRef notice = (__bridge CFURLRef) soundUrl;
        AudioServicesCreateSystemSoundID(notice, &_soundId);
        _isVirbate = [[NSUserDefaults standardUserDefaults] boolForKey:VIBRATEKEY];
        _isSound = [[NSUserDefaults standardUserDefaults] boolForKey:SOUNDKEY];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSound:) name:WC_INAPP_SOUND_CHANGE object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVibrate:) name:WC_INAPP_VIBRATE_CHANGE object:nil];
        
    }
    return self;
}

-(void) handleSound: (NSNotification *) notification
{
    _isSound = [notification.userInfo[@"isOn"] boolValue];
}


-(void) handleVibrate: (NSNotification *) notification
{
    _isVirbate = [notification.userInfo[@"isOn"] boolValue];
}




-(void) play
{
    if (_isSound && _isVirbate) {
        AudioServicesPlayAlertSound(_soundId);
    } else if (_isSound) {
        AudioServicesPlaySystemSound(_soundId);
    } else if (_isVirbate) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
