//
//  UIPanGestureRecognizer+SwipeCellKit.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "UIPanGestureRecognizer+SwipeCellKit.h"

@implementation UIPanGestureRecognizer (SwipeCellKit)
- (CGPoint)elasticTranslationInView:(UIView *)view
                          withLimit:(CGSize)limit
                 fromOriginalCenter:(CGPoint)center {
    return [self elasticTranslationInView:view withLimit:limit fromOriginalCenter:center applyingRatio:0.2];
}

- (CGPoint)elasticTranslationInView:(UIView *)view
                          withLimit:(CGSize)limit
                 fromOriginalCenter:(CGPoint)center
                      applyingRatio:(CGFloat)ratio {
    CGPoint translation = [self translationInView:view];
    
    if (!self.view) {
        return translation;
    }
    
    CGPoint updatedCenter = CGPointMake(center.x + translation.x, center.y + translation.y);
    CGFloat sourceViewBoundsMidX = CGRectGetMidX(self.view.bounds);
    CGFloat sourceViewBoundsMidY = CGRectGetMidY(self.view.bounds);
    CGSize distanceFromCenter = CGSizeMake(fabs(updatedCenter.x - sourceViewBoundsMidX),
                                           fabs(updatedCenter.y - sourceViewBoundsMidY));
    CGFloat inverseRatio = 1.0 - ratio;
    CGFloat scaleX = updatedCenter.x < sourceViewBoundsMidX ? -1 : 1;
    CGFloat scaleY = updatedCenter.y < sourceViewBoundsMidY ? -1 : 1;
    
    CGFloat x = updatedCenter.x - (distanceFromCenter.width > limit.width ? inverseRatio * (distanceFromCenter.width - limit.width) * scaleX : 0);
    CGFloat y = updatedCenter.y - (distanceFromCenter.height > limit.height ? inverseRatio * (distanceFromCenter.height - limit.height) * scaleY : 0);
    
    return CGPointMake(x, y);
    
}
@end
