//
//  ZAIncomingCollectionViewCell.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/23/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASwippableCell.h"

/**
 Abstract incoming message cell, don't direct init this class.
 instead init the ZAPrivateIncomingMessageCell or ZAGroupIncomingMessageCell
 */
@interface ZAIncomingMessageCell : ZASwippableCell

@property (nonatomic, readwrite) UILabel *nameLabel;
@property (nonatomic, readwrite) UILabel *contentLabel;
@property (nonatomic, readwrite) UILabel *dateLabel;

///**
// an images array that used to be displayed by cell
// */
//@property (nonatomic, readonly) NSArray<UIImage *> *profileImages;

/**
 The view that contains multi profile image view
 */
@property (nonatomic, readonly) UIView *imageContainerView;


/**
 The view that contains nameLabel and titleLabel
 */
@property (nonatomic, readonly) UIView *titleContainerView;


@property (nonatomic, readonly) UIView *topSepartorView;


/**
 Display images with appropriate layout
 
 | 0 0 |   | 0 |   |    |   0   |   | 0 | 1 |
 | 0 0 |   |   | 1 |    | 1 | 2 |   | 2 | 3 |
 
 @param profileImages images that will be displayed
 */
- (void)displayProfileImagas:(NSArray<UIImage *> *)profileImages;

@end
