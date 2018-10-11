//
//  Message+addon.m
//  WeChat
//
//  Created by Tom Xing on 9/5/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "Message+addon.h"
#import "Friend+addon.h"
#import "User.h"

@implementation Message (addon)
+(Message *) addMsg: (NSDictionary *) msg inContext: (NSManagedObjectContext *) ctx
{
    // search for the last msg to determine wheather should create new section
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"((from = %ld) AND (to = %ld)) OR ((from = %ld) AND (to = %ld))", [msg[@"from"] integerValue], [msg[@"to"] integerValue], [msg[@"to"] integerValue], [msg[@"from"] integerValue]];
    
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"createAt" ascending:NO];
    
    fetch.predicate = predicate;
    fetch.sortDescriptors = @[sort];
    fetch.fetchLimit = 1;
    NSError * fetchErr;
    NSArray<Message *> * arr = [ctx executeFetchRequest:fetch error: &fetchErr];
    NSNumber * lastMsgDate;
    
    if (!fetchErr && arr.count == 1) {
        NSLog(@"lastMsgDate: %@", arr[0].createAt);
        lastMsgDate = arr[0].createAt;
    }
    
    
    Message * addMsg = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:ctx];
    
    addMsg.createAt = msg[@"createAt"];
    addMsg.belongTo = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    NSLog(@"newcreateAt: %@", msg[@"createAt"]);
    if (!lastMsgDate) {
        addMsg.groupTime = msg[@"createAt"];
    } else {
        if ([addMsg.createAt doubleValue] - [lastMsgDate doubleValue]> 60 * 5) {
            addMsg.groupTime = msg[@"createAt"];
        } else {
            addMsg.groupTime = arr[0].groupTime;
        }
    }
    addMsg.from = [NSNumber numberWithInteger:[msg[@"from"] integerValue]];
    addMsg.msgType = [NSString stringWithFormat:@"%@", msg[@"lx"]];
    addMsg.to = [NSNumber numberWithInteger:[msg[@"to"] integerValue]];
    
    if([addMsg.msgType isEqualToString:@"0"]) {
        addMsg.data = [msg[@"msg"] dataUsingEncoding:(NSUTF8StringEncoding)];
    } else if ([addMsg.msgType isEqualToString:@"img"]) {
        NSString * base64String = msg[@"msg"];
        NSInteger index = [base64String rangeOfString:@","].location;
        NSString * subString = [base64String substringFromIndex:index + 1];
        NSData * data = [[NSData alloc] initWithBase64EncodedString:subString options:0];
        addMsg.data = data;
    } else {
        addMsg.data = msg[@"msg"];
    }
    addMsg.type = [NSNumber numberWithInteger:[msg[@"type"] integerValue]];
    if (addMsg.type.integerValue == 1) {
        addMsg.fromWho = [Friend getFriendWithId:[msg[@"to"] integerValue] inContext:ctx];
    } else {
        addMsg.fromWho = [Friend getFriendWithId:[msg[@"from"] integerValue] inContext:ctx];
    }
    NSError * err;
    [ctx save: &err];
    
    if (err) {
        NSLog(@"save msg error: %@", err);
    }
    
    return addMsg;
    
}

+(void) addMsgs: (NSArray<NSDictionary *> *) msgs inContext: (NSManagedObjectContext *) ctx
{
    NSInteger count = [msgs count];
    for (NSInteger i = 0; i < count; i++) {
        [self addMsg:msgs[i] inContext:ctx];
    }
}

+(NSArray<Message *> *) getMsgWithId: (NSInteger) userId inContext: (NSManagedObjectContext *) ctx
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"createAt" ascending:NO];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"from = %d", userId];
    
    request.predicate = predicate;
    request.sortDescriptors = @[sort];
    request.fetchBatchSize = 1;
    NSError * err;
    NSArray<Message *> * match = [ctx executeFetchRequest:request error:&err];
    
    if (err) {
        NSLog(@"get message error: %@", err);
        return nil;
    }
    
    NSLog(@"message: %@", [match firstObject].data);
    NSLog(@"form set message: %@", [[[[[NSSet alloc] initWithArray:match] allObjects] firstObject] data]);
    
    return match;
}
@end
