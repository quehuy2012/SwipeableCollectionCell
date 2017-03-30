//
//  MessageEntity.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IncomingMessageEntity.h"

@implementation IncomingMessageEntity

- (instancetype)initWithSender:(SenderEntity *)sender
                       content:(NSString *)content
                          date:(NSDate *)date {
    if (self = [super init]) {
        _sender = sender;
        _content = content;
        _date = date;
    }
    return self;
}
@end
