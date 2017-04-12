//
//  ZADragTransitionLayout.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/12/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZADragTransitionLayout.h"
#import "ZAActionsViewLayoutContext.h"

@implementation ZADragTransitionLayout

- (void)containerView:(UIView *)view didChangeVisibleWidthWithContext:(ZAActionsViewLayoutContext *)context {
    CGRect bounds = view.bounds;
    bounds.origin.x = (context.contentSize.width - context.visibleWidth) * context.orientation;
    view.bounds = bounds;
}

- (void)layoutView:(UIView *)view atIndex:(NSInteger)index withContext:(ZAActionsViewLayoutContext *)context {
    CGRect frame = view.frame;
    frame.origin.x =  (CGFloat)index * context.minimumButtonWidth * context.orientation;
    view.frame = frame;
}

- (NSArray<NSNumber *> *)visibleWidthsForViewsWithContext:(ZAActionsViewLayoutContext *)context {
    NSMutableArray<NSNumber *> *widths = [NSMutableArray array];
    for (NSInteger i=0; i < context.numberOfActions; i++) {
        CGFloat width = MAX(0, MIN(context.minimumButtonWidth, context.visibleWidth - ((CGFloat)i * context.minimumButtonWidth)));
        [widths addObject:[NSNumber numberWithDouble:width]];
    }
    return widths;
}

@end
