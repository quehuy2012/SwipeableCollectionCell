//
//  EmbeddedCollectionViewCell.h
//  MessengerUI
//
//  Created by CPU11713 on 3/7/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGListCollectionView;

@interface EmbeddedCollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite) IGListCollectionView *collectionView;

@end
