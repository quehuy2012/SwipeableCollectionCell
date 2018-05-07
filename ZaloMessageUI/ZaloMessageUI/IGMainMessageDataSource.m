//
//  IGMainMessageDataSource.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IGMainMessageDataSource.h"

// IGSectionControllers
#import "IGFriendSectionController.h"
#import "IGEmbeddedAdapterSectionController.h"
#import "IGIncomingMessageSectionController.h"

// IGDataSources
#import "IGSuggestFriendDataSource.h"

// ViewModels
#import "MainMessageViewModel.h"


@interface IGMainMessageDataSource ()

@property (nonatomic, readwrite) NSMutableArray<MainMessageViewModel *> *viewModels;

@end

@implementation IGMainMessageDataSource

#pragma mark - Life cycle

- (instancetype)init {
    return [self initWithViewModels:[NSMutableArray array]];
}

- (instancetype)initWithViewModels:(NSArray<id<IGListDiffable>> *)viewModels {
    if (self = [super init]) {
        _viewModels = [NSMutableArray arrayWithArray:viewModels];
    }
    return self;
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.viewModels;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    MainMessageViewModel *viewModel = object;
    IGListSectionController *sectionController;
    
    switch (viewModel.type) {
        case MainMessageViewModelTypeLastMessage:
            sectionController = [[IGIncomingMessageSectionController alloc] init];
            break;
        case MainMessageViewModelTypeOffcialAccount:
            break;
        case MainMessageViewModelTypeSuggestedFriends: {
            IGSuggestFriendDataSource *dataSource = [[IGSuggestFriendDataSource alloc] init];
            IGEmbeddedAdapterSectionController *embeddedSectionControler = [[IGEmbeddedAdapterSectionController alloc] initWithDataSource:dataSource height:120];
            
            sectionController = embeddedSectionControler;
            break;
        }
        default:
            break;
    }
    
    return sectionController;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}
@end
