//
//  OtherSettingCtrl.h
//  WeChat
//
//  Created by Tom Xing on 9/25/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherSettingCtrl : UITableViewController
@property(nonatomic, weak) NSPersistentStoreCoordinator * coordinator;
@property(nonatomic, weak) NSManagedObjectContext * ctx;
@end

NS_ASSUME_NONNULL_END
