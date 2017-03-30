//
//  GroupViewModel.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/27/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListDiffable.h>
#import "GroupEntity.h"
#import "FriendViewModel.h"

@interface GroupViewModel : NSObject <IGListDiffable>

@property (nonatomic, readonly, copy) NSString *displayName;
@property (nonatomic, readonly) NSArray<FriendViewModel *> *friendViewModels;

- (instancetype)initWithGroup:(GroupEntity *)group;

@end
