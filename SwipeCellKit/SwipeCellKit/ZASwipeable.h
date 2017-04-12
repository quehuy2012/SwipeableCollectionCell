//
//  ZASwipeable.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZASwipeExpansionAnimationTimingParameters;
@class ZAActionsViewLayoutContext;
@class ZASwipeActionsView;

typedef NS_ENUM(NSInteger, ZASwipeTransitionStyle) {
    ZASwipeTransitionStyleBorder,
    ZASwipeTransitionStyleDrag,
    ZASwipeTransitionStyleReveal
};

//WARNING: orientation 
typedef NS_ENUM(NSInteger, ZASwipeActionsOrientation) {
    ZASwipeActionsOrientationLeft = -1,
    ZASwipeActionsOrientationRight = 1
};

typedef NS_ENUM(NSInteger, ZASwipeVerticalAligment) {
    ZASwipeVerticalAligmentCenterFirstBaseLine,
    ZASwipeVerticalAligmentCenter
};

typedef NS_ENUM(NSInteger, ZASwipeState) {
    ZASwipeStateCenter,
    ZASwipeStateLeft,
    ZASwipeStateRight,
    ZASwipeStateAnimatingToCenter
};

@protocol ZASwipeExpanding <NSObject>

- (ZASwipeExpansionAnimationTimingParameters *)animationTimingParametersForButtons:(NSArray<UIButton *> *)buttons expanding:(BOOL)expanding;

- (void)actionButton:(UIButton *)button didChange:(BOOL)expanding otherActionButtons:(NSArray<UIButton *> *)otherActionButtons;

@end


@protocol ZASwipeTransitionLayout <NSObject>

- (void)containerView:(UIView *)view didChangeVisibleWidthWithContext:(ZAActionsViewLayoutContext *)context;
- (void)layoutView:(UIView *)view atIndex:(NSInteger)index withContext:(ZAActionsViewLayoutContext *)context;
- (NSArray<NSNumber *> *)visibleWidthsForViewsWithContext:(ZAActionsViewLayoutContext *)context;

@end

@protocol ZASwipeable <NSObject>

@property (nonatomic, readonly) ZASwipeActionsView *actionsView;
@property (nonatomic, readonly) ZASwipeState state;
@property (nonatomic, readonly) CGRect swipeViewFrame;
//- (CGRect)swipeCellFrame;

@end
