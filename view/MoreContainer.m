
//
//  MoreContainer.m
//  WeChat
//
//  Created by Tom Xing on 9/1/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "MoreContainer.h"
#import "MoreContainerLayout.h"
#import "UIColor+transform.h"

@interface MoreContainer()
@property(nonatomic, strong, readwrite) UICollectionView * itemContiner;
@property(nonatomic, strong, readwrite) UIPageControl * pageControl;
@end

@implementation MoreContainer

-(id) init
{
    self = [super init];
    
    if (self) {
        MoreContainerLayout * layout = [[MoreContainerLayout alloc] init];
        self.itemContiner = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, layout.screenWidth, 230) collectionViewLayout:layout];
        _itemContiner.pagingEnabled = YES;
        _itemContiner.showsHorizontalScrollIndicator = NO;
        _itemContiner.backgroundColor = [UIColor clearColor];
        
        
        self.pageControl =[[UIPageControl alloc] initWithFrame:CGRectMake(0, 215, 0, 10)];
        _pageControl.numberOfPages = 2;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor transformColorFormHex:@"8b8b8b"];
        _pageControl.pageIndicatorTintColor = [UIColor transformColorFormHex:@"bbbbbb"];
        
        [self addSubview:_itemContiner];
        [self addSubview:_pageControl];
    }
    
    return self;
}





















@end
