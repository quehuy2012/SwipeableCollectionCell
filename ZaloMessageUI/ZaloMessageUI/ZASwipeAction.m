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
                      handler:(void (^)(ZASwipeAction *, NSIndexPath *))handler {
    if (self = [super init]) {
        _style = style;
        _tittle = title;
        _handler = handler;
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
