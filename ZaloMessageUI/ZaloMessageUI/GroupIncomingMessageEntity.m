//
//  GroupIncomingMessageEntity.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/27/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "GroupIncomingMessageEntity.h"

@implementation GroupIncomingMessageEntity

- (instancetype)initWithFriend:(GroupEntity *)groupEntity
                       content:(NSString *)content
                          date:(NSDate *)date {
    if (self = [super init]) {
        _groupEntity = groupEntity;
        _content = content;
        _date = date;
    }
    return self;
}
@end
