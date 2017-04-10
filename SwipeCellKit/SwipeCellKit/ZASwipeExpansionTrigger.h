//
//  ZASwipeExpansionTrigger.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZASwipeable.h"

/**
 Describes additional triggers to useful for determining if expansion should occur
 
 - ZAExpansionTriggerTouchThreshold: The trigger is specified by a touch occuring past the supplied percentage in the superview.
 - ZAExpansionTriggerOverscroll: The trigger is specified by the distance in points past the fully exposed action view.
 */
typedef NS_ENUM(NSInteger, ZAExpansionTrigger) {
    ZAExpansionTriggerTouchThreshold,
    ZAExpansionTriggerOverscroll
};


/**
 Describes additional triggers for determining if epansion should occur.
 */
@interface ZASwipeExpansionTrigger : NSObject

@property (nonatomic, assign) ZAExpansionTrigger trigger;

@property (nonatomic, assign) CGFloat threshold;

- (instancetype)initWithTrigger:(ZAExpansionTrigger)trigger
                      threshold:(CGFloat)threshold;

// TODO: isTriggered
- (BOOL)isTriggeredView:(NSObject<ZASwipeable> *)view byGesture:(UIPanGestureRecognizer *)gesture inSuperview:(UIView *)superview;

@end
