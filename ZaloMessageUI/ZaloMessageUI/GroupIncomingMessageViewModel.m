//
//  GroupIncomingMessageViewModel.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/27/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "GroupIncomingMessageViewModel.h"

@implementation GroupIncomingMessageViewModel

//- (instancetype)initWithMessageEnttiy:(GroupIncomingMessageEntity *)messageEntity {
//    if (self = [super init]) {
//        GroupViewModel *groupViewModel = [[GroupViewModel alloc] initWithGroup:messageEntity.groupEntity];
//        NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
//        [dateFormmater setDateFormat:@"dd/MM/yyyy"];
//        
//        _groupViewModel = groupViewModel;
//        _content = messageEntity.content;
//        _date = [dateFormmater stringFromDate:messageEntity.date];
//    }
//    return self;
//}

- (instancetype)initWithGroup:(GroupViewModel *)groupViewModel date:(NSDate *)date message:(NSString *)message {
    if (self = [super init]) {
        _groupViewModel = groupViewModel;
        _message = message;
        
        // format date
        NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
        [dateFormmater setDateFormat:@"dd/MM/yyyy"];
        _date = [dateFormmater stringFromDate:date];
    }
    
    return self;
}

#pragma mark - IncomingMessage
- (NSArray<UIImage *> *)profileImages {
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (FriendViewModel *friend in self.groupViewModel.friendViewModels) {
        [images addObject:friend.profileImage];
    }
    return [images copy];
}

- (NSString *)displayName {
    return self.groupViewModel.displayName;
}

- (NSString *)messageDate {
    return self.date;
}

- (NSString *)messageContent {
    return self.message;
}

- (IncomingMessageType)messageType {
    return IncomingMessageTypeGroup;
}

#pragma mark - IGListDiffable

@end
