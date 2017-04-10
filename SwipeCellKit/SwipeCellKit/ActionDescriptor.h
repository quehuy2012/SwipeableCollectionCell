//
//  ActionDescriptor.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActionDescriptorType) {
    ActionDescriptorTypeRead,
    ActionDescriptorTypeUnread,
    ActionDescriptorTypeMore,
    ActionDescriptorTypeFlag,
    ActionDescriptorTypeTrash
};

typedef NS_ENUM(NSInteger, ButtonDisplayMode) {
    ButtonDisplayModeTitleOnly,
    ButtonDisplayModeImageOnly,
    ButtonDisplayModeTitleAndImage
};

typedef NS_ENUM(NSInteger, ButtonStyle) {
    ButtonStyleBackgroundColor,
    ButtonStyleCircular
};

@interface ActionDescriptor : NSObject

@property (nonatomic, readwrite) ActionDescriptorType type;

- (instancetype)initWithType:(ActionDescriptorType)type;
+ (instancetype)type:(ActionDescriptorType)type;

- (NSString *)titleForDisplayMode:(ButtonDisplayMode)mode;
- (UIImage *)imageForStyle:(ButtonStyle)style inDisplayMode:(ButtonDisplayMode)mode;
- (UIColor *)color;



@end
