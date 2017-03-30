//
//  ZASwipeActionTransitioningContext.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/30/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeActionTransitioningContext.h"

@implementation ZASwipeActionTransitioningContext

- (instancetype)initWithActionIdentifier:(NSString *)actionIdentifier
                                  button:(UIButton *)button
                       newPercentVisible:(CGFloat)newPercentVisible
                       oldPercentVisible:(CGFloat)oldPercentVisible
                             wrapperView:(UIView *)wrapperView {
    if (self = [super init]) {
        _actionIdentifier = actionIdentifier;
        _button = button;
        _newPercentVisible = newPercentVisible;
        _oldPercentVisible = oldPercentVisible;
        _wrapperView = wrapperView;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)color {
    _wrapperView.backgroundColor = color;
}

@end
