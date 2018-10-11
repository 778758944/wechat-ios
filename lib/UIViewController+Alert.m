//
//  UIViewController+Alert.m
//  WeChat
//
//  Created by Tom Xing on 8/28/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)
-(void) alertWithTitle: (NSString *) title Message: (NSString *) msg
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:ok];
    if ([NSThread currentThread].isMainThread) {
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}
@end
