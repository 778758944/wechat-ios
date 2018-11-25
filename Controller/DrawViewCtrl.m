//
//  DrawViewCtrl.m
//  WeChat
//
//  Created by Tom Xing on 10/11/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "DrawViewCtrl.h"
#import "DrawView.h"
#import "WCWebSocket.h"
#import <SocketIO/SocketIO.h>
#import "User.h"
#import "Friend.h"

@interface DrawViewCtrl ()
@property(nonatomic, weak) SocketIOClient * socket;
@end

typedef enum {
    START,
    MOVE,
    END,
} DrawState;

@implementation DrawViewCtrl

-(void) loadView
{
    self.view = [[DrawView alloc] init];
}

-(void) setSocket:(SocketIOClient *)socket
{
    if (socket) {
        _socket = socket;
        [_socket on:@"news" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
            NSLog(@"news");
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    DrawView * drawView = (DrawView *) self.view;
    
    [drawView.closeBtn addTarget:self action:@selector(closeDraw) forControlEvents:(UIControlEventTouchDown)];
    self.socket = [WCWebSocket sharedSocket].defaultSocket;
    
}

-(void) closeDraw
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableArray * pointArr = ((DrawView *) self.view).pointArr;
    if (!pointArr) {
        ((DrawView *) self.view).pointArr = pointArr = [NSMutableArray arrayWithCapacity:100];
    }
    
    UITouch * touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    [pointArr addObject:@{
                          @"state": @"start",
                          @"posx": [NSNumber numberWithFloat:p.x],
                          @"posy": [NSNumber numberWithFloat:p.y]
                          }];
    [self sendDrawMsgWithState:START Point:p];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableArray * pointArr = ((DrawView *) self.view).pointArr;
    UITouch * touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    
    [pointArr addObject:@{
                          @"state": @"move",
                          @"posx": [NSNumber numberWithFloat:p.x],
                          @"posy": [NSNumber numberWithInt:p.y]
                          }];
    [self.view setNeedsDisplay];
    [self sendDrawMsgWithState:MOVE Point:p];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableArray * pointArr = ((DrawView *) self.view).pointArr;
    [pointArr addObject:@{
                          @"state": @"end"
                          }];
    [self sendDrawMsgWithState:END Point:CGPointZero];
}

-(void) sendDrawMsgWithState: (DrawState) state Point: (CGPoint) pos
{
    NSInteger currentId = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    NSNumber * toId = self.contacter.unique;
    CGSize size = self.view.bounds.size;
    
    CGFloat posx = pos.x / size.width;
    CGFloat posy = pos.y / size.height;
    
    NSInteger timestamp = (NSInteger) [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diffTime = [[NSTimeZone systemTimeZone] secondsFromGMT];
    timestamp = timestamp - diffTime;
    
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [msg setObject:[NSNumber numberWithFloat: posx] forKey:@"posx"];
    [msg setObject:[NSNumber numberWithFloat: posy] forKey:@"posy"];
    
    switch (state) {
        case START:
            [msg setObject:@"start" forKey:@"state"];
            break;
            
        case MOVE:
            [msg setObject:@"move" forKey:@"state"];
            break;
            
        case END:
            [msg setObject:@"end" forKey:@"state"];
            break;
            
        default:
            [msg setObject:@"move" forKey:@"state"];
            break;
    }
    
    NSDictionary * drawMsg = @{
                               @"createAt": [NSNumber numberWithLong:timestamp],
                               @"from": [NSNumber numberWithLong:currentId],
                               @"lx": @"draw",
                               @"msg": msg,
                               @"to": toId,
                               @"type": @2,
                               };
    
    [_socket emit:@"sendMsg" with:@[drawMsg]];
    
    
    
    
}

@end
