//
//  PopImageBtn.m
//  WeChat
//
//  Created by Tom Xing on 8/26/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "PopImageBtn.h"
#import "UIColor+transform.h"

@implementation PopImageBtn
+(instancetype) buttonWithTitle: (NSString *) title Image: (NSString *) imageName
{
    PopImageBtn * btn = [PopImageBtn buttonWithType:UIButtonTypeCustom];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    if (btn) {
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        NSAttributedString * attributeTitle = [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                                            NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                            
                                                                                                    
                                                                                        
                                                                                                            }];
        [btn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
        [btn setAttributedTitle:attributeTitle forState:(UIControlStateNormal)];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
        [btn setBackgroundColor:[UIColor transformColorFormHex:@"49484b"]];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 43, 0, 0);
    }
    
    return btn;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    return CGRectMake(20, 12, 20, 20);
}

-(void) drawRect:(CGRect)rect
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0 + 15, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width - 15, rect.size.height)];
    [UIColor transformColorFormHex:@"5c5b5d"];
    [path stroke];
}

-(void) setHighlighted:(BOOL)highlighted
{
    NSLog(@"Highlighted");
    if (highlighted) {
        [self setBackgroundColor:[UIColor transformColorFormHex:@"424143"]];
    } else {
        [self setBackgroundColor:[UIColor transformColorFormHex:@"49484b"]];
    }
}

























@end
