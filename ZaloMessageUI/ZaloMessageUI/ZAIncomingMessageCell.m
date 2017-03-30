//
//  ZAIncomingCollectionViewCell.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/23/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZAIncomingMessageCell.h"
#import "ZAIncomingMessageCellProtected.h"

// Supporting File
#import "System.h"
#import "Constant.h"

#define SUBTITLE_COLOR [UIColor colorWithRed:131.0/255 green:136.0/255 blue:140.0/255 alpha:1.0]
#define TOP_SEPARATOR_VIEW_COLOR [UIColor colorWithRed:227.0/255 green:230.0/255 blue:231.0/255 alpha:1.0]
@interface ZAIncomingMessageCell ()

@property (nonatomic, readonly) NSArray<UIView *> *profileImageViews;

@end


@implementation ZAIncomingMessageCell

#pragma mark - Life Cycle

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

#pragma mark - Setup
- (void)setUp {
    _topSepartorView = [[UIView alloc] init];
    _imageContainerView = [[UIView alloc] init];
    _titleContainerView = [[UIView alloc] init];
    _contentLabel = [[UILabel alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _dateLabel = [[UILabel alloc] init];
    
    [self.topContentView addSubview:_imageContainerView];
    [self.topContentView addSubview:_titleContainerView];
    [self.topContentView addSubview:_dateLabel];
    [self.topContentView addSubview:_topSepartorView];
    
    [self.titleContainerView addSubview:_nameLabel];
    [self.titleContainerView addSubview:_contentLabel];
    
    [self setUpDateLabel];
    [self setUpContentView];
    [self setUpImageContainerView];
    [self setUpTitleContainerView];
    [self setUpNameLabel];
    [self setUpContentLabel];
    [self setUpTopSepartorView];
    
    
}

- (void)setUpContentView {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setUpImageContainerView {
    self.imageContainerView.opaque = YES;
    self.imageContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading, *top, *bottom, *ratio;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        leading = [self.imageContainerView.leadingAnchor constraintEqualToAnchor:self.imageContainerView.superview.leadingAnchor constant:DEFAULT_MARGIN];
        top = [self.imageContainerView.topAnchor constraintEqualToAnchor:self.imageContainerView.superview.topAnchor constant:DEFAULT_MARGIN];
        bottom = [self.imageContainerView.bottomAnchor constraintEqualToAnchor:self.imageContainerView.superview.bottomAnchor constant:-DEFAULT_MARGIN];
        ratio = [self.imageContainerView.widthAnchor constraintEqualToAnchor:self.imageContainerView.heightAnchor multiplier:1];
    }
    
    [NSLayoutConstraint activateConstraints:@[leading, top, bottom, ratio]];
}

- (void)setUpTitleContainerView {
    // WARING: Trailing
    // self.titleContainerView.backgroundColor = [UIColor yellowColor];
    self.titleContainerView.opaque = YES;
    self.titleContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading, *trailing, *centerY;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        leading = [self.titleContainerView.leadingAnchor constraintEqualToAnchor:self.imageContainerView.trailingAnchor constant:DEFAULT_MARGIN];
        centerY = [self.titleContainerView.centerYAnchor constraintEqualToAnchor:self.imageContainerView.centerYAnchor];
        trailing = [self.titleContainerView.trailingAnchor constraintEqualToAnchor:self.dateLabel.leadingAnchor constant:-DEFAULT_MARGIN];
    }
    [NSLayoutConstraint activateConstraints:@[leading, trailing, centerY]];
}

- (void)setUpNameLabel {
    self.nameLabel.opaque = YES;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading, *trailing, *top;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        leading = [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.superview.leadingAnchor];
        trailing = [self.nameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.nameLabel.superview.trailingAnchor];
        top = [self.nameLabel.topAnchor constraintEqualToAnchor:self.nameLabel.superview.topAnchor constant:SUBVIEW_CONTENT_MARGIN];
    }
    
    [NSLayoutConstraint activateConstraints:@[leading, trailing, top]];
}

- (void)setUpContentLabel {
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = SUBTITLE_COLOR;
    self.contentLabel.opaque = YES;
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading, *trailing, *bottom, *top;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        leading = [self.contentLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor];
        trailing = [self.contentLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentLabel.superview.trailingAnchor];
        bottom = [self.contentLabel.bottomAnchor constraintEqualToAnchor:self.contentLabel.superview.bottomAnchor constant:-SUBVIEW_CONTENT_MARGIN];
        top = [self.contentLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:4];
    }
    
    bottom.priority = 250;
    top.priority = 750;
    
    [NSLayoutConstraint activateConstraints:@[leading, trailing, bottom, top]];
}

- (void)setUpDateLabel {
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = SUBTITLE_COLOR;
    self.dateLabel.opaque = YES;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top, *trailing;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        top = [self.dateLabel.topAnchor constraintEqualToAnchor:self.nameLabel.topAnchor];
        trailing = [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.dateLabel.superview.trailingAnchor constant:-30];
    }
    
    [NSLayoutConstraint activateConstraints:@[top, trailing]];
}

- (void)setUpTopSepartorView {
    self.topSepartorView.backgroundColor = TOP_SEPARATOR_VIEW_COLOR;
    self.topSepartorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top, *leading, *trailing, *height;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        top = [self.topSepartorView.topAnchor constraintEqualToAnchor:self.topSepartorView.superview.topAnchor];
        leading = [self.topSepartorView.leadingAnchor constraintEqualToAnchor:self.titleContainerView.leadingAnchor];
        trailing = [self.topSepartorView.trailingAnchor constraintEqualToAnchor:self.topSepartorView.superview.trailingAnchor];
        height = [self.topSepartorView.heightAnchor constraintEqualToConstant:1.0];
    }
    
    [NSLayoutConstraint activateConstraints:@[top, leading, trailing, height]];
}

- (void)displayProfileImagas:(NSArray<UIImage *> *)profileImages {

}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    return layoutAttributes;
}
@end
