//
//  ZASwipeableCellContext.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZASwipeable.h"

@interface ZASwipeCellContext : NSObject

@property (nonatomic, readwrite) ZASwipeState state;
@property (nonatomic, readwrite) ZASwipeActionsView *actionsView;

@property (nonatomic, readwrite) CGFloat originalCenter;
@property (nonatomic, readwrite) CGFloat elasticScrollRatio;
@property (nonatomic, readwrite) CGFloat scrollRatio;

@property (nonatomic, readwrite) UIEdgeInsets originalLayoutMargins;
@property (nonatomic, readwrite) UIEdgeInsets layoutMargins;

- (instancetype)init;
@end
