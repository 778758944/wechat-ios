//
//  NetWork.h
//  WeChat
//
//  Created by Tom Xing on 8/22/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HTTP @"https://chat.xingwentao.xyz/api"
#import "NetWorkDelegate.h"
#define SOURCELOC @"https://chat.xingwentao.xyz"


extern NSErrorDomain const NSUserNetWorkCustomDomain;

@interface NetWork : NSObject

+(instancetype) sharedNetWork;
@property(nonatomic, strong) id<NetWorkDelegate> delegate;
-(void) postWithUrl: (NSString *) url Data: (NSDictionary *) data completion:(void(^)(NSError * err, NSDictionary * response)) handle;
-(void) postImageWithUrl: (NSString *) url Data: (NSDictionary *) data completion: (void(^)(NSError * err, NSDictionary * response)) handle;

@end
