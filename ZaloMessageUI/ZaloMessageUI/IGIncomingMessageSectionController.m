//
//  IGIncomingMessageSectionController.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/23/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IGIncomingMessageSectionController.h"

// ViewModels
#import "IncomingMessageFactory.h"
#import "MainMessageViewModel.h"
#import "PrivateIncomingMessageViewModel.h"

// Views
#import "ZAPrivateIncomingMessageCell.h"
#import "ZAGroupIncomingMessageCell.h"

@interface IGIncomingMessageSectionController ()

@property (nonatomic, readwrite) IGCollapseSupplementary *collapseSupplementarySource;

@property (nonatomic, readwrite) MainMessageViewModel *viewModel;

@property (nonatomic, assign) ZASwippableCell *openningSwippableCell;

@end

@implementation IGIncomingMessageSectionController

@synthesize expanded = _expanded;
@synthesize sectionTitle = _sectionTitle;


#pragma mark - Life cycle
- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.inset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    self.collapseSupplementarySource = [[IGCollapseSupplementary alloc] initWithSectionController:self];
    self.collapseSupplementarySource.delegate = self;
    self.expanded = YES;
    self.supplementaryViewSource = self.collapseSupplementarySource;
    self.displayDelegate = self;
}

- (void)setViewModel:(MainMessageViewModel *)viewModel {
    _viewModel = viewModel;
    _sectionTitle = [viewModel sectionTitle];
}

#pragma mark - IGListSectionType
- (NSInteger)numberOfItems {
    return self.expanded ? self.viewModel.subViewModels.count : 0;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width - self.inset.left - self.inset.right;
    
    return CGSizeMake(width, 80);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    NSObject<IGListDiffable> *item = self.viewModel.subViewModels[index];
    ZAIncomingMessageCell *cell;
    
    if ([item conformsToProtocol:@protocol(IncomingMessage)]) {
        id<IncomingMessage> messageViewModel = (id<IncomingMessage>)item;
        
        switch ([messageViewModel messageType]) {
            case IncomingMessageTypeFriend:
            case IncomingMessageTypeOA:
                cell = [self.collectionContext dequeueReusableCellOfClass:[ZAPrivateIncomingMessageCell class] forSectionController:self atIndex:index];
                break;
            case IncomingMessageTypeGroup:
                cell = [self.collectionContext dequeueReusableCellOfClass:[ZAGroupIncomingMessageCell class] forSectionController:self atIndex:index];
                break;
            default:
                break;
        }
        
    }
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.viewModel = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}

#pragma mark - IGListDisplayDelgate
- (void)listAdapter:(IGListAdapter *)listAdapter willDisplaySectionController:(IGListSectionController *)sectionController cell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    
    id<IncomingMessage> messageViewModel = self.viewModel.subViewModels[index];
    
    ZAIncomingMessageCell *incomingMessageCell = (ZAIncomingMessageCell *)cell;
    incomingMessageCell.utilityButtonDelgate = self;
    incomingMessageCell.nameLabel.text = [messageViewModel displayName];
    incomingMessageCell.dateLabel.text = [messageViewModel messageDate];
    incomingMessageCell.contentLabel.text = [messageViewModel messageContent];
    [incomingMessageCell displayProfileImagas:[messageViewModel profileImages]];
    
    UIButton *deleteButton = [[UIButton alloc] init];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor redColor];
    
    UIButton *testButton = [[UIButton alloc] init];
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    testButton.backgroundColor = [UIColor greenColor];
    incomingMessageCell.utilityButtons = @[deleteButton, testButton];
}

- (void)listAdapter:(IGListAdapter *)listAdapter willDisplaySectionController:(IGListSectionController *)sectionController {
    
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingSectionController:(IGListSectionController *)sectionController {
    
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingSectionController:(IGListSectionController *)sectionController cell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    
}

#pragma mark - IGCollapseSupplementaryDelegate
- (void)didTouchSupplementary:(UIView *)supplementaryView ofSectionController:(IGListSectionController *)sectionController {
    self.expanded = !self.expanded;
    //[self.collectionContext reloadSectionController:self];
    [self updateSection];
}

- (void)didTouchAddButtonInSupplementary:(UIView *)supplementaryView ofSectionController:(IGListSectionController *)sectionController {
    if (!self.expanded) {
        self.expanded = YES;
        [self.collectionContext performBatchAnimated:YES updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
            [batchContext reloadSectionController:self];
        } completion:nil];
    }
    
    NSUInteger index = [self.viewModel.subViewModels count];
    
    NSString *content = [NSString stringWithFormat:@"Private message %lu", (unsigned long)index];
    NSDate *date = [[NSDate alloc] init];
    
    FriendEntity * friendEntity = [[FriendEntity alloc] initWithUID:@"1" name:@"Friend1" profileURLString:@"User-50"];
    
    IncomingMessageEntity *messageEntity = [[IncomingMessageEntity alloc] initWithSender:friendEntity content:content date:date];
    
    id<IncomingMessage> messageViewModel = [IncomingMessageFactory createMessageViewModel:messageEntity];

    [self.viewModel.subViewModels insertObject:messageViewModel atIndex:0];
    [self.collectionContext performBatchAnimated:YES updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
        [batchContext insertInSectionController:self atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
}

#pragma mark - Private
- (void)updateSection {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.viewModel.subViewModels.count)];
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

#pragma mark - ZASwippableCell
- (void)swippableCell:(ZASwippableCell *)cell didTriggerRightUtilityButtonsAtIndex:(NSInteger)index {
    if (index == 0) {
        NSInteger cellIndex = [self.collectionContext indexForCell:cell sectionController:self];
        [self.viewModel.subViewModels removeObjectAtIndex:cellIndex];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:cellIndex];
        [self.collectionContext performBatchAnimated:YES updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
            [batchContext deleteInSectionController:self atIndexes:indexSet];
        } completion:nil];
    }
}

- (void)swippableCell:(ZASwippableCell *)cell didScrollToState:(ZASwippableCellState)state {
    [self.openningSwippableCell hideSwipeButtonAnimated:YES];
    
    if (state == ZASwippableCellStateOpen) {
        self.openningSwippableCell = cell;
    }
}

@end
