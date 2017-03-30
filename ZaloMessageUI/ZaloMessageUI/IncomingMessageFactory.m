//
//  IncomingMessageViewModel.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IncomingMessageFactory.h"

// ViewModels
#import "PrivateIncomingMessageViewModel.h"
#import "GroupIncomingMessageViewModel.h"

// Models
#import "FriendEntity.h"
#import "GroupEntity.h"

@implementation IncomingMessageFactory

+ (id<IncomingMessage>)createMessageViewModel:(IncomingMessageEntity *)messageEntity {
    
    id<IncomingMessage> messageViewModel;
    
    switch (messageEntity.sender.senderType) {
        case SenderTypeFriend: {
            FriendEntity *friendEntity = (FriendEntity *)messageEntity.sender;
            FriendViewModel *friendViewModel = [[FriendViewModel alloc] initWithFriend:friendEntity];
            messageViewModel = [[PrivateIncomingMessageViewModel alloc] initWithFriend:friendViewModel date:messageEntity.date message:messageEntity.content];
            break;
        }
            
        case SenderTypeGroup: {
            GroupEntity *groupEntity = (GroupEntity *)messageEntity.sender;
            GroupViewModel *groupViewModel = [[GroupViewModel alloc] initWithGroup:groupEntity];
            messageViewModel = [[GroupIncomingMessageViewModel alloc] initWithGroup:groupViewModel date:messageEntity.date message:messageEntity.content];
            break;
        }
        
        case SenderTypeOA: {
            
        }
        default:
            break;
    }
    return messageViewModel;
}
@end
