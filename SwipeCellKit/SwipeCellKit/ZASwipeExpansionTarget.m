//
//  ZASwipeExpansionTarget.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeExpansionTarget.h"
#import "ZASwipeActionsView.h"

@implementation ZASwipeExpansionTarget

- (instancetype)initWithTarget:(ZAExpansionTarget)target threshold:(CGFloat)threshold {
    if (self = [super init]) {
        _target = target;
        _threshold = threshold;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    ZASwipeExpansionTarget *other = (ZASwipeExpansionTarget *)object;
    
    return self.target == other.target && self.threshold == other.threshold;
}

- (CGFloat)offsetForView:(NSObject<ZASwipeable> *)view inSuperview:(UIView *)superview withMinimumOverscroll:(CGFloat)minimumOverscroll {
    if (!view.actionsView) {
        return CGFLOAT_MAX;
    }
    
    CGFloat offset;
    switch (self.target) {
        case ZAExpansionTargetEdgeInset:
            offset = superview.bounds.size.width - self.threshold;
            break;
        case ZAExpansionTargetPercentage:
            offset = superview.bounds.size.width * self.threshold;
            break;
        default:
            break;
    }
    
    return MAX(view.actionsView.preferredWidth + minimumOverscroll, offset);
}

@end
