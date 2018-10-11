//
//  Friend.h
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <CoreData/CoreData.h>
@class Message;

@interface Friend : NSManagedObject
@property(nonatomic, strong) NSString * email;
@property(nonatomic, strong) NSNumber * unique;
@property(nonatomic, strong) NSNumber * unread;
@property(nonatomic, strong) NSNumber * belongTo;
@property(nonatomic, strong) Message  * msg;
@property(nonatomic, strong) NSString * username;
@property(nonatomic, strong) NSData * avator;
@property(nonatomic, strong) NSString * avatorUrl;
@end
