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

@protocol ZASwipeViewCellDelegate <NSObject>

/**
 Asks the delegate for the actions to dispaly in response to a swipe in the specified row.
 
 @param tableView The table view object which owns the cell requesting this information
 @param indexPath The index path of the row
 @param orientation The side of cell requesting this information
 @return An array of ZASwipeAction objects representing the actions for the row
 */
- (NSArray<ZASwipeAction *> *)tableView:(UITableView *)tableView
           editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
                         forOrientation:(ZASwipeActionsOrientation)orientation;

/**
 Ask the delgate for display options to be used while presenting the action buttons
 
 @param tableView The table view object which owsn the cell requesting this information
 @param indexPath The index path of the row
 @param orientation The side of the cell requesting this information
 @return A ZASwipeCellOptions instance which configures the behavior of the action buttons
 */
- (ZASwipeCellOptions *)tableView:(UITableView *)tableView
editActionsOptionsForRowAtIndexPath:(NSIndexPath *)indexPath
                   forOrientation:(ZASwipeActionsOrientation)orientation;


/**
 Tells the delegate that collectionView is about to go into editing mode
 */
- (void)tableView:(UITableView *)tableView willBeginEdittingRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation;

/**
 Tell the delegate that the collection view has left editting mode
 */
- (void)tableView:(UITableView *)tableView didEndEdittingRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation;

@end

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

