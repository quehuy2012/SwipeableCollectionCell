//
//  ZASwipeExpansionCompleteAnimation.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZACompletionAnimation.h"

@implementation ZACompletionAnimation

- (instancetype)initWithAnimationStyle:(ZACompletionAnimationStyle)animationStyle
                                option:(ZAFillOption *)option {
    if (self = [super init]) {
        _animationStyle = animationStyle;
        _fillOption = option;
    }
    return self;
}

+ (instancetype)fill:(ZAFillOption *)fillOption {
    return [[ZACompletionAnimation alloc] initWithAnimationStyle:ZACompletionAnimationStyleFill option:fillOption];
}

+ (instancetype)bounce {
    return [[ZACompletionAnimation alloc] initWithAnimationStyle:ZACompletionAnimationStyleBounce option:nil];
}

#pragma mark - Equality
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[ZACompletionAnimation class]]) {
        return NO;
    }
    
    ZACompletionAnimation *other = (ZACompletionAnimation *)object;
    return self.animationStyle == other.animationStyle;
}

@end
