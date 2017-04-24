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
@class ZASwipeCellContext;
@class ZASwipeActionsView;
@class ZASwipeAction;
@class ZASwipeCellOptions;
@class ZASwipeTableViewCell;

@protocol ZASwipeable;


typedef NS_ENUM(NSInteger, ZASwipeTransitionStyle) {
    ZASwipeTransitionStyleBorder,
    ZASwipeTransitionStyleDrag,
    ZASwipeTransitionStyleReveal
};

typedef NS_ENUM(NSInteger, ZASwipeActionsOrientation) {
    ZASwipeActionsOrientationLeft = -1,
    ZASwipeActionsOrientationRight = 1
};

typedef NS_ENUM(NSInteger, ZASwipeVerticalAligment) {
    ZASwipeVerticalAligmentCenterFirstBaseLine,
    ZASwipeVerticalAligmentCenter
};

typedef NS_ENUM(NSInteger, ZASwipeState) {
    ZASwipeStateCenter = 0,
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


@protocol ZASwipeCellParentViewProtocol <NSObject>

@property(nonatomic) BOOL editing;

@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly) NSArray<UIView<ZASwipeable> *> *swipeCells;
@property (nonatomic, readonly) NSArray<NSIndexPath *> *indexPathsForSelectedItems;

- (NSIndexPath *)indexPathForCell:(UIView<ZASwipeable> *)cell;
- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)setGestureEnabled:(BOOL)enabled;
- (void)hideSwipeCell;

@end



@protocol ZASwipeViewCellDelegate <NSObject>

/**
 Asks the delegate for the actions to dispaly in response to a swipe in the specified row.
 
 @param view The table view object which owns the cell requesting this information
 @param indexPath The index path of the row
 @param orientation The side of cell requesting this information
 @return An array of ZASwipeAction objects representing the actions for the row
 */
- (NSArray<ZASwipeAction *> *)view:(UIView<ZASwipeCellParentViewProtocol> *)view
           editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
                         forOrientation:(ZASwipeActionsOrientation)orientation;

/**
 Ask the delgate for display options to be used while presenting the action buttons
 
 @param view The table view object which owsn the cell requesting this information
 @param indexPath The index path of the row
 @param orientation The side of the cell requesting this information
 @return A ZASwipeCellOptions instance which configures the behavior of the action buttons
 */
- (ZASwipeCellOptions *)view:(UIView<ZASwipeCellParentViewProtocol> *)view
editActionsOptionsForRowAtIndexPath:(NSIndexPath *)indexPath
                   forOrientation:(ZASwipeActionsOrientation)orientation;


/**
 Tells the delegate that collectionView is about to go into editing mode
 */
- (void)view:(UIView<ZASwipeCellParentViewProtocol> *)view willBeginEdittingRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation;

/**
 Tell the delegate that the collection view has left editting mode
 */
- (void)view:(UIView<ZASwipeCellParentViewProtocol> *)view didEndEdittingRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation;

@end



@protocol ZASwipeable <NSObject>

@property (nonatomic, readwrite, weak) id<ZASwipeViewCellDelegate> delegate;
@property (nonatomic, readwrite, weak) UIView<ZASwipeCellParentViewProtocol> *parentView;
@property (nonatomic, readwrite) CGRect frame;
@property (nonatomic, readwrite) ZASwipeCellContext *context;

//- (CGRect)swipeCellFrame;
//- (ZASwipeableCellContext *)context;
- (void)hideSwipeWithAnimation:(BOOL)animated;

@end
