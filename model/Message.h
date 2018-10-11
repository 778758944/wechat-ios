//
//  Message.h
//  WeChat
//
//  Created by Tom Xing on 9/5/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <CoreData/CoreData.h>
@class Friend;

@interface Message : NSManagedObject
@property(nonatomic, strong) NSNumber * createAt;
@property(nonatomic, strong) NSData * data;
@property(nonatomic, strong) NSNumber * from;
@property(nonatomic, copy) NSString * msgType;
@property(nonatomic, strong) NSNumber * type;
@property(nonatomic, strong) Friend * fromWho;
@property(nonatomic, strong) NSNumber * to;
@property(nonatomic, strong) NSNumber * groupTime;
@property(nonatomic) NSInteger belongTo;

@end
