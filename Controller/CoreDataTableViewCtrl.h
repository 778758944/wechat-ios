//
//  CoreDataTableViewCtrl.h
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewCtrl : UITableViewController <NSFetchedResultsControllerDelegate>
@property(nonatomic, strong) NSFetchedResultsController * dataCtrl;
@property(nonatomic, strong) NSString * test;
-(void) fetchData;
@end
