//
//  ZASwipeActionTransitioningContext.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/30/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZASwipeActionTransitioningContext;
/**
 Adopt the `SwipeActionTransitioning` protocol in objects that implement custom appearance of actions during transition.
 */
@protocol ZASwipeActionTransitioning <NSObject>

- (void)didTransitionWithContext:(ZASwipeActionTransitioningContext *)context;

@end

/**
 The `ZASwipeActionTransitioningContext` type provide information relevant to a specific action as transitioning occurs.
 */
@interface ZASwipeActionTransitioningContext : NSObject

@property (nonatomic, readwrite) NSString *actionIdentifier;

/**
 The button that is changing
 */
@property (nonatomic, readonly) UIButton *button;

/**
 The visibility percentage between 0.0 and 1.0
 */
@property (nonatomic, readonly) CGFloat newPercentVisible;

/**
 The visibility percentage between 0.0 and 1.0
 */
@property (nonatomic, readonly) CGFloat oldPercentVisible;

@property (nonatomic, readonly) UIView *wrapperView;

- (instancetype)initWithActionIdentifier:(NSString *)actionIdentifier
                                  button:(UIButton *)button
                       newPercentVisible:(CGFloat)newPercentVisible
                       oldPercentVisible:(CGFloat)oldPercentVisible
                             wrapperView:(UIView *)wrapperView;


/**
 Set the background color behind the action button

 @param color : The background color
 */
- (void)setBackgroundColor:(UIColor *)color;
@end




