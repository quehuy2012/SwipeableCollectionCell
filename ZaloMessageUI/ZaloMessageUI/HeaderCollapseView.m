//
//  HeaderCollapseView.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/22/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "HeaderCollapseView.h"
#import "System.h"
#import "Constant.h"

@implementation HeaderCollapseView

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

#pragma mark - Getter & Setter

- (void)setExpanded:(BOOL)expanded {
    
}

#pragma mark - Setup

- (void)setUp {
    self.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:255.0/255.0 alpha:1.0];;
    
    self.titleLabel = [[UILabel alloc] init];
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.caretView = [[UICollapseCaretView alloc] init];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.addButton];
    [self addSubview:self.caretView];
    
    [self setUpTitleLabel];
    [self setUpAddButton];
    [self setUpCaretView];
}

- (void)setUpTitleLabel {
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"Title";
    
    NSLayoutConstraint *centerY, *leading;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        centerY = [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.titleLabel.superview.centerYAnchor];
        leading = [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.caretView.trailingAnchor constant:16.0];
    }
    
    [NSLayoutConstraint activateConstraints:@[centerY, leading]];
}

- (void)setUpAddButton {
    self.addButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"AddButtonIcon"] forState:UIControlStateNormal];
    self.addButton.titleLabel.text = @"Add";
    // registe add button touch
    [self.addButton addTarget:self action:@selector(addButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint *width, *height, *centerY, *trailing;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        width =[self.addButton.widthAnchor constraintEqualToConstant:40];
        height = [self.addButton.heightAnchor constraintEqualToAnchor:self.addButton.widthAnchor multiplier:1.0];
        centerY = [self.addButton.centerYAnchor constraintEqualToAnchor:self.addButton.superview.centerYAnchor];
        trailing = [self.addButton.trailingAnchor constraintEqualToAnchor:self.addButton.superview.trailingAnchor constant:-16.0];
    }
    
    [NSLayoutConstraint activateConstraints:@[width, height, centerY, trailing]];
}

- (void)setUpCaretView {
    self.caretView.strokeColor = PRIMARY_COLOR;
    self.caretView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // WARNING:Them leading neu loi
    NSLayoutConstraint *width, *height, *centerY, *leading;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        width =[self.caretView.widthAnchor constraintEqualToConstant:30];
        height = [self.caretView.heightAnchor constraintEqualToAnchor:self.caretView.widthAnchor multiplier:1.0/1.5];
        centerY = [self.caretView.centerYAnchor constraintEqualToAnchor:self.caretView.superview.centerYAnchor];
        leading = [self.caretView.leadingAnchor constraintEqualToAnchor:self.caretView.superview.leadingAnchor constant:16.0];
    }
    
    [NSLayoutConstraint activateConstraints:@[width, height, centerY, leading]];
}

#pragma mark - UI Event
- (void)addButtonTouchUpInside:(id)sender {
    [self.delegate collapseViewDidTouchButton:self];
}

@end

