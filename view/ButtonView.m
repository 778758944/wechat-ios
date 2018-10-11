//
//  ButtonView.m
//  WeChat
//
//  Created by Tom Xing on 8/20/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "ButtonView.h"
#import "UIColor+transform.h"

@implementation ButtonView

-(instancetype) initWithTitle: (NSString *) title isActive: (BOOL) isActive style: (WCButtonType) style
{
    ButtonView * btn = [ButtonView buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (style == WCNormal) {
        btn.backgroundColor = [UIColor transformColorFormHex:@"1aad19"];
        btn.layer.borderColor = [UIColor transformColorFormHex:@"189c18"].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        
        NSAttributedString * attr_title = [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                
            }];
        
        [btn setAttributedTitle:attr_title forState:UIControlStateNormal];
        [btn setAttributedTitle:attr_title forState:UIControlStateDisabled];
    } else {
        /*
        NSAttributedString * attr_title = [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                                                        NSForegroundColorAttributeName: [UIColor transformColorFormHex:@"576b95"],
                                                                                                        
                                                                                                        }];
        [btn setAttributedTitle:attr_title forState:UIControlStateNormal];
         */
        [btn setTitleColor:[UIColor transformColorFormHex:@"576b95"] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    if (!isActive) {
        btn.alpha = 0.5;
        btn.enabled = NO;
    }
    return btn;
}

-(CGRect) imageRectForContentRect:(CGRect)contentRect
{
    NSLog(@"imagesize %@", [NSValue valueWithCGRect:contentRect]);
    
    return CGRectMake(0, 0, 15, 15);
}


-(void) activeBtn
{
    self.alpha = 1.0;
    self.enabled = YES;
}

-(void) disableBtn
{
    self.alpha = 0.5;
    self.enabled = NO;
}

@end
