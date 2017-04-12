//
//  ZASwipeAccessibilityCustomAction.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/11/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZASwipeAction;

@interface ZASwipeAccessibilityCustomAction : UIAccessibilityCustomAction

@property (nonatomic, readonly) ZASwipeAction *action;
@property (nonatomic, readonly) NSIndexPath *indexPath;

- (instancetype)initWithAction:(ZASwipeAction *)action indexPath:(NSIndexPath *)indexPath target:(id)target selector:(SEL)selector;


@end
