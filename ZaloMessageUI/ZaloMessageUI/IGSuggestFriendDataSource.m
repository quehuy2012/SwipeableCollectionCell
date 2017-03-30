//
//  IGSuggestFriendDataSource.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IGSuggestFriendDataSource.h"
#import "IGFriendSectionController.h"

@implementation IGSuggestFriendDataSource

- (IGListSectionController<IGListSectionType> *)listAdapter:(IGListAdapter *)adapter sectionControllerFor:(id)object {
    return [[IGFriendSectionController alloc] init];
}
@end
