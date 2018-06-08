//
//  IGCollapsibleSupplementary.m
//  MessengerUI
//
//  Created by CPU11713 on 3/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IGCollapseSupplementary.h"

// Views
#import "HeaderCollapseView.h"

@implementation IGCollapseSupplementary

- (instancetype)initWithSectionController:(IGListSectionController *)sectionController {
    self = [super init];
    
    if (self) {
        _sectionController = sectionController;
    }
    
    return self;
}

#pragma mark - IGListSupplementaryViewSource
- (NSArray<NSString *> *)supportedElementKinds {
    return @[UICollectionElementKindSectionHeader];
}

- (UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind atIndex:(NSInteger)index {
//    HeaderCollapeCollectionViewCell *header = [self.sectionController.collectionContext dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader forSectionController:self.sectionController nibName:@"HeaderCollapeCollectionViewCell" bundle:nil atIndex:index];
    
    HeaderCollapseView *header = [self.sectionController.collectionContext dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader forSectionController:self.sectionController class:[HeaderCollapseView class] atIndex:index];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchSupplementary:)];
    
    header.delegate = self;
    header.titleLabel.text = self.delegate.sectionTitle;
    [header setExpanded:self.delegate.expanded];
    [header addGestureRecognizer:tapRecognizer];
    
    return header;
}

#pragma mark - HeaderCollapseViewDelegate
- (void)collapseViewDidTouchButton:(HeaderCollapseView *)view {
    [self.delegate didTouchAddButtonInSupplementary:view ofSectionController:self.sectionController];
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind atIndex:(NSInteger)index {
    return CGSizeMake(self.sectionController.collectionContext.containerSize.width, 50);
}

#pragma mark - Private
- (void)didTouchSupplementary:(UITapGestureRecognizer *)sender {
    HeaderCollapseView *header = (HeaderCollapseView *)sender.view;
    [self.delegate didTouchSupplementary:header ofSectionController:self.sectionController];
}

@end
