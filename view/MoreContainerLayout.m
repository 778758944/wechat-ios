//
//  MoreContainerLayout.m
//  WeChat
//
//  Created by Tom Xing on 8/31/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "MoreContainerLayout.h"


@implementation MoreContainerLayout {
    NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> * _layouts;
    CGFloat _width;
    CGFloat _hspacing;
    CGFloat _height;
}

-(id) init
{
    self = [super init];
    if (self) {
        _screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _layouts = [[NSMutableDictionary alloc] init];
        _width = 60;
        _hspacing = (_screenWidth - 240) / 5.0;
        _height = _width + 25;
    }
    return self;
}

-(void) prepareLayout
{
    NSInteger numSection = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < numSection; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger num = 0; num < numItems; num++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:num inSection:section];
            [_layouts setObject:[self layoutAttributesForItemAtIndexPath: indexPath] forKey:indexPath];
        }
    }
}

-(UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger num = indexPath.row;
    NSInteger pageNum = num / 8;
    NSInteger posNum = num % 8;
    UICollectionViewLayoutAttributes * attritube = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger h = posNum - 4;
    CGPoint point;
    
    if (h < 0) {
        point.x = [self posxWithNum:pageNum pos:posNum];
    } else {
        point.x = [self posxWithNum:pageNum pos:h];
    }
    
    point.y = [self posyWithNum:posNum];
    
    
    attritube.frame = CGRectMake(point.x, point.y, _width, _height);
    return attritube;
}

-(CGSize) collectionViewContentSize
{
    CGFloat screen_width = [[UIScreen mainScreen] bounds].size.width;
    NSInteger count = [_layouts count];
    CGFloat width = screen_width * ceil(count/8.00);
    return CGSizeMake(width, 230);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray<UICollectionViewLayoutAttributes *> * attributes = [[NSMutableArray alloc] init];
    
    for (NSIndexPath * key in _layouts) {
        UICollectionViewLayoutAttributes * attr = [_layouts objectForKey:key];
        
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attributes addObject:attr];
        }
    }
    
    return attributes;
}

-(CGFloat) posxWithNum: (NSInteger) pageNum pos:(NSInteger) posNum
{
    return _screenWidth * pageNum + posNum * _width + (posNum + 1) * _hspacing;
}

-(CGFloat) posyWithNum: (NSInteger) posNum
{
    return posNum > 3 ? _height + 40 : 20;
}


@end
