//
//  ZASwipeExpansionAnimationTimingParameters.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Specifies timing infomation for the overall expansion animation
 */
@interface ZASwipeExpansionAnimationTimingParameters : NSObject

/**
 The duration of the expansion animation
 */
@property (nonatomic, readwrite) double duration;

/**
 The delay before starting th expansion animation
 */
@property (nonatomic, readwrite) double delay;

- (instancetype)init;
- (instancetype)initWithDuration:(double)duration;
- (instancetype)initWithDuration:(double)duration delay:(double)delay;

+ (instancetype)defaultTimingParameters;

@end
