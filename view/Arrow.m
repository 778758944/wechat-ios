//
//  otherArrow.m
//  WeChat
//
//  Created by Tom Xing on 9/14/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "Arrow.h"
#import "UIColor+transform.h"

CGFloat arrowWidth = 6;
CGFloat arrowHeight = 11;

static UIImage * _arrowOther;
static UIImage * _arrowMine;

@implementation Arrow;
+(UIImage *) getOtherArrow
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat factor = [[UIScreen mainScreen] scale];
        CGFloat _w = arrowWidth * factor;
        CGFloat _h = arrowHeight * factor;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(_w, _h), NO, 1);
        CGContextRef layerCtx = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(layerCtx, factor, factor);
        CGMutablePathRef pathRef = CGPathCreateMutable();
        
        
        CGContextSaveGState(layerCtx);
        CGContextSetRGBFillColor(layerCtx, 1, 1, 1, 1);
        CGContextSetRGBStrokeColor(layerCtx, 1, 0, 0, 1);
        CGContextSetStrokeColorWithColor(layerCtx, [UIColor transformColorFormHex:@"d4d4d4"].CGColor);
        CGContextSetLineWidth(layerCtx, 1);
        CGContextSetLineJoin(layerCtx, kCGLineJoinMiter);
        
        
        
        CGPathMoveToPoint(pathRef, NULL, 1, 5.5);
        CGPathAddLineToPoint(pathRef, NULL, 6, 1);
        CGPathAddLineToPoint(pathRef, NULL, 6, 10);
        CGPathCloseSubpath(pathRef);
        CGContextAddPath(layerCtx, pathRef);
        CGContextFillPath(layerCtx);
        
        CGPoint points[4] = {
            CGPointMake(1, 5.5),
            CGPointMake(6, 0),
            CGPointMake(1, 5.5),
            CGPointMake(6, 11),
        };
        
        CGContextStrokeLineSegments(layerCtx, points, 4);
        
        
        CGContextRestoreGState(layerCtx);
        _arrowOther = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
    });
    
    return _arrowOther;
}


+(UIImage *) getMineArrow
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat factor = [[UIScreen mainScreen] scale];
        CGFloat _w = arrowWidth * factor;
        CGFloat _h = arrowHeight * factor;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(_w, _h), NO, 1);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGContextScaleCTM(ctx, factor, factor);
        
        CGContextSetFillColorWithColor(ctx, [UIColor transformColorFormHex:@"a0e75a"].CGColor);
        CGContextSetStrokeColorWithColor(ctx, [UIColor transformColorFormHex:@"6fb44d"].CGColor);
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        CGContextSetLineWidth(ctx, 1);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 5, 5.5);
        CGPathAddLineToPoint(path, NULL, 0, 1);
        CGPathAddLineToPoint(path, NULL, 0, 10);
        CGPathCloseSubpath(path);
        CGContextAddPath(ctx, path);
        
        CGContextFillPath(ctx);
        CGPoint points[4] = {
            CGPointMake(5, 5.5),
            CGPointMake(0, 0),
            CGPointMake(5, 5.5),
            CGPointMake(0, 11),
        };
        
        CGContextStrokeLineSegments(ctx, points, 4);
        CGContextRestoreGState(ctx);
        _arrowMine = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return _arrowMine;
}


@end



































