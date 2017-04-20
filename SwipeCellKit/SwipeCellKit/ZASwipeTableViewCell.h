//
//  ZASwipeTableViewCell.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASwipeable.h"

@class ZASwipeAction;
@class ZASwipeActionsView;
@class ZASwipeCellOptions;



@interface ZASwipeTableViewCell : UITableViewCell <ZASwipeable>

@property (nonatomic, readwrite, weak) id<ZASwipeViewCellDelegate> delegate;

@property (nonatomic, readwrite) ZASwipeState state;
@property (nonatomic, readwrite) CGFloat originalCenter;

@property (nonatomic, readwrite, weak) UITableView *tableView;

@property (nonatomic, readwrite) ZASwipeActionsView *actionsView;

@property (nonatomic, readwrite) UIEdgeInsets originalLayoutMargins;

@property (nonatomic, readonly) CGFloat elasticScrollRatio;
@property (nonatomic, readwrite) CGFloat scrollRatio;

@property (nonatomic, readwrite) UIEdgeInsets layoutMargins;

- (void)hideSwipeWithAnimation:(BOOL)animated;
@end

