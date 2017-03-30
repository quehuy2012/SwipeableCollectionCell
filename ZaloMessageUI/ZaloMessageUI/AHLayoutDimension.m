//
//  LayoutDimension.m
//  OnboardingKit
//
//  Created by CPU11713 on 1/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "AHLayoutDimension.h"

@implementation AHLayoutDimension

- (NSLayoutConstraint *)constraintEqualToConstant:(CGFloat)c {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:c];
}
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToConstant:(CGFloat)c {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:c];
}
- (NSLayoutConstraint *)constraintLessThanOrEqualToConstant:(CGFloat)c {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:c];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationEqual toItem:anchor.item attribute:anchor.attribute multiplier:m constant:0];
}
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:anchor.item attribute:anchor.attribute multiplier:m constant:0];
}
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:anchor.item attribute:anchor.attribute multiplier:m constant:0];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m constant:(CGFloat)c {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationEqual toItem:anchor.item attribute:anchor.attribute multiplier:m constant:c];
}
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m constant:(CGFloat)c {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:anchor.item attribute:anchor.attribute multiplier:m constant:c];
}
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m constant:(CGFloat)c {
    return [NSLayoutConstraint constraintWithItem:self.item attribute:self.attribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:anchor.item attribute:anchor.attribute multiplier:m constant:c];
}

@end
