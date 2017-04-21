//
//  ZASwipeExpansionTrigger.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeExpansionTrigger.h"
#import "ZASwipeActionsView.h"
#import "ZASwipeCellContext.h"

@implementation ZASwipeExpansionTrigger

- (instancetype)initWithTrigger:(ZAExpansionTrigger)trigger threshold:(CGFloat)threshold {
    if (self = [super init]) {
        _trigger = trigger;
        _threshold = threshold;
    }
    return self;
}

- (BOOL)isTriggeredView:(NSObject<ZASwipeable> *)view byGesture:(UIPanGestureRecognizer *)gesture inSuperview:(UIView *)superview {
    if (!view.context.actionsView) {
        return NO;
    }
    
    switch (self.trigger) {
        case ZAExpansionTriggerTouchThreshold: {
            CGFloat location = [gesture locationInView:superview].x;
            CGFloat locationRatio = (view.context.actionsView.orientation == ZASwipeActionsOrientationLeft ? location : superview.bounds.size.width - location) / superview.bounds.size.width;
            return locationRatio > self.threshold;
            break;
        }
        case ZAExpansionTriggerOverscroll:
            return fabs(CGRectGetMinX(view.frame)) > (view.context.actionsView.preferredWidth + self.threshold);
//            return fabs(CGRectGetMinX(view.frame)) > ([view swipeActionView].preferredWidth + self.threshold);

            break;
        default:
            break;
    }
    
    return NO;
}
@end
