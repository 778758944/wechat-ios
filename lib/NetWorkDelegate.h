//
//  NetWorkDelegate.h
//  WeChat
//
//  Created by Tom Xing on 8/28/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetWorkDelegate <NSObject>
@required
-(void) alertWithTitle: (NSString *) title Message: (NSString *) msg;
@end
