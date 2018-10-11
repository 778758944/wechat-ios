//
//  WCToast.m
//  WeChat
//
//  Created by Tom Xing on 8/27/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "WCToast.h"
#import "ToastView.h"

static  ToastView * _toastView;

@implementation WCToast
+(void) showWithTitle: (NSString *)title timeout: (NSTimeInterval) timeout
{
    ToastView * toast = [WCToast getToastView];
    [toast setText:title];
    
    UIWindow * win = [[UIApplication sharedApplication] delegate].window;
    [win addSubview:toast];
    [UIView animateWithDuration:0.3 animations:^{
        toast.transform = CGAffineTransformTranslate(toast.transform, 0, -win.bounds.size.height);
    } completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:timeout repeats:NO block:^(NSTimer * _Nonnull timer) {
            [UIView animateWithDuration:0.3 animations:^{
                toast.transform = CGAffineTransformTranslate(toast.transform, 0, win.bounds.size.height);
            } completion:^(BOOL finished) {
                [toast removeFromSuperview];
            }];
        }];
    }];
}

+(ToastView *) getToastView
{
    if (!_toastView) {
        _toastView = [[ToastView alloc] init];
    }
    
    return _toastView;
}
@end
