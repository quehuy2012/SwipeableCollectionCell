//
//  ZASwippableCell.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/28/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZASwippableCell;

typedef NS_ENUM(NSUInteger, ZASwipeDirection) {
    ZASwipeDirectionLeftToRight,
    ZASwipeDirectionRightToLeft
};

typedef NS_ENUM(NSUInteger, ZASwippableCellState) {
    ZASwippableCellStateOpen,
    ZASwippableCellStatePartiallyOpen,
    ZASwippableCellStateClose
};


@protocol ZASwippableCellDelegate <NSObject>

/**
 Swippable trigger this method when utility buttons is change state from openning to closing or vice versa
 @param cell the swippable cell that channing state
 @param state the current state of cell
 */
- (void)swippableCell:(ZASwippableCell *)cell didScrollToState:(ZASwippableCellState)state;

- (void)swippableCell:(ZASwippableCell *)cell didTriggerRightUtilityButtonsAtIndex:(NSInteger)index;

@end


@interface ZASwippableCell : UICollectionViewCell

/**
 The buttons that will be shown when the cell swipped
 */
@property (nonatomic, readwrite) NSArray<UIButton *> *utilityButtons;
@property (nonatomic, readwrite) UIView *topContentView;

@property (nonatomic, readwrite, weak) id<ZASwippableCellDelegate> utilityButtonDelgate;

- (void)hideSwipeButtonAnimated:(BOOL)animated;
- (void)showSwipeButtonAnimated:(BOOL)animated;
@end
