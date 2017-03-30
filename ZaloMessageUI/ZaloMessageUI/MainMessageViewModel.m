//
//  IncomingMessageViewModel.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "MainMessageViewModel.h"

@interface MainMessageViewModel ()

@end

@implementation MainMessageViewModel

- (instancetype)initWithSubViewModels:(NSArray<NSObject<IGListDiffable> *> *)viewModels type:(MainMessageViewModelType)type {
    if (self = [super init]) {
        _subViewModels = [NSMutableArray arrayWithArray:viewModels];
        _type = type;
    }
    
    return self;
}

- (NSString *)sectionTitle {
    NSString *title;
    switch (self.type) {
        case MainMessageViewModelTypeLastMessage:
            title = @"Last Message";
            break;
        case MainMessageViewModelTypeSuggestedFriends:
            title = @"Suggested Friends";
        case MainMessageViewModelTypeOffcialAccount:
            title = @"Offical Account";
        default:
            break;
    }
    
    return title;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[MainMessageViewModel class]]) {
        return NO;
    }
    
    MainMessageViewModel *other = object;
    return (self.subViewModels == other.subViewModels || [self.subViewModels isEqual:other.subViewModels]) && (self.type == other.type);
}

#pragma mark - IGDiffable
- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
