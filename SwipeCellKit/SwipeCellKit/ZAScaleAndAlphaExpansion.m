//
//  ZAScaleAndAlphaExpansion.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZAScaleAndAlphaExpansion.h"
#import "ZASwipeExpansionAnimationTimingParameters.h"

@implementation ZAScaleAndAlphaExpansion

- (instancetype)init {
    return [self initWithDuration:0.15 interButtonDelay:0.1 scale:0.8];
}

- (instancetype)initWithDuration:(double)duration interButtonDelay:(double)interButtonDelay scale:(CGFloat)scale {
    if (self = [super init]) {
        _duration = duration;
        _interButtonDelay = interButtonDelay;
        _scale = scale;
    }
    return self;
}

+ (instancetype)expansion {
    return [[ZAScaleAndAlphaExpansion alloc] init];
}

#pragma mark - ZAExpanding
- (ZASwipeExpansionAnimationTimingParameters *)animationTimingParametersForButtons:(NSArray<UIButton *> *)buttons expanding:(BOOL)expanding {
    ZASwipeExpansionAnimationTimingParameters *timingParameters = [ZASwipeExpansionAnimationTimingParameters defaultTimingParameters];
    timingParameters.delay = expanding ? self.interButtonDelay : 0;
    return timingParameters;
}

- (void)actionButton:(UIButton *)button didChange:(BOOL)expanding otherActionButtons:(NSArray<UIButton *> *)otherActionButtons {
    NSArray<UIButton *> *buttons = expanding ? otherActionButtons : [[otherActionButtons reverseObjectEnumerator] allObjects];
    
    __weak typeof(self) weakSelf = self;
    [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:weakSelf.duration delay:weakSelf.interButtonDelay * (expanding ? idx : idx +1)  options:UIViewAnimationOptionTransitionNone animations:^{
            obj.transform = expanding ? CGAffineTransformMakeScale(weakSelf.scale, weakSelf.scale) : CGAffineTransformIdentity;
            obj.alpha = expanding ? 0.0 : 1.0;
        } completion:nil];
    }];
}


@end
