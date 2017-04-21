//
//  ZASwipeExpansionStyle.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeExpansionStyle.h"
#import "ZASwipeCellContext.h"
#import "ZASwipeActionsView.h"
#import "ZASwipeExpansionTrigger.h"
#import "ZASwipeExpansionTarget.h"
#import "ZACompletionAnimation.h"

@implementation ZASwipeExpansionStyle

- (instancetype)initWithTarget:(ZASwipeExpansionTarget *)target {
    return [self initWithTarget:target additionalTriggers:@[]];
}

- (instancetype)initWithTarget:(ZASwipeExpansionTarget *)target
            additionalTriggers:(NSArray<ZASwipeExpansionTrigger *> *)additionalTrigger {
    return [self initWithTarget:target additionalTriggers:additionalTrigger elasticOverscroll:NO completionAnimation:[ZACompletionAnimation bounce]];
}

- (instancetype)initWithTarget:(ZASwipeExpansionTarget *)target
            additionalTriggers:(NSArray<ZASwipeExpansionTrigger *> *)additionalTrigger
             elasticOverscroll:(BOOL)elasticOverscroll
           completionAnimation:(ZACompletionAnimation *)completionAnimation {
    if (self = [super init]) {
        _target = target;
        _addtionalTriggers = additionalTrigger;
        _elasticOverscroll = elasticOverscroll;
        _completionAnimation = completionAnimation;
        _minimumTargetOverscroll = 20;
    }
    return self;
}

- (BOOL)shouldExpandView:(UIView<ZASwipeable> *)view ByGesture:(UIPanGestureRecognizer *)gesture inSuperView:(UIView *)superview {
    if (!view.context.actionsView) {
        return NO;
    }
    
    CGFloat viewFrameMinX = CGRectGetMinX([view frame]);

    //NSLog(@"Min X Frame: %f", fabs(viewFrameMinX));
    if (fabs(viewFrameMinX) < view.context.actionsView.preferredWidth) {
        return NO;
    }
    
    if (fabs(viewFrameMinX) >= [self.target offsetForView:view inSuperview:superview withMinimumOverscroll:self.minimumTargetOverscroll]) {
        return YES;
    }
    
    for (ZASwipeExpansionTrigger *trigger in self.addtionalTriggers) {
        if ([trigger isTriggeredView:view byGesture:gesture inSuperview:superview]) {
            return YES;
        }
    }
    
    return NO;
}

- (CGFloat)targetOffsetForView:(id<ZASwipeable>)view inSuperview:(UIView *)superview {
    return [self.target offsetForView:view inSuperview:superview withMinimumOverscroll:self.minimumTargetOverscroll];
}

#pragma mark - Convenient Factoty
+ (instancetype)selection {
    ZASwipeExpansionTarget *target = [[ZASwipeExpansionTarget alloc] initWithTarget:ZAExpansionTargetPercentage threshold:0.5];
    ZACompletionAnimation *completionanimation = [ZACompletionAnimation bounce];
    
    return [[ZASwipeExpansionStyle alloc] initWithTarget:target additionalTriggers:@[] elasticOverscroll:YES completionAnimation:completionanimation];
}

+ (instancetype)fill {
    ZASwipeExpansionTarget *target = [[ZASwipeExpansionTarget alloc] initWithTarget:ZAExpansionTargetEdgeInset threshold:30];
    ZASwipeExpansionTrigger *trigger = [[ZASwipeExpansionTrigger alloc] initWithTrigger:ZAExpansionTriggerOverscroll threshold:30];
    ZACompletionAnimation *completionAnimation = [ZACompletionAnimation fill:[ZAFillOption manualWithTiming:ZAHandlerInvocationTimingAfter]];
    
    return [[ZASwipeExpansionStyle alloc] initWithTarget:target additionalTriggers:@[trigger] elasticOverscroll:NO completionAnimation:completionAnimation];
}

+ (instancetype)destructive {
    return [ZASwipeExpansionStyle destructiveWithTiming:ZAHandlerInvocationTimingWith automaticallyDelete:YES];
}

+ (instancetype)destructiveAfterFill {
    return [ZASwipeExpansionStyle destructiveWithTiming:ZAHandlerInvocationTimingAfter automaticallyDelete:YES];
}

+ (instancetype)destructiveWithTiming:(ZAHandlerInvocationTiming)timing automaticallyDelete:(BOOL)automaticallyDelete {
    ZASwipeExpansionTarget *target = [[ZASwipeExpansionTarget alloc] initWithTarget:ZAExpansionTargetEdgeInset threshold:30];
    ZASwipeExpansionTrigger *touchTrigger = [[ZASwipeExpansionTrigger alloc] initWithTrigger:ZAExpansionTriggerTouchThreshold threshold:0.8];
    ZACompletionAnimation *completionAnimation;
    
    if (automaticallyDelete) {
        completionAnimation = [ZACompletionAnimation fill:[ZAFillOption automaticWithStyle:ZAExpansionFulfillmentStyleDelete timing:timing]];
    }
    else {
        completionAnimation = [ZACompletionAnimation fill:[ZAFillOption manualWithTiming:timing]];
    }
    
    return [[ZASwipeExpansionStyle alloc] initWithTarget:target additionalTriggers:@[touchTrigger] elasticOverscroll:NO completionAnimation:completionAnimation];
}

@end
