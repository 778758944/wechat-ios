//
//  UserInfoEditDelegate.h
//  WeChat
//
//  Created by Tom Xing on 9/24/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserInfoEditDelegate <NSObject>
-(void) saveWithData: (NSString *) data Key: (NSString *) key;
@end

NS_ASSUME_NONNULL_END
