//
//  ZAScaleTransition.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZAScaleTransition.h"
#import "ZASwipeActionTransitioningContext.h"

@implementation ZAScaleTransition

- (instancetype)init {
    return [self initWithDuration:0.15 initialScale:0.8 threshold:0.5];
}

- (instancetype)initWithDuration:(double)duration initialScale:(CGFloat)initialScale threshold:(CGFloat)threshold {
    if (self = [super init]) {
        _duration = duration;
        _initialScale = initialScale;
        _threshold = threshold;
    }
    return self;
}

+ (instancetype)defaultTransition {
    return [[ZAScaleTransition alloc] init];
}

- (void)didTransitionWithContext:(ZASwipeActionTransitioningContext *)context {
    if (context.oldPercentVisible == 0) {
        context.button.transform = CGAffineTransformMakeScale(self.initialScale, self.initialScale);
    }
    
    if (context.oldPercentVisible < self.threshold && context.newPercentVisible >= self.threshold) {
        [UIView animateWithDuration:self.duration animations:^{
            context.button.transform = CGAffineTransformIdentity;
        }];
    }
    else if (context.oldPercentVisible >= self.threshold && context.newPercentVisible <= self.threshold) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:self.duration animations:^{
            context.button.transform = CGAffineTransformMakeScale(weakSelf.initialScale, weakSelf.initialScale);
        }];
    }
}


@end
