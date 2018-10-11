//
//  WCLoading.m
//  WeChat
//
//  Created by Tom Xing on 8/27/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "WCLoading.h"

static LoadingView * _loadingView;

@implementation WCLoading

+(void) show {
    if ([[NSThread currentThread] isMainThread]) {
        [WCLoading showLoading];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [WCLoading showLoading];
        });
    }
}

+(void) showLoading
{
    LoadingView * loading = [WCLoading getLoadingView];
    UIWindow * win = [[UIApplication sharedApplication] delegate].window;
    
    [win addSubview:loading];
    
    [UIView animateWithDuration:0.2 animations:^{
        loading.alpha = 1;
    } completion:nil];
}

+(void) hide {
    if ([[NSThread currentThread] isMainThread]) {
        [WCLoading hideLoading];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [WCLoading hideLoading];
        });
    }
}

+(void) hideLoading
{
    LoadingView * loading = [WCLoading getLoadingView];
    [UIView animateWithDuration:0.2 animations:^{
        loading.alpha = 0;
    } completion:^(BOOL finished) {
        [loading removeFromSuperview];
    }];
}

+(LoadingView *) getLoadingView
{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc] init];
    }
    return _loadingView;
}

@end
