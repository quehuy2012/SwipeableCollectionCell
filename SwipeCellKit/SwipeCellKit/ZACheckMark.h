//
//  ZACheckBox.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/31/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZACheckMarkDelegate;

@interface ZACheckMark : UIControl

@property (nonatomic, readwrite, weak) id <ZACheckMarkDelegate> delegate;

@property (nonatomic, readwrite, getter=isChecked) BOOL checked;

@property (nonatomic, readwrite) CGFloat lineWidth;
@property (nonatomic, readwrite) CGFloat animationDuration;

@property (nonatomic, readwrite) UIColor *onTintColor;
@property (nonatomic, readwrite) UIColor *offTintColor;
@property (nonatomic, readwrite) UIColor *onFillColor;
@property (nonatomic, readwrite) UIColor *offFillColor;


- (void)setChecked:(BOOL)checked animated:(BOOL)animated;

@end


@protocol ZACheckBoxDelegate <NSObject>

- (void)didTouchCheckMark:(ZACheckMark *)checkMark;

@end

