//
//  ZASwipeActionButtonWrapperView.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/4/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASwipeable.h"

@class ZASwipeAction;

@interface ZASwipeActionButtonWrapperView : UIView

@property (nonatomic, readonly) CGRect contentRect;

- (instancetype)initWithFrame:(CGRect)frame
                       action:(ZASwipeAction *)action
                  orientation:(ZASwipeActionsOrientation)orientation
                 contentWidth:(CGFloat)contentWidth;

- (void)configureBackgroundColorWithAction:(ZASwipeAction *)action;

@end
