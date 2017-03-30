//
//  PrivateIncomingMessageEntity.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/27/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendEntity.h"

@interface PrivateIncomingMessageEntity : NSObject

@property (nonatomic, readonly) FriendEntity *friendEntity;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSDate *date;

- (instancetype)initWithFriend:(FriendEntity *)friendEntity
                       content:(NSString *)content
                          date:(NSDate *)date;

@end
