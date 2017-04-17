//
//  ZASwipeActionButton.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/30/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeActionButton.h"
#import "ZASwipeAction.h"

@implementation ZASwipeActionButton

@synthesize highlighted = _highlighted;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithSwipeAction:(ZASwipeAction *)action {
    self = [self initWithFrame:CGRectZero];
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.tintColor = action.textColor ? action.textColor : [UIColor whiteColor];
    
    self.titleLabel.font = action.font ? action.font : [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    
    self.accessibilityLabel = action.accessibilityLabel;
    
    [self setTitle:action.title forState:UIControlStateNormal];
    [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self setImage:action.image forState:UIControlStateNormal];
    [self setImage:action.hightlightedImage ? action.hightlightedImage : action.image forState:UIControlStateHighlighted];
    
    return self;
}

- (void)setUp {
    _spacing = 8;
    _maximumImageHeight = 0;
    _shouldHightLight = YES;
    _verticalAlignment = ZASwipeVerticalAligmentCenterFirstBaseLine;
}

- (CGFloat)currentSpacing {
    return (self.currentTitle && [self.currentTitle isEqualToString:@""] == NO && self.maximumImageHeight >0) ? self.spacing : 0;
}

- (CGRect)alignmentRect {
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGFloat titleHeight = [self titleBoudingRectWithSize:self.verticalAlignment == ZASwipeVerticalAligmentCenterFirstBaseLine ? CGRectInfinite.size : contentRect.size].size.height;
    CGFloat totalHeight = self.maximumImageHeight + titleHeight + self.currentSpacing;
    
    return CGRectCenteredInRect(contentRect, CGSizeMake(contentRect.size.width, totalHeight));
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    
    if (self.shouldHightLight) {
        self.backgroundColor = _highlighted ? [[UIColor blackColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
    }
}

- (CGRect)titleBoudingRectWithSize:(CGSize)size {
    CGRect rect;
    
    if (self.currentTitle && self.titleLabel.font) {
        rect = [self.currentTitle boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: self.titleLabel.font} context:nil];
    }
    else {
        rect = CGRectZero;
    }
    
    return rect;
}

- (CGFloat)preferredWidthWithMaxinum:(CGFloat)maximum {
    CGFloat width = maximum > 0 ? maximum : CGFLOAT_MAX;
    CGFloat textWidth  = [self titleBoudingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)].size.width;
    CGFloat imagewidth = self.currentImage ? self.currentImage.size.width : 0;
    
    return MIN(width, MAX(textWidth, imagewidth) + self.contentEdgeInsets.left + self.contentEdgeInsets.right);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGSize size = [self titleBoudingRectWithSize:contentRect.size].size;
    CGRect rect = CGRectCenteredInRect(contentRect, size);
    rect.origin.y = CGRectGetMinY(self.alignmentRect) + self.maximumImageHeight + self.currentSpacing;
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize size = self.currentImage ? self.currentImage.size : CGSizeZero;
    CGRect rect = CGRectCenteredInRect(contentRect, size);
    rect.origin.y = CGRectGetMinY(self.alignmentRect) + (self.maximumImageHeight - rect.size.height) / 2;
    return rect;
}

#pragma mark - Private

CGRect CGRectCenteredInRect(CGRect outerRect, CGSize size) {
    CGFloat dx = outerRect.size.width - size.width;
    CGFloat dy = outerRect.size.height - size.height;
    return CGRectMake(outerRect.origin.x + dx * 0.5, outerRect.origin.y + dy * 0.5, size.width, size.height);
}
@end
