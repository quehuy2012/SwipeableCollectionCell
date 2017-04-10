//
//  ZASwipeCellOptions.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/30/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeCellOptions.h"

@implementation ZASwipeCellOptions

- (instancetype)init {
    if (self = [super init]) {
        _transitionStyle = ZASwipeTransitionStyleBorder;
        _buttonVerticalAligment = ZASwipeVerticalAligmentCenterFirstBaseLine;
        
        _maximumButtonWidth = 0;
        _minimumButtonWidth = 0;
        _buttonSpacing = 8;
        _buttonPadding = 8;
    }
    return self;
}
@end
