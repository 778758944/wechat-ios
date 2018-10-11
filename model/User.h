//
//  User.h
//  WeChat
//
//  Created by Tom Xing on 9/6/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <CoreData/CoreData.h>
#define WC_CURRENT_USER @"wc_current_user"

@interface User : NSManagedObject
@property(nonatomic, strong) NSNumber * userId;
@property(nonatomic, strong) NSData * avator;
@property(nonatomic, copy) NSString * username;
@property(nonatomic, copy) NSString * avatorUrl;
@end
