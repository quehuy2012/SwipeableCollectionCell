//
//  FriendViewModel.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>

@class FriendEntity;

@interface FriendViewModel : NSObject <IGListDiffable>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, copy) NSString *displayName;
@property (nonatomic, readonly) UIImage *profileImage;

- (instancetype)initWithFriend:(FriendEntity *)friend;

@end
