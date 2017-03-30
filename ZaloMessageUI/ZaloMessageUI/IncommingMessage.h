//
//  IncommingMessage.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>
#import "IncomingMessageEntity.h"


typedef NS_ENUM(NSInteger, IncomingMessageType) {
    IncomingMessageTypeOA,
    IncomingMessageTypeGroup,
    IncomingMessageTypeFriend
};

@protocol IncomingMessage <NSObject, IGListDiffable>

- (NSArray<UIImage *> *)profileImages;
- (NSString *)displayName;
- (NSString *)messageContent;
- (NSString *)messageDate;
- (IncomingMessageType)messageType;

@end
