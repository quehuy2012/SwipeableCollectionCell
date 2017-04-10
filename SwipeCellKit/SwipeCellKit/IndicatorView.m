//
//  IndicatorView.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "IndicatorView.h"

@implementation IndicatorView

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self.color set];
    [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
}


@end
