//
//  SenderEntity.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/28/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SenderType) {
    SenderTypeOA,
    SenderTypeGroup,
    SenderTypeFriend
};

@interface SenderEntity : NSObject {
    @protected
    NSString *_name;
}

@property (nonatomic, assign) SenderType senderType;
@property (nonatomic, readonly) NSString *name;

@end
