//
//  FriendEntity.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "FriendEntity.h"

@implementation FriendEntity

- (instancetype)initWithUID:(NSString *)uid
                       name:(NSString *)name
           profileURLString:(NSString *)profileURLString {
    if (self = [super init]) {
        _uid = uid;
        _name = name;
        _profileURLString = profileURLString;
    }
    
    return self;
}

- (SenderType)senderType {
    return SenderTypeFriend;
}
@end
