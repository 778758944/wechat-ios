//
//  MoreContainer.h
//  WeChat
//
//  Created by Tom Xing on 9/1/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "TopLineView.h"

@interface MoreContainer : TopLineView
@property(nonatomic, strong, readonly) UICollectionView * itemContiner;
@property(nonatomic, strong, readonly) UIPageControl * pageControl;
@end
