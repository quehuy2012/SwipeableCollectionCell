//
//  LayoutDimension.h
//  OnboardingKit
//
//  Created by CPU11713 on 1/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "AHLayoutAnchor.h"

/*
 This layout anchor subclass is used for sizes (width & height).
 */
@interface AHLayoutDimension : AHLayoutAnchor

// These methods return an inactive constraint of the form thisVariable = constant.
- (NSLayoutConstraint *)constraintEqualToConstant:(CGFloat)c;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToConstant:(CGFloat)c;
- (NSLayoutConstraint *)constraintLessThanOrEqualToConstant:(CGFloat)c;

// These methods return an inactive constraint of the form thisAnchor = otherAnchor * multiplier.
- (NSLayoutConstraint *)constraintEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m;
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m;

// These methods return an inactive constraint of the form thisAnchor = otherAnchor * multiplier + constant.
- (NSLayoutConstraint *)constraintEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m constant:(CGFloat)c;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m constant:(CGFloat)c;
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(AHLayoutDimension *)anchor multiplier:(CGFloat)m constant:(CGFloat)c;
@end

