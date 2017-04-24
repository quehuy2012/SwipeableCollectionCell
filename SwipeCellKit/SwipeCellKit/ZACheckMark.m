//
//  ZACheckBox.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/31/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZACheckMark.h"

NSString *const kBoxStrokeAnimation = @"BoxStrokeAnimation";
NSString *const kCheckMarkStrokeAnimation = @"CheckMarkStrokeAnimation";
NSString *const kBoxFillAnimation = @"BoxFillAnimation";

@interface ZACheckMark ()

@property (nonatomic, readwrite) CAShapeLayer *boxLayer;
@property (nonatomic, readwrite) CAShapeLayer *checkMarkLayer;
@property (nonatomic, readwrite) CAShapeLayer *borderLayer;

@end

@implementation ZACheckMark

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _checked = NO;
    _lineWidth = 1.0;
    _animationDuration = 0.5;
    _onTintColor = [UIColor whiteColor];
    _offTintColor = [UIColor lightGrayColor];
    //_boxColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _offFillColor = [UIColor clearColor];
    _onFillColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated {
    _checked = checked;
    
    [self drawCheckBox];
    
    if (checked) {
        if (animated) {
            [self.checkMarkLayer addAnimation:[self strokeAnimationReverse:YES] forKey:kCheckMarkStrokeAnimation];
            [self.boxLayer addAnimation:[self fillAnimationReverse:YES] forKey:kBoxFillAnimation];
        }
    }
    else {
        if (animated) {
            [self.checkMarkLayer addAnimation:[self strokeAnimationReverse:NO] forKey:kCheckMarkStrokeAnimation];
             [self.boxLayer addAnimation:[self fillAnimationReverse:NO] forKey:kBoxFillAnimation];
        }
        else {
            [self.boxLayer removeFromSuperlayer];
            [self.checkMarkLayer removeFromSuperlayer];
        }
    }
}

#pragma mark - Draw
- (UIBezierPath *)pathForBox {
    UIBezierPath *path;
    
    CGFloat radius = self.bounds.size.height / 2;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height /2);
    path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle: 0 endAngle: 2 * M_PI clockwise:YES];
    
    return path;
}

- (UIBezierPath *)pathForCheckMark {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat size = self.bounds.size.height;
    
    [path moveToPoint: CGPointMake(size/3, size/2)];
    [path addLineToPoint: CGPointMake(size/2, size/1.5)];
    [path addLineToPoint: CGPointMake(size/1.5, size/2.7)];
                                      
    return path;
}

- (CABasicAnimation *)strokeAnimationReverse:(BOOL)reverse {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (reverse) {
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:1.0];
    } else {
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:0.0];
    }
    animation.duration = self.animationDuration;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

- (CABasicAnimation *)fillAnimationReverse:(BOOL)reverse {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    if (reverse) {
        animation.fromValue = (id)self.offFillColor.CGColor;
        animation.toValue = (id)self.onFillColor.CGColor;
        animation.duration = self.animationDuration;
    }
    else {
        animation.fromValue = (id)self.onFillColor.CGColor;
        animation.toValue = (id)self.offFillColor.CGColor;
        animation.duration = 0.2;
    }
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

- (void)drawRect:(CGRect)rect {
    [self drawCheckBox];
}

- (void)drawCheckBox {
    [self drawBox];
    //[self drawBorder];
    
    if (self.isChecked) {
        [self drawCheckMark];
    }
}

- (void)drawBox {
    [self.boxLayer removeFromSuperlayer];
    
    self.boxLayer = [CAShapeLayer layer];
    self.boxLayer.frame = self.bounds;
    self.boxLayer.fillColor = self.isChecked ? self.onFillColor.CGColor : self.offFillColor.CGColor;
    self.boxLayer.strokeColor = self.isChecked ? self.onFillColor.CGColor : self.offTintColor.CGColor;
    self.boxLayer.lineWidth = self.lineWidth;
    self.boxLayer.path = [self pathForBox].CGPath;
    
    [self.layer addSublayer:self.boxLayer];
}

- (void)drawBorder {
    [self.borderLayer removeFromSuperlayer];
    
    self.borderLayer = [CAShapeLayer layer];
    self.borderLayer.frame = self.bounds;
    self.borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.borderLayer.lineWidth = self.lineWidth;
    self.borderLayer.path = [self pathForBox].CGPath;
    
    [self.layer addSublayer:self.borderLayer];
}

- (void)drawCheckMark {
    [self.checkMarkLayer removeFromSuperlayer];
    
    self.checkMarkLayer = [CAShapeLayer layer];
    self.checkMarkLayer.frame = self.bounds;
    self.checkMarkLayer.strokeColor = self.onTintColor.CGColor;
    self.checkMarkLayer.fillColor = [UIColor clearColor].CGColor;
    self.checkMarkLayer.lineWidth = self.lineWidth;
    self.checkMarkLayer.lineCap = kCALineCapRound;
    self.checkMarkLayer.lineJoin = kCALineJoinRound;
    self.checkMarkLayer.path = [self pathForCheckMark].CGPath;
    
    [self.layer addSublayer:self.checkMarkLayer];
}


@end
