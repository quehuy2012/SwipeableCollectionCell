//
//  ZAScaleTransition.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZASwipeActionTransitioningContext.h"

@interface ZAScaleTransition : NSObject <ZASwipeActionTransitioning>

@property (nonatomic, readonly) double duration;
@property (nonatomic, readonly) CGFloat initialScale;
@property (nonatomic, readonly) CGFloat threshold;

- (instancetype)initWithDuration:(double)duration initialScale:(CGFloat)initialScale threshold:(CGFloat)threshold;

+ (instancetype)defaultTransition;
@end
