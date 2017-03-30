//
//  HeaderCollapseView.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/22/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollapseCaretView.h"

@class HeaderCollapseView;
@protocol HeaderCollapseViewDelegate <NSObject>

- (void)collapseViewDidTouchButton:(HeaderCollapseView *)view;

@end


@interface HeaderCollapseView : UICollectionReusableView

@property (nonatomic, readwrite) UILabel *titleLabel;
@property (nonatomic, readwrite) UIButton *addButton;
@property (nonatomic, readwrite) UICollapseCaretView *caretView;

@property (nonatomic, readwrite, weak) id<HeaderCollapseViewDelegate> delegate;

- (void)setExpanded:(BOOL)expanded;

@end
