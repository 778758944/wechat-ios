//
//  Friend+addon.m
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "Friend+addon.h"
#import "Message+addon.h"
#import "User.h"
#import "NetWork.h"

@implementation Friend (addon)
+(Friend *) addFriendWithFriendInfo: (NSDictionary *) info inContext:(NSManagedObjectContext *)ctx
{
    Friend * friend;
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"unique = %@", info[@"id"]];
    
    request.predicate = predicate;
    
    NSArray<Friend *> * result = [ctx executeFetchRequest: request error:nil];
    [Message addMsgs:info[@"unreads"] inContext:ctx];
    
    
    if ([result count] == 1) {
        friend = [result firstObject];
        NSArray * unreadMsg = info[@"unreads"];
        friend.unread = [NSNumber numberWithInteger:[unreadMsg count]];
        if (![friend.avatorUrl isEqualToString:info[@"img"]] && [info[@"img"] isKindOfClass:[NSString class]]) {
            friend.avator = [Friend downloadAvator:info[@"img"]];
            friend.avatorUrl = info[@"img"];
        }
        
        if (![friend.username isEqualToString:info[@"username"]] && [info[@"username"] isKindOfClass:[NSString class]]) {
            friend.username = info[@"username"];
        }

    } else {
        Friend * friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:ctx];
        
        NSNumber * unique = (NSNumber *) info[@"id"];
        NSArray * unreadMsg = info[@"unreads"];
        
        friend.email = info[@"email"];
        friend.unique = unique;
        friend.unread = [NSNumber numberWithInteger:[unreadMsg count]];
        NSInteger belongTo = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
        friend.belongTo = [NSNumber numberWithInteger:belongTo];
        
        if ([info[@"username"] isKindOfClass:[NSString class]]) {
            friend.username = info[@"username"];
        }
        
        if ([info[@"img"] isKindOfClass:[NSString class]]) {
            friend.avatorUrl = info[@"img"];
            friend.avator = [Friend downloadAvator:info[@"img"]];
        }
    }
    return friend;
}

+(void) addFriendsWithInfo: (NSArray<NSDictionary *> *) info inContext: (NSManagedObjectContext *) ctx
{
    for (int i = 0; i < [info count]; i++) {
        [self addFriendWithFriendInfo:[info objectAtIndex:i] inContext:ctx];
    }
    [ctx save: nil];
}

+(Friend *) getFriendWithId: (NSInteger) userId inContext: (NSManagedObjectContext *) ctx
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"unique = %d", userId];
    
    request.predicate = predicate;
    NSError * err;
    
    NSArray<Friend *> * match = [ctx executeFetchRequest:request error:&err];
    
    if (err) {
        NSLog(@"get friend error: %@", err);
        return nil;
    } else if ([match count] == 0) {
        return nil;
    }
    
    return [match firstObject];
}

+(NSData *) downloadAvator: (NSString *) loc
{
    NSString * imageStr = [NSString stringWithFormat:@"%@%@", SOURCELOC, loc];
    NSURL * url = [NSURL URLWithString:imageStr];
    return [NSData dataWithContentsOfURL:url];
}


@end
