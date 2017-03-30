//
//  PrivateIncomingViewModel.h
//  ZaloMessageUI
//
//  Created by Nham Que Huy on 3/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendViewModel.h"
#import "IncommingMessage.h"
#import "PrivateIncomingMessageEntity.h"

@interface PrivateIncomingMessageViewModel : NSObject <IncomingMessage>

@property (nonatomic, readonly) FriendViewModel *friendViewModel;
@property (nonatomic, readonly) NSString *date;
@property (nonatomic, readonly) NSString *message;

- (instancetype)initWithFriend:(FriendViewModel *)friendViewModel date:(NSDate *)date message:(NSString *)message;

- (instancetype)initWithMessageEntity:(PrivateIncomingMessageEntity *)messageEntity;
@end
