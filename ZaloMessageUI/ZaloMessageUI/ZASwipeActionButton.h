//
//  ZASwipeActionButton.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/30/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASwipeCellOptions.h"

@interface ZASwipeActionButton : UIButton

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat maximumImageHeight;
@property (nonatomic, readonly) CGFloat currentSpacing;

@property (nonatomic, assign) BOOL shouldHightLight;

@property (nonatomic, assign) ZASwipeVerticalAligment verticalAlignment;

@end
