//
//  SettingCtrl.m
//  WeChat
//
//  Created by Tom Xing on 9/16/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "SettingCtrl.h"
#import "User+addon.h"
#import "UIColor+transform.h"
#import "UIImage+transform.h"
#import "UserSetting.h"
#import "OtherSettingCtrl.h"

NSString * reuseId = @"setting_cell";

@interface SettingCtrl ()
@property(nonatomic, strong) User * currentUser;

@end

@implementation SettingCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor transformColorFormHex:@"efeff4"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];
    self.navigationItem.title = @"Me";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(User *) currentUser
{
    if (!_currentUser) {
        NSInteger userid = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
        _currentUser = [User getCurrentUserWithUserId:userid inContext:self.ctx];
    }
    
    return _currentUser;
}

-(void) updateUserInfo
{
//    NSInteger userid = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
//    _currentUser = [User getCurrentUserWithUserId:userid inContext:self.ctx];
    NSIndexSet * secSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:secSet withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 1;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: reuseId];
    if (indexPath.section == 0) {
        UIImage * avator = [UIImage imageWithData:self.currentUser.avator];
        cell.textLabel.text = self.currentUser.username;
        cell.imageView.image = [avator transformSize:CGSizeMake(32, 32)];
        cell.imageView.layer.cornerRadius = 5;
        cell.imageView.layer.masksToBounds = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    cell.textLabel.text = @"Setting";
    cell.imageView.image = [UIImage imageNamed:@"setting"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 88;
    }
    
    return 44;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserSetting * userSetting = [[UserSetting alloc] initWithStyle:(UITableViewStyleGrouped)];
        userSetting.currentUser = self.currentUser;
        [self pushToCtrl:userSetting animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            OtherSettingCtrl * otherSetting = [[OtherSettingCtrl alloc] initWithStyle:UITableViewStyleGrouped];
            otherSetting.coordinator = self.coordinator;
            otherSetting.ctx = self.ctx;
            [self pushToCtrl:otherSetting animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ctrl life cycle
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUserInfo];
}

#pragma mark push with tabbar
-(void) pushToCtrl: (UIViewController *) viewCtrl animated: (BOOL) animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:animated];
    self.hidesBottomBarWhenPushed = NO;
}

@end
