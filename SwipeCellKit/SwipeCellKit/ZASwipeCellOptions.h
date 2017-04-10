//
//  ZASwipeCellOptions.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/30/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZASwipeable.h"

@class ZASwipeExpansionStyle;

/**
 The `ZASwipeTableOptions` provides options for transistion and expansion behavior
 for swiped cell
 */
@interface ZASwipeCellOptions : NSObject

/**
 The transistion style of how the action buttons exposed during the swipe
 */
@property (nonatomic, readwrite) ZASwipeTransitionStyle transitionStyle;

/**
 The expansion style when the cell is swiped past a defined threshold
 */
@property (nonatomic, readwrite) ZASwipeExpansionStyle *expansionStyle;

/**
 The vertical aligment mode used for when a button image and title are present
 */
@property (nonatomic, readwrite) ZASwipeVerticalAligment buttonVerticalAligment;

@property (nonatomic, readwrite) id<ZASwipeExpanding> expansionDelegate;

@property (nonatomic, readwrite) UIColor *backgroundColor;

@property (nonatomic, readwrite) CGFloat maximumButtonWidth;
@property (nonatomic, readwrite) CGFloat minimumButtonWidth;

/**
 The amount of space, in points, between the border and the button image
 */
@property (nonatomic, readwrite) CGFloat buttonPadding;

/**
 The amount of space, in points, between the button image and the button title
 */
@property (nonatomic, readwrite) CGFloat buttonSpacing;

@end
