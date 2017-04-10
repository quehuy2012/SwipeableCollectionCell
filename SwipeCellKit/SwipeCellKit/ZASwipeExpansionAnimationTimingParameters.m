//
//  ZASwipeExpansionAnimationTimingParameters.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeExpansionAnimationTimingParameters.h"

@implementation ZASwipeExpansionAnimationTimingParameters

- (instancetype)init {
    return [self initWithDuration:0.6];
}

- (instancetype)initWithDuration:(double)duration {
    return [self initWithDuration:duration delay:0];
}

- (instancetype)initWithDuration:(double)duration delay:(double)delay {
    if (self = [super init]) {
        _duration = duration;
        _delay = delay;
    }
    return self;
}

+ (instancetype)defaultTimingParameters {
    return [[ZASwipeExpansionAnimationTimingParameters alloc] init];
}

@end
