//
//  LayoutAnchor.m
//  OnboardingKit
//
//  Created by CPU11713 on 1/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "AHLayoutAnchor.h"

@implementation AHLayoutAnchor

- (instancetype)initWithItem:(UIView *)item attribute:(NSLayoutAttribute)attribute {
    self = [super init];
    
    if (self) {
        _item = item;
        _attribute = attribute;
    }

    return self;
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(AHLayoutAnchor *)anchor {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationEqual toItem:anchor.item attribute:anchor.attribute multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(AHLayoutAnchor *)anchor {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:anchor.item attribute:anchor.attribute multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(AHLayoutAnchor *)anchor {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:anchor.item attribute:anchor.attribute multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(AHLayoutAnchor *)anchor constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationEqual toItem:anchor.item attribute:anchor.attribute multiplier:1.0 constant:constant];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(AHLayoutAnchor *)anchor constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:anchor.item attribute:anchor.attribute multiplier:1.0 constant:constant];
}
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(AHLayoutAnchor *)anchor constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:anchor.item attribute:anchor.attribute multiplier:1.0 constant:constant];
}

@end

