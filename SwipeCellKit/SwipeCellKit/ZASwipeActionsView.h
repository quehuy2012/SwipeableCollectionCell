//
//  ZASwipeActionView.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ZASwipeable.h"

@class ZASwipeActionsView;
@class ZASwipeAction;
@class ZASwipeActionButton;
@class ZASwipeCellOptions;
@class ZAActionsViewLayoutContext;

@protocol ZASwipeTransitionLayout;

@protocol ZASwipeActionsViewDelegate <NSObject>

- (void)swipeActionView:(ZASwipeActionsView *)swipeActionsView didSelectAction:(ZASwipeAction *)action;

@end

@interface ZASwipeActionsView : UIView

@property (nonatomic, readwrite, weak) id<ZASwipeActionsViewDelegate> delegate;

@property (nonatomic, readonly) id<ZASwipeTransitionLayout> transitionLayout;
@property (nonatomic, readwrite) ZAActionsViewLayoutContext *layoutContext;

@property (nonatomic, readonly) id<ZASwipeExpanding> expansionDelegate;

@property (nonatomic, readonly) ZASwipeActionsOrientation orientation;
@property (nonatomic, readonly) NSArray<ZASwipeAction *> *actions;
@property (nonatomic, readonly) ZASwipeCellOptions *options;

@property (nonatomic, readwrite) NSArray<ZASwipeActionButton *> *buttons;

@property (nonatomic, readwrite) CGFloat minimumButtonWidth;
@property (nonatomic, readonly) CGFloat maximumImageHeight;
@property (nonatomic, readwrite) CGFloat visibleWidth;
@property (nonatomic, readonly) CGFloat preferredWidth;
@property (nonatomic, readwrite) CGSize contentSize;

@property (nonatomic, readwrite, getter=isExpanded) BOOL expanded;

@property (nonatomic, readwrite) ZASwipeAction *expandableAction;

- (instancetype)initWithMaxSize:(CGSize)maxSize
                         option:(ZASwipeCellOptions *)options
                    orientation:(ZASwipeActionsOrientation)orientation
                        actions:(NSArray<ZASwipeAction *> *)actions;

- (NSArray<ZASwipeActionButton *> *)addButtonsForActions:(NSArray<ZASwipeAction *> *)actions
                                         withMaximumSize:(CGSize)size;

- (void)actionTapped:(ZASwipeActionButton *)button;
- (UIEdgeInsets)buttonEdgeInsetsFromOptions:(ZASwipeCellOptions *)options;
- (void)notifyVisibleWidthChangedFromOldWidths:(NSArray<NSNumber *> *)oldWidths to:(NSArray<NSNumber *>*)newWidths;

- (void)notifyExpandsionChanged:(BOOL)expanded;

@end
