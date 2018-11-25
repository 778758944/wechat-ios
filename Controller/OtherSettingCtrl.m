//
//  OtherSettingCtrl.m
//  WeChat
//
//  Created by Tom Xing on 9/25/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "OtherSettingCtrl.h"
#import "SwitchCell.h"
#import "ButtonCell.h"
#import "NoticeSound.h"
#import "WCLoading.h"
#import "UIViewController+Alert.h"
#import "NetWork.h"
#import "User.h"
#import "NotificationConstant.h"

@interface OtherSettingCtrl ()
@property(nonatomic, getter=isSound) BOOL sound;
@property(nonatomic, getter=isVibrate) BOOL vibrate;
@property(nonatomic, strong) NSArray<NSMutableDictionary *> * items;
@end

@implementation OtherSettingCtrl

-(BOOL) isSound
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SOUNDKEY];
}

-(void) setSound:(BOOL)sound
{
    [[NSUserDefaults standardUserDefaults] setBool:sound forKey:SOUNDKEY];
}

-(BOOL) isVibrate
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VIBRATEKEY];
}

-(void) setVibrate:(BOOL)vibrate
{
    [[NSUserDefaults standardUserDefaults] setBool:vibrate forKey:VIBRATEKEY];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary * item1 = [[NSMutableDictionary alloc] init];
    [item1 setObject:@"Alert Sound" forKey:@"name"];
    [item1 setObject:[NSNumber numberWithBool:self.isSound] forKey:@"value"];
    
    NSMutableDictionary * item2 = [[NSMutableDictionary alloc] init];
    [item2 setObject:@"Vibrate" forKey:@"name"];
    [item2 setObject:[NSNumber numberWithBool:self.isVibrate] forKey:@"value"];
//    [self.view.bottomAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    
    self.items = @[item1, item2];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary * item = _items[indexPath.row];
        SwitchCell * cell = [[SwitchCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reuseSwitch"];
        cell.nameLabel.text = item[@"name"];
        [cell.switchView setOn:[item[@"value"] boolValue] animated:YES];
        if (indexPath.row == 0) {
            [cell.switchView addTarget:self action:@selector(SoundChange:) forControlEvents:(UIControlEventValueChanged)];
        } else {
            [cell.switchView addTarget:self action:@selector(VibrateChange:) forControlEvents:(UIControlEventValueChanged)];
        }
        return cell;
    } else {
        ButtonCell *cell = [[ButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseButton"];
        cell.buttonName.text = @"Log out";
        return cell;
    }
}

-(void) SoundChange: (UISwitch *) sound
{
    self.sound = sound.on;
    NSDictionary * userinfo = @{
                                @"isOn": [NSNumber numberWithBool:sound.on],
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:WC_INAPP_SOUND_CHANGE object:nil userInfo:userinfo];
}

-(void) VibrateChange: (UISwitch *) vibrate
{
    self.vibrate = vibrate.on;
    NSDictionary * userinfo = @{
                                @"isOn": [NSNumber numberWithBool:vibrate.on],
                                };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WC_INAPP_VIBRATE_CHANGE object:nil userInfo:userinfo];
    
}



#pragma mark delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    
    return YES;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UIAlertController * logoutCtrl = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure?" preferredStyle:(UIAlertControllerStyleActionSheet)];
        
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"Log out" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NetWork * net = [NetWork sharedNetWork];
            [WCLoading show];
            [net postWithUrl:@"/yonghus/logout" Data:nil completion:^(NSError *err, NSDictionary *response) {
                if (err) {
                    [self alertWithTitle:@"Error" Message:err.localizedDescription];
                } else {
                    NSArray * requestArr = [self getDeleteFetchs];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WC_CURRENT_USER];
                    [requestArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSBatchDeleteRequest * deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:obj];
                        [self.coordinator executeRequest:deleteReq withContext:self.ctx error:nil];
                    }];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WCLoading hide];
                    self.tabBarController.selectedIndex = 0;
                });
            }];
        }];
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Cancel");
        }];
        
        [logoutCtrl addAction:action1];
        [logoutCtrl addAction:action2];
        
        [self presentViewController:logoutCtrl animated:YES completion:nil];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    }
}

-(NSArray *) getDeleteFetchs
{
    NSInteger currentUserId = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    NSFetchRequest * userRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSFetchRequest * friendRequest = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    NSFetchRequest * msgRequest = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
    
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"belongTo = %ld", currentUserId];
    NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"userId = %ld", currentUserId];
    
    userRequest.predicate = predicate2;
    friendRequest.predicate = predicate;
    msgRequest.predicate = predicate;
    
    return @[userRequest, friendRequest, msgRequest];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
