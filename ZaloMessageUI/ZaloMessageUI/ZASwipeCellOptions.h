//
//  ZASwipeCellOptions.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/30/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZASwipeTransitionStyle) {
    ZASwipeTransitionStyleBorder,
    ZASwipeTransitionStyleDrag,
    ZASwipeTransitionStyleReveal
};

typedef NS_ENUM(NSInteger, ZASwipeActionsOrientation) {
    ZASwipeActionsOrientationLeft,
    ZASwipeActionsOrientationRight
};

typedef NS_ENUM(NSInteger, ZASwipeVerticalAligment) {
    ZASwipeVerticalAligmentCenterFirstBaseLine,
    ZASwipeVerticalAligmentCenter
};

@interface ZASwipeCellOptions : NSObject

@end
