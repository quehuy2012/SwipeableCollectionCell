//
//  SuggestFriendCollectionViewCell.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuggestFriendCollectionViewCell;
@protocol SuggestFriendCollectionViewCellDelegate <NSObject>

- (void)collectionViewCellWillHide:(SuggestFriendCollectionViewCell *)cell;

@end

@interface SuggestFriendCollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite, weak) id<SuggestFriendCollectionViewCellDelegate> delegate;

@property (nonatomic, readonly) UIImageView *profileImageView;
@property (nonatomic, readonly) UILabel *nameLabel;

@end
