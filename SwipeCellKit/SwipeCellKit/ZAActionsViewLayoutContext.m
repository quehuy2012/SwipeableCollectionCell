//
//  ZAActionsViewLayoutContext.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZAActionsViewLayoutContext.h"
#import "ZASwipeActionsView.h"

@implementation ZAActionsViewLayoutContext

- (instancetype)initWithNumberOfActions:(NSInteger)numberOfActions orientation:(ZASwipeActionsOrientation)orientation {
    return [self initWithNumberOfActions:numberOfActions orientation:orientation contentSize:CGSizeZero visibleWidth:0 minimumButtonWidth:0];
}

- (instancetype)initWithNumberOfActions:(NSInteger)numberOfActions
                            orientation:(ZASwipeActionsOrientation)orientation
                            contentSize:(CGSize)contentSize
                           visibleWidth:(CGFloat)visibleWidth
                     minimumButtonWidth:(CGFloat)minimumButtonWidth {
    if (self = [super init]) {
        _numberOfActions = numberOfActions;
        _orientation = orientation;
        _contentSize = contentSize;
        _visibleWidth = visibleWidth;
        _minimumButtonWidth = minimumButtonWidth;
    }
    return self;
}

+ (instancetype)contextForActionsView:(ZASwipeActionsView *)actionsView {
    return [[ZAActionsViewLayoutContext alloc] initWithNumberOfActions:actionsView.actions.count
                                                           orientation:actionsView.orientation
                                                           contentSize:actionsView.contentSize
                                                          visibleWidth:actionsView.visibleWidth
                                                    minimumButtonWidth:actionsView.minimumButtonWidth];
}
@end
