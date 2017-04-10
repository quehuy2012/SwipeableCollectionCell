//
//  ZASwipeActionButtonWrapperView.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/4/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeActionButtonWrapperView.h"
#import "ZASwipeAction.h"

@implementation ZASwipeActionButtonWrapperView

- (instancetype)initWithFrame:(CGRect)frame
                       action:(ZASwipeAction *)action
                  orientation:(ZASwipeActionsOrientation)orientation
                 contentWidth:(CGFloat)contentWidth {
    if (self = [super initWithFrame:frame]) {
        switch (orientation) {
            case ZASwipeActionsOrientationLeft:
                _contentRect = CGRectMake(frame.size.width - contentWidth, 0, contentWidth, frame.size.height);
                break;
            case ZASwipeActionsOrientationRight:
                _contentRect = CGRectMake(0, 0, contentWidth, frame.size.height);
                break;
            default:
                _contentRect = CGRectMake(0, 0, contentWidth, frame.size.height);
                break;
        }
        
        [self configureBackgroundColorWithAction:action];
    }
    return self;
}

- (void)configureBackgroundColorWithAction:(ZASwipeAction *)action {
    if (!action.hasBackgroundColor) {
        return;
    }
    
    if (action.backgroundColor) {
        self.backgroundColor = action.backgroundColor;
    }
    else {
        switch (action.style) {
            case ZASwipeActionStyleDestructive:
                self.backgroundColor = [UIColor orangeColor];
                break;
            case ZASwipeActionStyleDefault:
                self.backgroundColor = [UIColor lightGrayColor];
            default:
                self.backgroundColor = [UIColor lightGrayColor];
                break;
        }
    }
    
}
@end
