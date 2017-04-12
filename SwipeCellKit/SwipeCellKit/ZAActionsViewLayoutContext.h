//
//  ZAActionsViewLayoutContext.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZASwipeable.h"

@class ZASwipeActionsView;

@interface ZAActionsViewLayoutContext : NSObject

@property (nonatomic, readonly) NSInteger numberOfActions;
@property (nonatomic, readonly) ZASwipeActionsOrientation orientation;
@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic, readonly) CGFloat visibleWidth;
@property (nonatomic, readonly) CGFloat minimumButtonWidth;

- (instancetype)initWithNumberOfActions:(NSInteger)numberOfActions
                            orientation:(ZASwipeActionsOrientation)orientation;

- (instancetype)initWithNumberOfActions:(NSInteger)numberOfActions
                            orientation:(ZASwipeActionsOrientation)orientation
                            contentSize:(CGSize)contentSize
                           visibleWidth:(CGFloat)visibleWidth
                     minimumButtonWidth:(CGFloat)minimumButtonWidth;

+ (instancetype)contextForActionsView:(ZASwipeActionsView *)actionsView;
@end
