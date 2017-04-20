//
//  UITableView+SwipeCellKit.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "UITableView+SwipeCellKit.h"
#import "ZASwipeTableViewCell.h"
#import "ZASwipeable.h"

@implementation UITableView (SwipeCellKit)

- (NSArray<UIView<ZASwipeable> *> *)swipeCells {
    NSMutableArray *cells = [NSMutableArray array];
    
    [self.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull cell, NSUInteger index, BOOL * _Nonnull stop) {
        if ([cell conformsToProtocol:@protocol(ZASwipeable)]) {
            [cells addObject:cell];
        }
    }];
    return cells;
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

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self deselectRowAtIndexPath:indexPath animated:animated];
}

- (NSIndexPath *)indexPathsForSelectedItems {
    return [self indexPathForSelectedRow];
}




@end
