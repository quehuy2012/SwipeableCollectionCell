//
//  ZASwipeState.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeActionState.h"

@implementation ZASwipeActionState

- (instancetype)initWithState:(ZASwipeState)state {
    if (self = [super init]) {
        _state = state;
    }
    return self;
}

- (instancetype)initWithOrientation:(ZASwipeActionsOrientation)orientation {
    if (self = [super init]) {
        _state = orientation == ZASwipeStateLeft ? ZASwipeStateLeft : ZASwipeStateRight;
    }
    return self;
}

- (BOOL)isActive {
    return self.state != ZASwipeStateCenter;
}

+ (instancetype)center {
    return [[self alloc] initWithState:ZASwipeStateCenter];
}

+ (instancetype)left {
    return [[self alloc] initWithState:ZASwipeStateLeft];
}

+ (instancetype)right {
    return [[self alloc] initWithState:ZASwipeStateRight];
}

+ (instancetype)animatingToCenter {
    return [[self alloc] initWithState:ZASwipeStateAnimatingToCenter];
}

+ (instancetype)stateFromOrientation:(ZASwipeActionsOrientation)orientation {
    return [[self alloc] initWithOrientation:orientation];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ZASwipeActionState class]]) {
        return NO;
    }
    
    ZASwipeActionState *state = (ZASwipeActionState *)object;
    
    return self.state == state.state;
    
}
@end
