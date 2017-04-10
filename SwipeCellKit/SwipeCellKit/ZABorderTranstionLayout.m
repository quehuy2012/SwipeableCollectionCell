//
//  ZABorderTranstionLayout.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/4/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZABorderTranstionLayout.h"
#import "ZAActionsViewLayoutContext.h"

@implementation ZABorderTranstionLayout

- (void)containerView:(UIView *)view didChangeVisibleWidthWithContext:(ZAActionsViewLayoutContext *)context {
    
}

- (void)layoutView:(UIView *)view atIndex:(NSInteger)index withContext:(ZAActionsViewLayoutContext *)context {
    CGFloat diff = context.visibleWidth - context.contentSize.width;
    CGRect frame = view.frame;
    frame.origin.x = ((CGFloat)index * context.contentSize.width / (CGFloat)context.numberOfActions + diff) * context.orientation;
    view.frame = frame;
}

-(NSArray<NSNumber *> *)visibleWidthsForViewsWithContext:(ZAActionsViewLayoutContext *)context {
    CGFloat diff = context.visibleWidth - context.contentSize.width;
    CGFloat visibleWidth = context.contentSize.width / (CGFloat)context.numberOfActions + diff;
    
    NSMutableArray *widths = [NSMutableArray array];
    for (NSInteger i = 0; i < context.numberOfActions; i++) {
        [widths addObject:@(visibleWidth)];
    }
    return widths;
}


@end
