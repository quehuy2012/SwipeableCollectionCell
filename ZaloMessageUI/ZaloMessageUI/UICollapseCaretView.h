//
//  CallapseCaret.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/22/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollapseCaretView : UICollectionReusableView

@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

@property (nonatomic, readwrite) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat lineWidth;

@end
