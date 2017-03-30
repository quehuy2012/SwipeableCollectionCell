//
//  PrivateIncomingMessageEntity.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/27/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "PrivateIncomingMessageEntity.h"

@implementation PrivateIncomingMessageEntity

- (instancetype)initWithFriend:(FriendEntity *)friendEntity
                       content:(NSString *)content
                          date:(NSDate *)date {
    if (self = [super init]) {
        _friendEntity = friendEntity;
        _content = content;
        _date = date;
    }
    return self;
}

@end
