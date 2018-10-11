//
//  ChatViewCtrl.h
//  WeChat
//
//  Created by Tom Xing on 8/29/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "CoreDataTableViewCtrl.h"
@class Friend;

@interface ChatViewCtrl : CoreDataTableViewCtrl
@property(nonatomic, strong) Friend * contacter;
@end
