//
//  IGCollapsibleSupplementary.h
//  MessengerUI
//
//  Created by CPU11713 on 3/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>
#import "HeaderCollapseView.h"

@protocol IGCollapseSupplementaryDelegate <NSObject>

@property (nonatomic, readwrite, copy) NSString *sectionTitle;
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

- (void)didTouchSupplementary:(UIView *)supplementaryView ofSectionController:(IGListSectionController *)sectionController;
- (void)didTouchAddButtonInSupplementary:(UIView *)supplementaryView ofSectionController:(IGListSectionController *)sectionController;

@end


@interface IGCollapseSupplementary : NSObject <IGListSupplementaryViewSource, HeaderCollapseViewDelegate>

@property (nonatomic, readwrite, weak) id<IGCollapseSupplementaryDelegate> delegate;
@property (nonatomic, readwrite, weak) IGListSectionController *sectionController;

- (instancetype)init __attribute__((unavailable("use initWithSectionController: instead")));
- (instancetype)initWithSectionController:(IGListSectionController *)sectionController;

@end


