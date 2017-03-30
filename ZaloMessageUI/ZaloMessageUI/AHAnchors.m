//
//  Anchors.m
//  OnboardingKit
//
//  Created by CPU11713 on 1/18/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "AHAnchors.h"
@implementation AHAnchors

- (instancetype)initWithItem:(UIView *)item {
    self = [super init];
    if (self) {
        _item = item;
    }
    return self;
}

#pragma mark - Getter
- (AHLayoutXAxisAnchor *)leadingAnchor {
    return [[AHLayoutXAxisAnchor alloc] initWithItem:_item attribute:NSLayoutAttributeLeading];
}

- (AHLayoutXAxisAnchor *)trailingAnchor {
    return [[AHLayoutXAxisAnchor alloc] initWithItem:_item attribute:NSLayoutAttributeTrailing];
}

- (AHLayoutXAxisAnchor *)leftAnchor {
    return [[AHLayoutXAxisAnchor alloc] initWithItem:_item attribute:NSLayoutAttributeLeft];
}

- (AHLayoutXAxisAnchor *)rightAnchor {
    return [[AHLayoutXAxisAnchor alloc] initWithItem:_item attribute:NSLayoutAttributeRight];
}

- (AHLayoutYAxisAnchor *)topAnchor {
    return [[AHLayoutYAxisAnchor alloc] initWithItem:_item attribute:NSLayoutAttributeTop];
}

- (AHLayoutYAxisAnchor *)bottomAnchor {
    return [[AHLayoutYAxisAnchor alloc] initWithItem:_item attribute:NSLayoutAttributeBottom];
}

- (AHLayoutDimension *)widthAnchor {
    return [[AHLayoutDimension alloc] initWithItem:_item attribute:NSLayoutAttributeWidth];
}

- (AHLayoutDimension *)heightAnchor {
    return [[AHLayoutDimension alloc] initWithItem:_item attribute:NSLayoutAttributeHeight];
}

- (AHLayoutXAxisAnchor *)centerXAnchor {
    return [[AHLayoutXAxisAnchor alloc] initWithItem:_item attribute:NSLayoutAttributeCenterX];
}

- (AHLayoutYAxisAnchor *)centerYAnchor {
    return [[AHLayoutYAxisAnchor alloc] initWithItem:_item attribute:NSLayoutAttributeCenterY];
}

@end
