//
//  PrivateIncomingViewModel.m
//  ZaloMessageUI
//
//  Created by Nham Que Huy on 3/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "PrivateIncomingMessageViewModel.h"

@implementation PrivateIncomingMessageViewModel

- (instancetype)initWithFriend:(FriendViewModel *)friendViewModel date:(NSDate *)date message:(NSString *)message {
    if (self = [super init]) {
        _friendViewModel = friendViewModel;
        _message = message;
        
        // format date
        NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
        [dateFormmater setDateFormat:@"dd/MM/yyyy"];
        _date = [dateFormmater stringFromDate:date];
    }
    
    return self;
}

- (instancetype)initWithMessageEntity:(PrivateIncomingMessageEntity *)messageEntity {
    if (self = [super init]) {
        FriendViewModel *friendViewModel = [[FriendViewModel alloc] initWithFriend:messageEntity.friendEntity];
        NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
        [dateFormmater setDateFormat:@"dd/MM/yyyy"];
        
        _friendViewModel = friendViewModel;
        _date = [dateFormmater stringFromDate:messageEntity.date];
        _message = messageEntity.content;
    }
    return self;
}

#pragma mark - IncomingMessage
- (NSArray<UIImage *> *)profileImages {
    return @[self.friendViewModel.profileImage];
}

- (NSString *)displayName {
    return self.friendViewModel.displayName;
}

- (NSString *)messageDate {
    return self.date;
}

- (NSString *)messageContent {
    return self.message;
}

- (IncomingMessageType)messageType {
    return IncomingMessageTypeFriend;
}
@end
