//
//  User+addon.m
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "User+addon.h"
#import "NetWork.h"

@implementation User (addon)


+(User *) addUser: (NSDictionary *) userInfo inContext: (NSManagedObjectContext *) ctx
{
    NSInteger userid = [userInfo[@"userId"] integerValue];
    
    User * user = [User getCurrentUserWithUserId:userid inContext:ctx];
    
    
    if (!user) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:ctx];
        user.userId = [NSNumber numberWithInteger:userid];
    }
    
    [User setCustomPropForUser:user info:userInfo];
    [ctx save:nil];
    return user;
}



+(User *) getCurrentUserWithUserId: (NSInteger) userId inContext: (NSManagedObjectContext *) ctx
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId = %ld", userId];
    
    request.predicate = predicate;
    NSError * err;
    
    NSArray * match = [ctx executeFetchRequest:request error:&err];
    
    return err ? nil : [match firstObject];
}

+(User *) updateWithInfo: (NSDictionary *) info inContext: (NSManagedObjectContext *) ctx;
{
    NSInteger currentUserId = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    User * user = [User getCurrentUserWithUserId: currentUserId inContext:ctx];
    [User setCustomPropForUser:user info:info];
    [ctx save:nil];
    return user;
    
}

+(NSData *) downloadAvatorWithUrl: (NSString *) avatorUrl
{
    avatorUrl = [NSString stringWithFormat:@"%@%@", SOURCELOC, avatorUrl];
    NSURL * url = [NSURL URLWithString:avatorUrl];
    return [NSData dataWithContentsOfURL:url];
}

+(void) setCustomPropForUser: (User *) user info: (NSDictionary *) info
{
    if ([info[@"img"] isKindOfClass: [NSString class]] && ![info[@"img"] isEqualToString:user.avatorUrl]) {
        user.avatorUrl = info[@"img"];
        user.avator = [User downloadAvatorWithUrl:user.avatorUrl];
    }
    
    if ([info[@"username"] isKindOfClass:[NSString class]] && ![info[@"username"] isEqualToString:user.username]) {
        user.username = info[@"username"];
    }
}



@end






























