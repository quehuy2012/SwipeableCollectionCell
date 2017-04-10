//
//  ZAActionsViewLayoutContext.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZASwipeable.h"
#import "ZASwipeActionsView.h"

@interface ZAActionsViewLayoutContext : NSObject

@property (nonatomic, assign) NSInteger numberOfActions;
@property (nonatomic, assign) ZASwipeActionsOrientation orientation;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGFloat visibleWidth;
@property (nonatomic, assign) CGFloat minimumButtonWidth;

- (instancetype)initWithNumberOfActions:(NSInteger)numberOfActions
                            orientation:(ZASwipeActionsOrientation)orientation;

- (instancetype)initWithNumberOfActions:(NSInteger)numberOfActions
                            orientation:(ZASwipeActionsOrientation)orientation
                            contentSize:(CGSize)contentSize
                           visibleWidth:(CGFloat)visibleWidth
                     minimumButtonWidth:(CGFloat)minimumButtonWidth;

+ (instancetype)contextForActionsView:(ZASwipeActionsView *)actionsView;
@end
