//
//  FriendViewModel.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "FriendViewModel.h"
#import "FriendEntity.h"

@implementation FriendViewModel

- (instancetype)initWithFriend:(FriendEntity *)friend {
    if(self = [super init]) {
        _uid = friend.uid;
        _displayName = friend.name;
        _profileImage = [UIImage imageNamed:friend.profileURLString];
    }
    
    return self;
}

#pragma mark - Equality
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[FriendViewModel class]]) {
        return NO;
    }
    
    FriendViewModel *other = object;
    return (self.uid == other.uid || [self.uid isEqual:other.uid]) &&
    (self.displayName == other.displayName || [self.displayName isEqual:other.displayName]) &&
    (self.profileImage == self.profileImage || [self.profileImage isEqual:other.profileImage]);
}

#pragma mark - IGDiffable
- (id<NSObject>)diffIdentifier {
    return self.uid;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return [self isEqual:object];
}
@end
