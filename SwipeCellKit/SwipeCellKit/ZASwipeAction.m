//
//  ZASwipeAction.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/30/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeAction.h"

@implementation ZASwipeAction

- (instancetype)initWithStyle:(ZASwipeActionStyle)style
                        title:(NSString *)title
                      handler:(void (^)(ZASwipeAction *action, NSIndexPath *indexPath))handler {
    if (self = [super init]) {
        _style = style;
        _title = title;
        _handler = handler;
        
        _hideWhenSelected = NO;
    }
    return self;
}

- (void)fulFillWithStyle:(ZAExpansionFulfillmentStyle)style {
    if (self.completionHandler) {
        self.completionHandler(style);
    }
}

- (BOOL)hasBackgroundColor {
    return self.backgroundColor != [UIColor clearColor] && self.backgroundEffect == nil;
}
@end
