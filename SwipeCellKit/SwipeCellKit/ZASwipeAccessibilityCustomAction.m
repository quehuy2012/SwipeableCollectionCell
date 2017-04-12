//
//  ZASwipeAccessibilityCustomAction.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/11/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeAccessibilityCustomAction.h"
#import "ZASwipeAction.h"

@implementation ZASwipeAccessibilityCustomAction

- (instancetype)initWithAction:(ZASwipeAction *)action indexPath:(NSIndexPath *)indexPath target:(id)target selector:(SEL)selector {
    
    NSString *name = action.accessibilityLabel;
    
    if (!name) {
        name = action.title;
    }
    if (!name) {
        name = action.image.accessibilityIdentifier;
    }
    
    if (!name) {
        [NSException raise:@"Missing title" format:@"You must provide either a title or an image for a SwipeAciton"];
        return nil;
    }
    
    if (self = [super initWithName:name target:self selector:selector]) {
        _action = action;
        _indexPath = indexPath;
    }
    return self;
}

@end
