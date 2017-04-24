//
//  UICollectionView+SwipeCellKit.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/21/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASwipeCellKit.h"

@class ZASwipeTableViewCell;

@interface UICollectionView (SwipeCellKit) <ZASwipeCellParentViewProtocol>

@property (nonatomic) BOOL editing;
@property (nonatomic) BOOL dealloced;

@end

extern NSString *const kSwipeCellKitCollectionEditingNotification;
