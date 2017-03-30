//
//  LayoutAnchor.h
//  OnboardingKit
//
//  Created by CPU11713 on 1/24/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AHLayoutAnchor : NSObject

@property (nonatomic, readwrite) UIView *item;
@property (nonatomic, readwrite) NSLayoutAttribute attribute;

- (instancetype)initWithItem:(UIView *)view attribute:(NSLayoutAttribute)attribute;

// These methods return an inactive constraint of the form thisAnchor = otherAnchor.
- (NSLayoutConstraint *)constraintEqualToAnchor:(AHLayoutAnchor *)anchor;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(AHLayoutAnchor *)anchor;
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(AHLayoutAnchor *)anchor;

// These methods return an inactive constraint of the form thisAnchor = otherAnchor + constant.
- (NSLayoutConstraint *)constraintEqualToAnchor:(AHLayoutAnchor *)anchor constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(AHLayoutAnchor *)anchor constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(AHLayoutAnchor *)anchor constant:(CGFloat)constant;


@end
