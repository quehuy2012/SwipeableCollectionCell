//
//  UICollectionView+SwipeCellKit.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/21/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "UICollectionView+SwipeCellKit.h"
#import <objc/runtime.h>

@implementation UICollectionView (SwipeCellKit)

NSString *const kSwipeCellKitCollectionEditingNotification = @"kSwipeCellKitCollectionEditingNotification";

- (NSArray<UIView<ZASwipeable> *> *)swipeCells {
    NSMutableArray *cells = [NSMutableArray array];
    
    for (UICollectionViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:[ZASwipeCollectionCell class]]) {
            [cells addObject:cell];
        }
    }
    
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

- (BOOL)editing {
    NSNumber *number = objc_getAssociatedObject(self, @selector(editing));
    return [number boolValue];
}

- (void)setEditing:(BOOL)editing {
    NSNumber *number = [NSNumber numberWithBool:editing];
    objc_setAssociatedObject(self, @selector(editing), number, OBJC_ASSOCIATION_RETAIN);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwipeCellKitCollectionEditingNotification object:nil];
}

- (BOOL)dealloced {
    NSNumber *number = objc_getAssociatedObject(self, @selector(dealloced));
    return [number boolValue];
}

- (void)setDealloced:(BOOL)dealloced {
    NSNumber *number = [NSNumber numberWithBool:dealloced];
    objc_setAssociatedObject(self, @selector(dealloced), number, OBJC_ASSOCIATION_RETAIN);
}

- (void)dealloc {
    NSLog(@"Collection dealloc");
    
}

@end
