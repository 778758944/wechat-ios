//
//  UIImage+transform.m
//  WeChat
//
//  Created by Tom Xing on 9/23/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "UIImage+transform.h"

@implementation UIImage (transform)
-(UIImage *) transformSize: (CGSize) size
{
    UIImage * sizeImage;
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat _w = size.width * scale;
    CGFloat _h = size.height * scale;
    UIGraphicsBeginImageContext(CGSizeMake(_w, _h));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(ctx, scale, scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    sizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return sizeImage;
}
@end
