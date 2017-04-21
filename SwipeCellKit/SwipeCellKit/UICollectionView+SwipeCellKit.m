//
//  UICollectionView+SwipeCellKit.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/21/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "UICollectionView+SwipeCellKit.h"

@implementation UICollectionView (SwipeCellKit)

- (NSArray<UIView<ZASwipeable> *> *)swipeCells {
    NSMutableArray *cells = [NSMutableArray array];
    
    [self.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull cell, NSUInteger index, BOOL * _Nonnull stop) {
        if ([cell conformsToProtocol:@protocol(ZASwipeable)]) {
            [cells addObject:cell];
        }
    }];
    return [cells copy];
}

- (void)hideSwipeCell {
    for (UITableViewCell<ZASwipeable> *swipeCell in [self swipeCells]) {
        [swipeCell hideSwipeWithAnimation:YES];
    }
}

- (void)setGestureEnabled:(BOOL)enabled {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if (gesture != self.panGestureRecognizer) {
            [gesture setEnabled:enabled];
        }
    }
}

@end
