//
//  User+addon.h
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "User.h"

@interface User (addon)
+(User *) addUser: (NSDictionary *) userInfo inContext: (NSManagedObjectContext *) ctx;
+(User *) getCurrentUserWithUserId: (NSInteger) userId inContext: (NSManagedObjectContext *) ctx;

+(User *) updateWithInfo: (NSDictionary *) info inContext: (NSManagedObjectContext *) ctx;

@end
