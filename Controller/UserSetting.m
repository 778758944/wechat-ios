//
//  UserSetting.m
//  WeChat
//
//  Created by Tom Xing on 9/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "UserSetting.h"
#import "UserSettingCell.h"
#import "InputController.h"
#import "UserInfoEditDelegate.h"
#import "NetWork.h"
#import "UIViewController+Alert.h"
#import "WCLoading.h"
#import "User+addon.h"
#import "WCImageViewCtrl.h"

NSString * REUSEID = @"reuseid";

typedef  enum {
    ImageContent,
    TextContent
} ContentType;

@interface UserSetting () <UserInfoEditDelegate>
@property(nonatomic, strong) NSArray<NSMutableDictionary *> * items;

@end

@implementation UserSetting

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UserSettingCell class] forCellReuseIdentifier:REUSEID];
    NSMutableDictionary * item1 = [[NSMutableDictionary alloc] init];
    [item1 setObject:@"Profile Photo" forKey:@"name"];
    if (self.currentUser.avator) {
        [item1 setObject:[UIImage imageWithData:self.currentUser.avator] forKey: @"content"];
    } else {
        [item1 setObject:[UIImage imageNamed:@"girl.jpg"] forKey: @"content"];
    }
    [item1 setObject:@YES forKey:@"editable"];
    
    NSMutableDictionary * item2 = [[NSMutableDictionary alloc] init];
    [item2 setObject:@"Name" forKey:@"name"];
    [item2 setObject:self.currentUser.username forKey:@"content"];
    [item2 setObject:@YES forKey:@"editable"];
    
    self.items = @[item1, item2];
    
    self.navigationItem.title = @"My Profile";
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UserSettingCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * item = self.items[indexPath.row];
    UserSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSEID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.leftTextLabel.text = item[@"name"];
    cell.content = item[@"content"];
    
    
    return cell;
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

#pragma mark tableview
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 82;
    }
    
    return 44;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * item = self.items[indexPath.row];
    if (indexPath.row == 1) {
        InputController * input = [[InputController alloc] initWithContent:item[@"content"] Title:item[@"name"]];
        input.delegate = self;
        UINavigationController * inputNav = [[UINavigationController alloc] initWithRootViewController:input];
        [self presentViewController:inputNav animated:YES completion:nil];
    } else if (indexPath.row == 0) {
        WCImageViewCtrl * imageCtrl = [[WCImageViewCtrl alloc] init];
        imageCtrl.image = _items[0][@"content"];
        imageCtrl.delegate = self;
        imageCtrl.currentUser = self.currentUser;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:imageCtrl animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) saveWithData: (NSString *) data Key: (NSString *) key
{
    NSDictionary * dic;
    [WCLoading show];
    if ([key isEqualToString:@"Name"]) {
        dic = @{
                @"path": self.currentUser.avatorUrl,
                @"username": data
                };
    } else {
        dic = @{
                @"path": data,
                @"username": self.currentUser.username
                };
    }
    
    NetWork * net = [NetWork sharedNetWork];
    [net postWithUrl:@"/yonghus/updateInfo" Data:dic completion:^(NSError *err, NSDictionary *response) {
        if (err) {
            [self alertWithTitle:@"Error" Message:err.localizedDescription];
        } else {
            NSDictionary * updateInfo = @{
                                          @"username": dic[@"username"],
                                          @"img": dic[@"path"]
                                          };
            [User updateWithInfo:updateInfo inContext:self.currentUser.managedObjectContext];
            [self updateWithInfo];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [WCLoading hide];
            [self.tableView reloadData];
        });
    }];
}

-(void) updateWithInfo
{
    NSInteger userid = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    self.currentUser = [User getCurrentUserWithUserId:userid inContext:self.currentUser.managedObjectContext];
    [_items[1] setObject:self.currentUser.username forKey:@"content"];
    [_items[0] setObject:[UIImage imageWithData:self.currentUser.avator] forKey:@"content"];
}

@end
