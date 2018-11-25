//
//  DrawView.m
//  WeChat
//
//  Created by Tom Xing on 10/11/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

@synthesize pointArr = pointArr;

-(instancetype) init
{
    self = [super init];
    if (self) {
        self.clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_clearBtn setTitle:@"clear" forState:(UIControlStateNormal)];
        [_clearBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _clearBtn.frame = CGRectMake(10, 50, 100, 30);
        
        [_clearBtn addTarget:self action:@selector(clearDraw) forControlEvents:(UIControlEventTouchDown)];
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_closeBtn setTitle:@"close" forState:(UIControlStateNormal)];
        _closeBtn.frame = CGRectMake(10, 90, 100, 30);
        
        
        
        [self addSubview:_clearBtn];
        [self addSubview:_closeBtn];
    }
    
    return self;
}

-(void)drawRect: (CGRect) rect
{
    [super drawRect:rect];
    NSLog(@"draw");
    if (pointArr) {
        [[UIColor redColor] setStroke];
        NSMutableArray<UIBezierPath *> * drawPath = [[NSMutableArray alloc] initWithCapacity:5];
        __block NSInteger index = -1;
        [pointArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString * state = obj[@"state"];
            CGFloat posx = [obj[@"posx"] floatValue];
            CGFloat posy = [obj[@"posy"] floatValue];
            
            
            if ([state isEqualToString: @"start"]) {
                UIBezierPath * path = [UIBezierPath bezierPath];
                path.lineWidth = 5;
                path.lineJoinStyle = kCGLineJoinRound;
                path.lineCapStyle = kCGLineCapRound;
                [path moveToPoint:CGPointMake(posx, posy)];
                index += 1;
                [drawPath addObject:path];
            } else if ([state isEqualToString: @"move"]) {
                UIBezierPath * path = [drawPath objectAtIndex:index];
                [path addLineToPoint: CGPointMake(posx, posy)];
            }
        }];
        
        [drawPath enumerateObjectsUsingBlock:^(UIBezierPath * _Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
            [path stroke];
        }];
    }
}

-(void) clearDraw
{
    pointArr = nil;
    [self setNeedsDisplay];
}

@end
