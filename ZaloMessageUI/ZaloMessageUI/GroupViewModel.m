//
//  GroupViewModel.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/27/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "GroupViewModel.h"

@implementation GroupViewModel

- (instancetype)initWithGroup:(GroupEntity *)group {
    if (self = [super init]) {
        _displayName = group.name;
        
        NSMutableArray *friendViewModels = [NSMutableArray array];
        for (FriendEntity *friend in group.members) {
            FriendViewModel *viewModel = [[FriendViewModel alloc] initWithFriend:friend];
            [friendViewModels addObject:viewModel];
        }
        
        _friendViewModels = [friendViewModels copy];
    }
    return self;
}

#pragma mark - Equality
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[GroupViewModel class]]) {
        return NO;
    }
    
    GroupViewModel *other = object;
    
    return (self.displayName == other.displayName || [self.displayName isEqual:other.displayName])
    && (self.friendViewModels == other.friendViewModels || [self.friendViewModels isEqual:other.friendViewModels]);
}

#pragma mark - IGDiffable
- (id<NSObject>)diffIdentifier {
    return self.displayName;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
