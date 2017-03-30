//
//  CallapseCaret.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/22/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "UICollapseCaretView.h"

@interface UICollapseCaretView ()

@property (nonatomic, readwrite) UIBezierPath *leftPath;
@property (nonatomic, readwrite) UIBezierPath *rightPath;



@end

@implementation UICollapseCaretView
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
    self.backgroundColor = [UIColor clearColor];
    
    self.expanded = YES;
    self.lineWidth = 3.0;
    self.leftPath = [UIBezierPath bezierPath];
    self.rightPath = [UIBezierPath bezierPath];
    self.strokeColor = [UIColor whiteColor];
    
    self.leftPath.lineWidth = self.lineWidth;
    self.rightPath.lineWidth = self.lineWidth;
}

- (void)drawRect:(CGRect)rect {
    if (self.isExpanded) {
        CGPoint midPoint = CGPointMake(CGRectGetMidX(self.bounds),self.bounds.origin.y + self.bounds.size.height);
    
        [self.leftPath moveToPoint:self.bounds.origin];
        [self.leftPath addLineToPoint:CGPointMake(midPoint.x + self.lineWidth/2, midPoint.y)];
        
        [self.rightPath moveToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y)];
        [self.rightPath addLineToPoint:midPoint];
    }
    else {
        CGPoint midPoint = CGPointMake(CGRectGetMidX(self.bounds), self.bounds.origin.y);
        
        [self.leftPath moveToPoint:CGPointMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height)];
        [self.leftPath addLineToPoint:CGPointMake(midPoint.x + self.lineWidth/2, midPoint.y)];
        
        [self.rightPath moveToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y + self.bounds.size.height)];
        [self.rightPath addLineToPoint:midPoint];
    }
    
    [self.strokeColor setStroke];
    [self.leftPath stroke];
    [self.rightPath stroke];
}

@end
