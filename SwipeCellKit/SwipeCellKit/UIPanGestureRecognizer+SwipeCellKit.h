//
//  UIPanGestureRecognizer+SwipeCellKit.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPanGestureRecognizer (SwipeCellKit)

- (CGPoint)elasticTranslationInView:(UIView *)view
                          withLimit:(CGSize)limit
                 fromOriginalCenter:(CGPoint)center
                      applyingRatio:(CGFloat)ratio;

- (CGPoint)elasticTranslationInView:(UIView *)view
                          withLimit:(CGSize)limit
                 fromOriginalCenter:(CGPoint)center;

@end
