//
//  EmbeddedAdapterSectionController.m
//  MessengerUI
//
//  Created by CPU11713 on 3/14/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IGEmbeddedAdapterSectionController.h"

// ViewModels
#import "MainMessageViewModel.h"
#import "FriendViewModel.h"

// Model
#import "FriendEntity.h"

// Views
#import "EmbeddedCollectionViewCell.h"


@interface IGEmbeddedAdapterSectionController ()

/**
 The adapter of embedded collection view
 */
@property (nonatomic, readonly) IGListAdapter *adapter;

/**
 The data source of embedded collection view
 */
@property (nonatomic, readonly) id<IGEmbeddedAdapterDataSource> dataSource;

/**
 The data source that used to create a collapsable supllementary view
 */
@property (nonatomic, readwrite) IGCollapseSupplementary *collapseSupplementarySource;

@property (nonatomic, assign) CGFloat height;

@end

@implementation IGEmbeddedAdapterSectionController

@synthesize expanded = _expanded;
@synthesize sectionTitle = _sectionTitle;

- (instancetype)initWithDataSource:(id<IGEmbeddedAdapterDataSource>)dataSource height:(CGFloat)height {
    self = [super init];
    
    if (self) {
        _dataSource = dataSource;
        _height = height;
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self.viewController workingRangeSize:0];
        _collapseSupplementarySource = [[IGCollapseSupplementary alloc] initWithSectionController:self];
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.adapter.dataSource = self;
    self.collapseSupplementarySource.delegate = self;
    self.supplementaryViewSource = self.collapseSupplementarySource;
    self.expanded = YES;
    self.inset = UIEdgeInsetsMake(0, 0, 20, 0);
}

- (void)setViewModel:(MainMessageViewModel *)viewModel {
    _viewModel = viewModel;
    _sectionTitle = [viewModel sectionTitle];
}

#pragma mark - IGListSectionType

- (NSInteger)numberOfItems {
    return self.isExpanded ? 1 : 0;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    return CGSizeMake(width - self.inset.left - self.inset.right, self.height - self.inset.top
                      - self.inset.bottom);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    EmbeddedCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[EmbeddedCollectionViewCell class] forSectionController:self atIndex:index];
    
    self.adapter.collectionView = cell.collectionView;
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.viewModel = object;
    [self.adapter performUpdatesAnimated:YES completion:nil];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.viewModel.subViewModels;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [self.dataSource listAdapter:listAdapter sectionControllerFor:object];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - IGCollapseSupplementaryDelegate
- (void)didTouchSupplementary:(UIView *)supplementaryView ofSectionController:(IGListSectionController *)sectionController {
    self.expanded = !self.expanded;
    [self updateSection];
}

- (void)didTouchAddButtonInSupplementary:(UIView *)supplementaryView ofSectionController:(IGListSectionController *)sectionController {
    if (!self.expanded) {
        self.expanded = YES;
        [self updateSection];
    }
    
    NSUInteger index = [self.viewModel.subViewModels count] + 1;
    
    NSString *uid = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    NSString *name = [NSString stringWithFormat:@"Recent %lu", (unsigned long)index];
    NSString *profileURLstring = @"User-50";
    
    FriendEntity * friendEntity = [[FriendEntity alloc] initWithUID:uid name:name profileURLString:profileURLstring];
    FriendViewModel *friendViewModel = [[FriendViewModel alloc] initWithFriend:friendEntity];
    
    [self.viewModel.subViewModels insertObject:friendViewModel atIndex:1];
    
    [self.adapter performUpdatesAnimated:YES completion:nil];
}

#pragma mark - Private
- (void)updateSection {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
    // Update cell
    if (self.isExpanded) {
        [self.collectionContext performBatchAnimated:YES updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
            [batchContext insertInSectionController:self atIndexes:indexSet];
        } completion:nil];
    }
    else {
        [self.collectionContext performBatchAnimated:YES updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
            [batchContext deleteInSectionController:self atIndexes:indexSet];
        } completion:nil];
    }
}

@end
