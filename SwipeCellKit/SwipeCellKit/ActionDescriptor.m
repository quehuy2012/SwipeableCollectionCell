//
//  ActionDescriptor.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ActionDescriptor.h"

@implementation ActionDescriptor

- (instancetype)initWithType:(ActionDescriptorType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

+ (instancetype)type:(ActionDescriptorType)type {
    return [[ActionDescriptor alloc] initWithType:type];
}

- (NSString *)titleForDisplayMode:(ButtonDisplayMode)mode {
    if (mode == ButtonDisplayModeImageOnly) {
        return nil;
    }
    
    NSString *title;

    switch (self.type) {
        case ActionDescriptorTypeRead:
            title = @"Read";
            break;
        case ActionDescriptorTypeFlag:
            title = @"Flag";
            break;
        case ActionDescriptorTypeMore:
            title = @"More";
            break;
        case ActionDescriptorTypeTrash:
            title = @"Trash";
            break;
        case ActionDescriptorTypeUnread:
            title = @"Unread";
            break;
        default:
            break;
    }
    
    return title;
}

- (UIImage *)imageForStyle:(ButtonStyle)style inDisplayMode:(ButtonDisplayMode)mode {
    if (mode == ButtonDisplayModeTitleOnly) {
        return nil;
    }
    
    NSString *imageName = [self titleForDisplayMode:mode];
    
    switch (self.type) {
        case ActionDescriptorTypeRead:
            imageName = @"Read";
            break;
        case ActionDescriptorTypeFlag:
            imageName = @"Flag";
            break;
        case ActionDescriptorTypeMore:
            imageName = @"More";
            break;
        case ActionDescriptorTypeTrash:
            imageName = @"Trash";
            break;
        case ActionDescriptorTypeUnread:
            imageName = @"Unread";
            break;
        default:
            break;
    }
    
    imageName = style == ButtonStyleBackgroundColor ? imageName : [NSString stringWithFormat:@"%@-circle",imageName];
    return [UIImage imageNamed:imageName];
}

- (UIColor *)color {
    UIColor *color;
    
    switch (self.type) {
        case ActionDescriptorTypeRead:
        case ActionDescriptorTypeUnread:
            color = [UIColor colorWithRed:0 green:0.4577052593 blue:1 alpha:1];
            break;
        case ActionDescriptorTypeMore:
            color = [UIColor colorWithRed:0.7803494334 green:0.7761332393 blue:0.7967314124 alpha:1];
            break;
        case ActionDescriptorTypeFlag:
            color = [UIColor colorWithRed:1 green:0.5803921569 blue:0 alpha:1];
            break;
        case ActionDescriptorTypeTrash:
            color = [UIColor colorWithRed:1 green:0.2352941176 blue:0.1882352941 alpha:1];
            break;
        default:
            break;
    }
    
    return color;
}
@end
