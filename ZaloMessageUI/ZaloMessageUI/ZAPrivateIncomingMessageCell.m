//
//  ZAPrivateIncomingMessageCell.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/23/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZAPrivateIncomingMessageCell.h"
#import "ZAIncomingMessageCellProtected.h"
// Supporting file
#import "System.h"
#import "Constant.h"

@implementation ZAPrivateIncomingMessageCell

#pragma mark - Life cycle
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
    [super setUp];
    
    _profileImageView = [[UIImageView alloc] init];
    
    [self.imageContainerView addSubview:_profileImageView];
    
    [self setUpProfileImageView];
}

- (void)setUpProfileImageView {
    self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading, *top, *bottom, *trailing;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        leading = [self.profileImageView.leadingAnchor constraintEqualToAnchor:self.profileImageView.superview.leadingAnchor];
        top = [self.profileImageView.topAnchor constraintEqualToAnchor:self.profileImageView.superview.topAnchor];
        bottom = [self.profileImageView.bottomAnchor constraintEqualToAnchor:self.profileImageView.superview.bottomAnchor];
        trailing = [self.profileImageView.trailingAnchor constraintEqualToAnchor:self.profileImageView.superview.trailingAnchor];
    }
    
    [NSLayoutConstraint activateConstraints:@[leading, top, bottom, trailing]];
}

- (void)displayProfileImagas:(NSArray<UIImage *> *)profileImages {
    if (![profileImages isKindOfClass:[NSArray class]] || !profileImages || profileImages.count == 0) {
        // show default image if needed
        return;
    }
    self.profileImageView.image = profileImages[0];
}

@end
