//
//  CoreDataTableViewCtrl.m
//  WeChat
//
//  Created by Tom Xing on 8/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "CoreDataTableViewCtrl.h"

@interface CoreDataTableViewCtrl ()

@end

@implementation CoreDataTableViewCtrl

-(void) setDataCtrl:(NSFetchedResultsController *)dataCtrl
{
#warning rember forever
    // self.dataCtrl = dataCtrl
    _dataCtrl = dataCtrl;
    self.dataCtrl.delegate = self;
    [self fetchData];
}

-(void) fetchData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError * error;
        [self.dataCtrl performFetch: &error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"core data fetch error: %@", error);
            } else {
                [self.tableView reloadData];
            }
        });
    });
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.dataCtrl sections] count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.dataCtrl sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.dataCtrl sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:(UITableViewRowAnimationFade)];
        break;
            
        case NSFetchedResultsChangeMove:
            
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //
            break;
            
        default:
            //
            return;
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
