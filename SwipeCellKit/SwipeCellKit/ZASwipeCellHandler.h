//
//  ZASwipeGestureHandler.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZASwipeable.h"

@interface ZASwipeCellHandler : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, readonly, weak) UIView<ZASwipeable> *swipeCell;

- (instancetype)initWithCell:(UIView<ZASwipeable> *)cell;

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture;
- (void)handleCellParentPanGesture:(UIPanGestureRecognizer *)gesture;

- (void)reset;
- (void)hideSwipeWithAnimation:(BOOL)animated;
@end
