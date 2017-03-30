//
//  FriendEntity.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SenderEntity.h"

@interface FriendEntity : SenderEntity

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, copy) NSString *profileURLString;

- (instancetype)initWithUID:(NSString *)uid
                       name:(NSString *)name
           profileURLString:(NSString *)profileURLString;

@end
