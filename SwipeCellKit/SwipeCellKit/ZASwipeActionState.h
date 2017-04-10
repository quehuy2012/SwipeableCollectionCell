//
//  ZASwipeState.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZASwipeCellOptions.h"

typedef NS_ENUM(NSInteger, ZASwipeState) {
    ZASwipeStateCenter,
    ZASwipeStateLeft,
    ZASwipeStateRight,
    ZASwipeStateAnimatingToCenter
};

@interface ZASwipeActionState : NSObject

@property (nonatomic, assign) ZASwipeState state;
@property (nonatomic, readonly) BOOL isActive;

- (instancetype)initWithOrientation:(ZASwipeActionsOrientation)orientation;
+ (instancetype)center;
+ (instancetype)left;
+ (instancetype)right;
+ (instancetype)animatingToCenter;
+ (instancetype)stateFromOrientation:(ZASwipeActionsOrientation)orientation;
@end
