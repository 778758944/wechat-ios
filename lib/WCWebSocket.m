//
//  WCWebSocket.m
//  WeChat
//
//  Created by Tom Xing on 9/3/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "WCWebSocket.h"
#import <SocketIO/SocketIO.h>

static SocketManager * _magager = nil;

@interface WCWebSocket()
@end

@implementation WCWebSocket
+(SocketManager *) sharedSocket
{
    if (!_magager) {
        NSURL * url = [[NSURL alloc] initWithString:@"https://chat.xingwentao.xyz"];
        _magager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @NO, @"compress": @YES}];
        SocketIOClient * socket = _magager.defaultSocket;
        
        [socket on:@"connect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
            NSLog(@"socket connect");
        }];
        
        [socket connect];
    }
    
    return _magager;
    
}





@end
