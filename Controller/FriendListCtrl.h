//
//  FriendListCtrl.h
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "CoreDataTableViewCtrl.h"
#import "UIViewController+Alert.h"
#define FRIENDLIST_POINT @"/yonghus/friendList"


@interface FriendListCtrl : CoreDataTableViewCtrl
@property(nonatomic, strong) NSManagedObjectContext * dataCtx;
-(void) getFriendList;
@end
