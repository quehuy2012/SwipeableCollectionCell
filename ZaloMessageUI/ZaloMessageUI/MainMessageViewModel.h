//
//  IncomingMessageViewModel.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>

typedef NS_ENUM(NSInteger, MainMessageViewModelType) {
    MainMessageViewModelTypeLastMessage,
    MainMessageViewModelTypeSuggestedFriends,
    MainMessageViewModelTypeOffcialAccount
};

@interface MainMessageViewModel : NSObject <IGListDiffable>

@property (nonatomic, assign) MainMessageViewModelType type;
@property (nonatomic, readwrite) NSMutableArray<id<IGListDiffable>> *subViewModels;

- (instancetype)initWithSubViewModels:(NSArray<id<IGListDiffable>> *)viewModels type:(MainMessageViewModelType)type;

- (NSString *)sectionTitle;
@end
