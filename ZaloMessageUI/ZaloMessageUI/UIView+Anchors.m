//
//  UIView+Anchors.m
//  OnboardingKit
//
//  Created by CPU11713 on 1/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "UIView+Anchors.h"
#import "AHAnchors.h"

@implementation UIView (Anchors)

- (AHAnchors *)anchors {
    return [[AHAnchors alloc] initWithItem:self];
}
@end
