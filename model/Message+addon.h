//
//  Message+addon.h
//  WeChat
//
//  Created by Tom Xing on 9/5/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "Message.h"

@interface Message (addon)
+(Message *) addMsg: (NSDictionary *) msg inContext: (NSManagedObjectContext *) ctx;
+(void) addMsgs: (NSArray<NSDictionary *> *) msgs inContext: (NSManagedObjectContext *) ctx;
+(NSArray<Message *> *) getMsgWithId: (NSInteger) userId inContext: (NSManagedObjectContext *) ctx;
@end
