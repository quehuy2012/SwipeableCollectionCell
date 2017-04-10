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

@property (nonatomic, assign) double duration;
@property (nonatomic, assign) double interButtonDelay;

@property (nonatomic, assign) CGFloat scale;

- (instancetype)initWithDuration:(double)duration interButtonDelay:(double)interButtonDelay scale:(CGFloat)scale;


+ (instancetype)expansion;
@end
