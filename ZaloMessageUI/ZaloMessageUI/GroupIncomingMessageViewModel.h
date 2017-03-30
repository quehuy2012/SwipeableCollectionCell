//
//  GroupIncomingMessageViewModel.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/27/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupViewModel.h"
#import "IncommingMessage.h"
#import "GroupIncomingMessageEntity.h"

@interface GroupIncomingMessageViewModel : NSObject <IncomingMessage>

@property (nonatomic, readonly) GroupViewModel *groupViewModel;
@property (nonatomic, readonly) NSString *date;
@property (nonatomic, readonly) NSString *message;

@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSArray<UIImage *> *profileImages;

//- (instancetype)initWithMessageEnttiy:(GroupIncomingMessageEntity *)messageEntity;
- (instancetype)initWithGroup:(GroupViewModel *)groupViewModel date:(NSDate *)date message:(NSString *)message;
@end
