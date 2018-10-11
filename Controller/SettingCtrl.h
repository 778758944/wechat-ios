//
//  SettingCtrl.h
//  WeChat
//
//  Created by Tom Xing on 9/16/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SettingCtrl : UITableViewController
@property(nonatomic, strong) NSManagedObjectContext * ctx;
@property(nonatomic, weak) NSPersistentStoreCoordinator * coordinator;
@end
