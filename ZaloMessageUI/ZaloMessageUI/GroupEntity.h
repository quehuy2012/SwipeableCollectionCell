//
//  GroupEntity.h
//  ZaloMessageUI
//
//  Created by Nham Que Huy on 3/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SenderEntity.h"
#import "FriendEntity.h"

@interface GroupEntity : SenderEntity

@property (nonatomic, readonly) NSArray<FriendEntity *> *members;

- (instancetype)initWithMembers:(NSArray<FriendEntity *> *)members name:(NSString *)name;
@end
