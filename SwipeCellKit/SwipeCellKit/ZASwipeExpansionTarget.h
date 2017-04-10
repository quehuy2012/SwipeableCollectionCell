//
//  ZASwipeExpansionTarget.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZASwipeable.h"

typedef NS_ENUM(NSInteger, ZAExpansionTarget) {
    ZAExpansionTargetPercentage,
    ZAExpansionTargetEdgeInset
};

@interface ZASwipeExpansionTarget : NSObject

@property (nonatomic, assign) ZAExpansionTarget target;
@property (nonatomic, assign) CGFloat threshold;

- (instancetype)initWithTarget:(ZAExpansionTarget)target
                     threshold:(CGFloat)threshold;

// TODO: offset
- (CGFloat)offsetForView:(NSObject<ZASwipeable> *)view inSuperview:(UIView *)superview withMinimumOverscroll:(CGFloat)minimumOverscroll;
@end
