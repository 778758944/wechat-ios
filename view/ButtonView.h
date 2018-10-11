//
//  ButtonView.h
//  WeChat
//
//  Created by Tom Xing on 8/20/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WCNormal,
    WCLink,
    WCImage,
} WCButtonType;

@interface ButtonView : UIButton
-(instancetype) initWithTitle: (NSString *) title isActive: (BOOL) isActive style: (WCButtonType) style;

-(void) activeBtn;
-(void) disableBtn;
@end
