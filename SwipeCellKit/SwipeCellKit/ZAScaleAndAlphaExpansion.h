//
//  ZAScaleAndAlphaExpansion.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZASwipeable.h"

@interface ZAScaleAndAlphaExpansion : NSObject <ZASwipeExpanding>

@property (nonatomic, readonly) double duration;
@property (nonatomic, readonly) double interButtonDelay;

@property (nonatomic, readonly) CGFloat scale;

- (instancetype)initWithDuration:(double)duration interButtonDelay:(double)interButtonDelay scale:(CGFloat)scale;

+ (instancetype)expansion;
@end
