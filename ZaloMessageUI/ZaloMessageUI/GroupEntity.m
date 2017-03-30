//
//  GroupEntity.m
//  ZaloMessageUI
//
//  Created by Nham Que Huy on 3/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "GroupEntity.h"

@implementation GroupEntity


- (instancetype)initWithMembers:(NSArray<FriendEntity *> *)members name:(NSString *)name {
    if (self = [super init]) {
        if(!members) {
            members = @[];
        }
        _members = members;
        _name = name;
    }

    return self;
}

- (SenderType)senderType {
    return SenderTypeGroup;
}
@end
