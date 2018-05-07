//
//  EmbeddedAdapterSectionController.h
//  MessengerUI
//
//  Created by CPU11713 on 3/14/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import "IGCollapseSupplementary.h"

@class IGEmbeddedSection;
@class MainMessageViewModel;

@protocol IGEmbeddedAdapterDataSource <NSObject>

- (IGListSectionController *)listAdapter:(IGListAdapter *)adapter sectionControllerFor:(id)object;

@end

@interface IGEmbeddedAdapterSectionController : IGListSectionController < IGListAdapterDataSource, IGCollapseSupplementaryDelegate>

@property (nonatomic, readwrite) MainMessageViewModel *viewModel;

- (instancetype)initWithDataSource:(id<IGEmbeddedAdapterDataSource>)dataSource height:(CGFloat)height;
@end
