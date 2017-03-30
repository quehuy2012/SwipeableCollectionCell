//
//  GroupIncomingMessageEntity.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/27/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupEntity.h"

@interface GroupIncomingMessageEntity : NSObject

@property (nonatomic, readonly) GroupEntity *groupEntity;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSDate *date;

- (instancetype)initWithFriend:(GroupEntity *)groupEntity
                       content:(NSString *)content
                          date:(NSDate *)date;

@end
