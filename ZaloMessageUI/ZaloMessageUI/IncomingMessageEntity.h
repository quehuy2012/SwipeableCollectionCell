//
//  MessageEntity.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SenderEntity.h"



@interface IncomingMessageEntity : NSObject

@property (nonatomic, readonly) SenderEntity *sender;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSDate *date;

- (instancetype)initWithSender:(SenderEntity *)sender
                       content:(NSString *)content
                          date:(NSDate *)date;
@end
