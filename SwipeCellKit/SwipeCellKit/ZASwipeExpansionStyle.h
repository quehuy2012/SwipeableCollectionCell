//
//  ZASwipeExpansionStyle.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZASwipeable.h"
#import "ZACompletionAnimation.h"

@class ZASwipeExpansionTarget;
@class ZASwipeExpansionTrigger;

/**
 Describes the expansion behavior when the cell is swiped past threshold
 */
@interface ZASwipeExpansionStyle : NSObject


/**
 The relative target expansion threshold
 */
@property (nonatomic, readonly) ZASwipeExpansionTarget *target;

/**
 The addtional triggers for determinig if expansion should occur
 */
@property (nonatomic, readonly) NSArray<ZASwipeExpansionTrigger *> *addtionalTriggers;

/**
 Specifies if button should expand to fully fill overscroll or expand at percentage relative to the overscroll
 */
@property (nonatomic, assign) BOOL elasticOverscroll;

@property (nonatomic, assign) CGFloat minimumTargetOverscroll;

@property (nonatomic, readonly) ZACompletionAnimation *completionAnimation;

- (instancetype)initWithTarget:(ZASwipeExpansionTarget *)target;

- (instancetype)initWithTarget:(ZASwipeExpansionTarget *)target
            additionalTriggers:(NSArray<ZASwipeExpansionTrigger *> *)additionalTrigger;

- (instancetype)initWithTarget:(ZASwipeExpansionTarget *)target
            additionalTriggers:(NSArray<ZASwipeExpansionTrigger *> *)additionalTrigger
             elasticOverscroll:(BOOL)elasticOverscroll
           completionAnimation:(ZACompletionAnimation *)completionAnimation;

//TODO: code shouldExpand and targetOffset method after done Swipeable


/**
 The default action performs a slection-type behavior. The cell bounces back to its unopened state upon slection

 @return The new `SwipeExpansionStyle` instance
 */
+ (instancetype)selection;

/**
 The default action performs a destructive behavior. The cell is removed from the table view in an animated fashion.

 @return The new `SwipeExpansionStyle` instance
 */
+ (instancetype)destructive;

/**
 The default action performs a destructive behavior after the fill animation completes. The cell is removed from the table view in an animated fashion.

 @return The new `SwipeExpansionStyle` instance
 */
+ (instancetype)destructiveAfterFill;

/**
 The default action performs a fill behavior.

 @note the action handle must call [SwipeAction fulFillWithStyle:] to resolve the fill expansion
 
 @return The new `SwipeExpansionStyle` instance
 */
+ (instancetype)fill;

/**
 Returns a `SwipeExpansionStyle` instance for the default action which peforms destructive behavior with the specified options.

 @param timing The timing which specifies when the action handler will be invoked with respect to the fill animation
 @param automaticallyDelete Sepecifies if item deletion shoul be performed automatically
 @return The new `SwipeExpansionStyle` instance
 */
+ (instancetype)destructiveWithTiming:(ZAHandlerInvocationTiming)timing
                  automaticallyDelete:(BOOL)automaticallyDelete;


- (BOOL)shouldExpandView:(id<ZASwipeable>)view ByGesture:(UIPanGestureRecognizer *)gesture inSuperView:(UIView *)superview;

- (CGFloat)targetOffsetForView:(id<ZASwipeable>)view inSuperview:(UIView *)superview;
@end
