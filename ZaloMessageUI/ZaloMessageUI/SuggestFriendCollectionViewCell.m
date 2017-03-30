//
//  SuggestFriendCollectionViewCell.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "SuggestFriendCollectionViewCell.h"
#import "System.h"

@interface SuggestFriendCollectionViewCell ()

@property (nonatomic, readonly) UIView *containerView;

@end

@implementation SuggestFriendCollectionViewCell

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

- (void)setUp {
    _containerView = [[UIView alloc] init];
    _profileImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    
    [self addSubview:_containerView];
    [self.containerView addSubview:_profileImageView];
    [self.containerView addSubview:_nameLabel];
    
    [self setUpContainerView];
    [self setUpProfileImageView];
    [self setUpNameLabel];
}

#pragma mark - UI Events

- (void)longPressRecognize:(UILongPressGestureRecognizer *)recognizer {
    __weak typeof(self) weakSelf = self;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.profileImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }];
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self.delegate collectionViewCellWillHide:self];
            self.profileImageView.transform = CGAffineTransformIdentity;
            break;
        default:
            break;
    }
}

#pragma mark - Privates

- (void)setUpContainerView {
    self.containerView.opaque = YES;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *width, *height, *centerX, *centerY;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        centerX = [self.containerView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor];
        centerY = [self.containerView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor];
        width = [self.containerView.widthAnchor constraintEqualToConstant:100];
        height = [self.containerView.heightAnchor constraintEqualToConstant:100];
    }
    
    [NSLayoutConstraint activateConstraints:@[centerX, centerY, width, height]];
}

- (void)setUpProfileImageView {
    self.profileImageView.opaque = YES;
    self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *width, *ratio, *centerX, *top;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        width = [self.profileImageView.widthAnchor constraintEqualToConstant:50];
        ratio = [self.profileImageView.heightAnchor constraintEqualToAnchor:self.profileImageView.widthAnchor multiplier:1.0];
        centerX = [self.profileImageView.centerXAnchor constraintEqualToAnchor:self.profileImageView.superview.centerXAnchor];
        top = [self.profileImageView.topAnchor constraintEqualToAnchor:self.profileImageView.superview.topAnchor constant:8];
    }
    
    [NSLayoutConstraint activateConstraints:@[width, ratio, centerX, top]];
}

- (void)setUpNameLabel {
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top, *bottom, *centerX;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        top = [self.nameLabel.topAnchor constraintEqualToAnchor:self.profileImageView.bottomAnchor constant:8.0];
        bottom = [self.nameLabel.bottomAnchor constraintEqualToAnchor:self.nameLabel.superview.bottomAnchor constant:8.0];
        centerX = [self.nameLabel.centerXAnchor constraintEqualToAnchor:self.nameLabel.superview.centerXAnchor];
    }
    
    [NSLayoutConstraint activateConstraints:@[top, bottom, centerX]];
}
@end
