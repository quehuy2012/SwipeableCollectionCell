//
//  UITableView+SwipeCellKit.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "UITableView+SwipeCellKit.h"
#import "ZASwipeTableViewCell.h"

@implementation UITableView (SwipeCellKit)

- (NSArray<ZASwipeTableViewCell *> *)swipeCells {
    NSMutableArray *cells = [NSMutableArray array];
    
    [self.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull cell, NSUInteger index, BOOL * _Nonnull stop) {
        if ([cell isKindOfClass:[ZASwipeTableViewCell class]]) {
            [cells addObject:cell];
        }
    }];
    
    return cells;
}

- (void)hideSwipeCell {
    for (ZASwipeTableViewCell *swipeCell in [self swipeCells]) {
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
