//
//  FriendListCtrl.m
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "FriendListCtrl.h"
#import "NotificationConstant.h"
#import "NetWork.h"
#import "Friend+addon.h"
#import "LoginCtrl.h"
#import "FriendListCellView.h"
#import "UIColor+transform.h"
#import "LoginDelegate.h"
#import "FriendListPopCtrl.h"
#import "WCLoading.h"
#import "WCToast.h"
#import "NetWorkDelegate.h"
#import "ChatViewCtrl.h"
#import <SocketIO/SocketIO.h>
#import "WCWebSocket.h"
#import "Message+addon.h"
#import "User+addon.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WCLoading.h"
#import "DateCustomFormat.h"
#import "NoticeSound.h"
#define REUSE_ID @"friend_list_cell_reuse"

@interface FriendListCtrl ()<LoginDelegate, NetWorkDelegate, UIPopoverPresentationControllerDelegate>
@property(nonatomic, strong) NSDateFormatter * dateFormatter;
@property(nonatomic, weak) SocketIOClient * socket;
@property(nonatomic) SystemSoundID soundId;
@property(nonatomic, weak) UITabBarItem * tabCount;
@property(nonatomic) NSUInteger totalUnread;
@property(nonatomic, weak) UITabBar * bottomBar;
@property(nonatomic, weak) NoticeSound * notice;
@end

@implementation FriendListCtrl

-(NoticeSound *) notice{
    if (!_notice) {
        _notice = [NoticeSound sharedInstance];
    }
    
    return _notice;
}

-(UITabBar *) bottomBar
{
    if (!_bottomBar) {
        _bottomBar = self.navigationController.tabBarController.tabBar;
    }
    
    return _bottomBar;
}

-(UITabBarItem *) tabCount
{
    if (!_tabCount) {
        _tabCount = self.navigationController.tabBarItem;
    }
    
    return _tabCount;
}

-(void) setTotalUnread:(NSUInteger)totalUnread
{
    _totalUnread = totalUnread;
    if (_totalUnread > 0) {
        self.tabCount.badgeValue = [NSString stringWithFormat:@"%ld", _totalUnread];
        self.navigationItem.title = [NSString stringWithFormat:@"WeChat(%ld)", _totalUnread];
    } else {
        self.tabCount.badgeValue = nil;
        self.navigationItem.title = @"WeChat";
    }
}

-(SystemSoundID) soundId
{
    if (!_soundId) {
        NSURL * notice = [[NSBundle mainBundle] URLForResource:@"9411" withExtension:@"wav"];
        
        CFURLRef c_notice = (__bridge CFURLRef) notice;
        AudioServicesCreateSystemSoundID(c_notice, &_soundId);
    }
    return _soundId;
}

-(void) setSocket:(SocketIOClient *)socket
{
    if (socket) {
        _socket = socket;
        [_socket on:@"addCounter" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
            NSDictionary * newMsg = [data firstObject];
            NSInteger friend_id = [newMsg[@"from"] integerValue];
            [Message addMsg: newMsg inContext:self.dataCtx];
            
            Friend * f = [Friend getFriendWithId:friend_id inContext:self.dataCtx];
            NSInteger unread = [f.unread integerValue];
            f.unread = [NSNumber numberWithInteger:++unread];
            [self.notice play];
            self.totalUnread++;
        }];
    }
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(showPopMenu)];
    self.navigationItem.title = @"WeChat";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"show Activity" style:(UIBarButtonItemStylePlain) target:self action:@selector(showActivityIndactor)];
    
//    self.hidesBottomBarWhenPushed = YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger currentId = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    if (currentId) {
        NetWork * net = [NetWork sharedNetWork];
        net.delegate = self;
        [net postWithUrl:@"/setPoint" Data:@{@"point": @"/"} completion:^(NSError *err, NSDictionary *response) {
            //
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFriendList) name:UIApplicationWillEnterForegroundNotification object:nil];
    } else {
        [self showLogin];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) getContext: (NSNotification *) notification
{
    self.dataCtx = notification.userInfo[WC_DATACTX_KEY];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES];
    
    request.sortDescriptors = @[sort];
    
    self.dataCtrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.dataCtx sectionNameKeyPath:nil cacheName:nil];
    [self getFriendList];
}

-(void) getFriendList
{
    NSLog(@"foreground");
    [WCLoading show];
    NetWork * net = [NetWork sharedNetWork];
    net.delegate = self;
//    __weak typeof(self) weakSelf = self;
    [net postWithUrl:FRIENDLIST_POINT Data:nil completion:^(NSError *err, NSDictionary *response) {
        NSLog(@"response: %@", response);
        NSNumber * code = response[@"code"];
        __block NSUInteger totalUnread = 0;
        
        if (code.intValue == 200) {
            NSArray<NSDictionary *> * friendInfo = response[@"data"][@"friends"];
            NSDictionary * myself = response[@"data"][@"myself"];
            [friendInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray * unreadMsg = obj[@"unreads"];
                totalUnread += [unreadMsg count];
            }];
            [Friend addFriendsWithInfo:friendInfo inContext:self.dataCtx];
            [User updateWithInfo: myself inContext:self.dataCtx];
            self.socket = [WCWebSocket sharedSocket].defaultSocket;
            if (totalUnread > 0) {
                [self.notice play];
            }
        } else if ([err.domain isEqualToString:NSUserNetWorkCustomDomain]) {
            if (err.code == 401) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showLogin];
                });
            } else {
                [self alertWithTitle:@"Error" Message:err.localizedDescription];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalUnread = totalUnread;
            [WCLoading hide];
        });
    }];
}

-(void) setDataCtx:(NSManagedObjectContext *)dataCtx
{
    _dataCtx = dataCtx;
    
    NSInteger currentUserId = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    
    if (currentUserId) {
        [self fetchWithUserId:currentUserId];
    }
    
    [self getFriendList];
}

-(void) fetchWithUserId: (NSInteger) userid
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES];
    
    request.sortDescriptors = @[sort];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"belongTo = %ld", userid];
    request.predicate = predicate;
    NSArray<Friend *> * match = [self.dataCtx executeFetchRequest:request error:NULL];
    NSLog(@"match: %@", [match lastObject].belongTo);
    
    self.dataCtrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.dataCtx sectionNameKeyPath:nil cacheName:nil];
}

-(void) showLogin
{
    LoginCtrl * login = [[LoginCtrl alloc] init];
    login.loginDelegate = self;
    login.ctx = self.dataCtx;
    [self presentViewController:login animated:YES completion:nil];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"render friend list cell");
    FriendListCellView * cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID];
    if (!cell) {
        cell = [[FriendListCellView alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:REUSE_ID];
    }
    Friend * f = [self.dataCtrl objectAtIndexPath:indexPath];
    
    if ([f.unread integerValue] > 0) {
        cell.unreadMsg.hidden = NO;
        cell.unreadMsg.text = [NSString stringWithFormat:@"%ld", [f.unread integerValue]];
    } else {
        cell.unreadMsg.hidden = YES;
        cell.unreadMsg.text = [NSString stringWithFormat:@"%ld", [f.unread integerValue]];
    }
    
    cell.username.text = f.username ? f.username : f.email;
    if (f.avator) {
        cell.avator.image = [UIImage imageWithData:f.avator];
    } else {
        cell.avator.image = [UIImage imageNamed:@"girl.jpg"];
    }
//    cell.avator.image = [UIImage imageNamed:@"girl.jpg"];
    NSTimeInterval timediff = [[NSTimeZone systemTimeZone] secondsFromGMT];
    if (f.msg && f.msg.createAt) {
        NSDate * lastMsgDate = [NSDate dateWithTimeIntervalSince1970: [f.msg.createAt doubleValue] + timediff];
        cell.time.text = [DateCustomFormat formatForListWithDate:lastMsgDate];
    }
    cell.lastMsg.text = [self getLastMsg:f.msg];
    
    return cell;
}

-(void) CallbackForLogin
{
    NSInteger currentUserId = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    [self fetchWithUserId:currentUserId];
    [self getFriendList];
}

-(void) showPopMenu
{
    FriendListPopCtrl * friendPopCtrl = [[FriendListPopCtrl alloc] init];
    friendPopCtrl.modalPresentationStyle = UIModalPresentationPopover;
    friendPopCtrl.preferredContentSize = CGSizeMake(167, 175);
    UIPopoverPresentationController * popCtrl = [friendPopCtrl popoverPresentationController];
    popCtrl.barButtonItem = self.navigationItem.rightBarButtonItem;
    popCtrl.delegate = self;
    popCtrl.backgroundColor = [UIColor transformColorFormHex:@"49484B"];
    [self presentViewController:friendPopCtrl animated:YES completion:nil];
}

-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

-(void) showActivityIndactor
{
//    [self alertWithTitle:@"error" Message:@"test"];
    [self showLogin];
    
}

#pragma tableDelegate

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"delete");
    }];
    
    UITableViewRowAction * markAsReaded = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"Mark As Read" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"Mark as read");
    }];
    
    return @[delete, markAsReaded];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did selector");
    ChatViewCtrl * chatCtrl = [[ChatViewCtrl alloc] initWithStyle:(UITableViewStylePlain)];
    
    
    Friend * friend = [self.dataCtrl objectAtIndexPath:indexPath];
    self.totalUnread -= [friend.unread integerValue];
    chatCtrl.contacter = friend;
    chatCtrl.navigationItem.title = chatCtrl.contacter.email;
//    chatCtrl.noticeSound = self.soundId;
    NSString * endPoint = [NSString stringWithFormat:@"/chat/%@", friend.unique];
    [[NetWork sharedNetWork] postWithUrl:@"/setPoint" Data:@{@"point": endPoint} completion:^(NSError *err, NSDictionary *response) {
        NSNumber * code = response[@"code"];
        if (code.intValue == 200) {
            NSLog(@"set point success");
        }
    }];
    
    if ([friend.unread integerValue]) {
        [[NetWork sharedNetWork] postWithUrl:@"/unreads/getUnreadMsg" Data:@{@"form": friend.unique} completion:^(NSError *err, NSDictionary *response) {
            if (!err) {
                NSLog(@"delete unread");
//                NSArray * unreadMsgs = response[@"data"];
//                [Message addMsgs:unreadMsgs inContext:self.dataCtx];
            }
        }];
    }
    
    
    friend.unread = 0;
    [self.dataCtx save: NULL];
    [self pushToCtrl:chatCtrl];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *) getLastMsg: (Message *) msg;
{
    if ([msg.msgType isEqualToString:@"wav"]) {
        return @"[Audio]";
    } else if ([msg.msgType isEqualToString:@"img"]) {
        return @"[Image]";
    } else {
        return [[NSString alloc] initWithData:msg.data encoding:(NSUTF8StringEncoding)];
    }
}

-(void) pushToCtrl: (UIViewController *) controller
{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}






















@end
