//
//  ZASwipeableCellContext.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeCellContext.h"

@implementation ZASwipeCellContext

- (instancetype)init {
    if (self = [super init]) {
        _state = ZASwipeStateCenter;
        _originalLayoutMargins = UIEdgeInsetsZero;
        _originalCenter = 0;
        _elasticScrollRatio = 0.4;
        _scrollRatio = 1.0;
    }
    return self;
}

@end
