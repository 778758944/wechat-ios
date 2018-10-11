//
//  WCWebSocket.h
//  WeChat
//
//  Created by Tom Xing on 9/3/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SocketManager;

@interface WCWebSocket : NSObject
+(SocketManager *) sharedSocket;
@end
