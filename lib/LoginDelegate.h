//
//  LoginDelegate.h
//  WeChat
//
//  Created by Tom Xing on 8/24/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginDelegate <NSObject>
@required
-(void) CallbackForLogin;
@end
