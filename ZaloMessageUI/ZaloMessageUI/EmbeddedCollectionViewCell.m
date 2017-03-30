//
//  EmbeddedCollectionViewCell.m
//  MessengerUI
//
//  Created by CPU11713 on 3/7/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "EmbeddedCollectionViewCell.h"
#import <IGListKit/IGListKit.h>

@implementation EmbeddedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.collectionView = [[IGListCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        [self.contentView addSubview:self.collectionView];
        
        self.collectionView.showsHorizontalScrollIndicator = false;
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.alwaysBounceHorizontal = YES;
        self.collectionView.alwaysBounceVertical = NO;
    }
    
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.frame;
}

@end
