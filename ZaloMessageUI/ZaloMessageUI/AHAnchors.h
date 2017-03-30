//
//  Anchors.h
//  OnboardingKit
//
//  Created by CPU11713 on 1/18/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AHLayoutDimension.h"
#import "AHLayoutXAxisAnchor.h"
#import "AHLayoutYAxisAnchor.h"

@interface AHAnchors : NSObject

@property (nonatomic, readwrite) UIView *item;

@property (nonatomic, readonly) AHLayoutXAxisAnchor *leadingAnchor;
@property (nonatomic, readonly) AHLayoutXAxisAnchor *trailingAnchor;
@property (nonatomic, readonly) AHLayoutXAxisAnchor *leftAnchor;
@property (nonatomic, readonly) AHLayoutXAxisAnchor *rightAnchor;

@property (nonatomic, readonly) AHLayoutYAxisAnchor *topAnchor;
@property (nonatomic, readonly) AHLayoutYAxisAnchor *bottomAnchor;

@property (nonatomic, readonly) AHLayoutDimension *widthAnchor;
@property (nonatomic, readonly) AHLayoutDimension *heightAnchor;

@property (nonatomic, readonly) AHLayoutXAxisAnchor *centerXAnchor;
@property (nonatomic, readonly) AHLayoutYAxisAnchor *centerYAnchor;

- (instancetype)initWithItem:(UIView *)item;

@end
