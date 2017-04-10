//
//  UITableView+SwipeCellKit.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZASwipeTableViewCell;

@interface UITableView (SwipeCellKit)

- (NSArray<ZASwipeTableViewCell *> *)swipeCells;

- (void)hideSwipeCell;

- (void)setGestureEnabled:(BOOL)enabled;
@end
