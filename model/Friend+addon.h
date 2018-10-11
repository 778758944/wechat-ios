//
//  Friend+addon.h
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "Friend.h"

@interface Friend (addon)
+(Friend *) addFriendWithFriendInfo: (NSDictionary *) info inContext: (NSManagedObjectContext *) ctx;

+(void) addFriendsWithInfo: (NSArray<NSDictionary *> *) info inContext: (NSManagedObjectContext *) ctx;

+(Friend *) getFriendWithId: (NSInteger) userId inContext: (NSManagedObjectContext *) ctx;
@end
