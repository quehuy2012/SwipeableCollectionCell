//
//  ZASwipeExpansionCompleteAnimation.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAFillOption.h"

typedef NS_ENUM(NSInteger, ZACompletionAnimationStyle) {
    ZACompletionAnimationStyleFill,
    ZACompletionAnimationStyleBounce
};

@interface ZACompletionAnimation : NSObject

@property (nonatomic, assign) ZACompletionAnimationStyle animationStyle;

@property (nonatomic, readwrite) ZAFillOption *fillOption;

+ (instancetype)fill:(ZAFillOption *)fillOption;
+ (instancetype)bounce;

@end
