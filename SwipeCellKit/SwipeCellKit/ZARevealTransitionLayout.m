//
//  ZARevealTransitionLayout.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/12/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZARevealTransitionLayout.h"
#import "ZAActionsViewLayoutContext.h"

@implementation ZARevealTransitionLayout

- (void)containerView:(UIView *)view didChangeVisibleWidthWithContext:(ZAActionsViewLayoutContext *)context {
    CGFloat width = context.minimumButtonWidth * (CGFloat)context.numberOfActions;
    CGRect bounds = view.bounds;
    bounds.origin.x = (width - context.visibleWidth) * context.orientation;
    view.bounds = bounds;
}

- (NSArray<NSNumber *> *)visibleWidthsForViewsWithContext:(ZAActionsViewLayoutContext *)context {
    return [[[super visibleWidthsForViewsWithContext:context] reverseObjectEnumerator] allObjects];
}

@end
