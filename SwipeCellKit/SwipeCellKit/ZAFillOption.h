//
//  ZAFillOption.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZASwipeAction.h"

/**
 Describes when the action handler will be invoked with respect to the fill animation

 - ZAHandlerInvocationTimingWith: the action handler is invoked with the fill animation
 - ZAHandlerInvocationTimingAfter: the action handler is invoked adter the fll animation completes
 */
typedef NS_ENUM(NSInteger, ZAHandlerInvocationTiming) {
    ZAHandlerInvocationTimingNone,
    ZAHandlerInvocationTimingWith,
    ZAHandlerInvocationTimingAfter,
};

@interface ZAFillOption : NSObject

@property (nonatomic, readonly) ZAHandlerInvocationTiming timming;

/**
 the fulfillment style describing how expansion should be resolved once the action has been fulfilled
 */
@property (nonatomic, readonly) ZAExpansionFulfillmentStyle autoFulfillmentStyle;


+ (instancetype)automaticWithStyle:(ZAExpansionFulfillmentStyle)style
                            timing:(ZAHandlerInvocationTiming)timing;

+ (instancetype)manualWithTiming:(ZAHandlerInvocationTiming)timing;

@end
