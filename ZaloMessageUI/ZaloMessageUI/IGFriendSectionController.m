//
//  IGEmbeddedFriendSectionController.m
//  MessengerUI
//
//  Created by CPU11713 on 3/8/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IGFriendSectionController.h"

// ViewModels
#import "FriendViewModel.h"

// Views
#import "SuggestFriendCollectionViewCell.h"

@interface IGFriendSectionController () <SuggestFriendCollectionViewCellDelegate>

@property (nonatomic, readwrite) FriendViewModel *friendViewModel;

@end

@implementation IGFriendSectionController

#pragma mark - IGListSectionType
- (NSInteger)numberOfItems {
    return self.friendViewModel ? 1 : 0;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(72, self.collectionContext.containerSize.height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    SuggestFriendCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[SuggestFriendCollectionViewCell class] forSectionController:self atIndex:index];
    
    cell.nameLabel.text = self.friendViewModel.displayName;
    cell.profileImageView.image = self.friendViewModel.profileImage;
    cell.delegate = self;
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.friendViewModel = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}

#pragma mark - SuggestFriendCollectionViewCellDelegate
- (void)collectionViewCellWillHide:(SuggestFriendCollectionViewCell *)cell {
    self.friendViewModel = nil;
    NSInteger index = [self.collectionContext indexForCell:cell sectionController:self];
    [self.collectionContext performBatchAnimated:YES updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
        [batchContext deleteInSectionController:self atIndexes:[NSIndexSet indexSetWithIndex:index]];
    } completion:nil];
}

@end
