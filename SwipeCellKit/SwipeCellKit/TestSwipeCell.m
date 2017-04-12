//
//  TestSwipeCell.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/11/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "TestSwipeCell.h"
#import "IndicatorView.h"

@implementation TestSwipeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)prepareForReuse {
    [self setNeedsLayout];
}

- (void)setup {
    _fromLabel = [[UILabel alloc] init];
    _subjectLabel  = [[UILabel alloc] init];
    _bodyLabel = [[UILabel alloc] init];
    _dateLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:_fromLabel];
    [self.contentView addSubview:_subjectLabel];
    [self.contentView addSubview:_bodyLabel];
    [self.contentView addSubview:_dateLabel];
    
    [self setupFromLabel];
    [self setupSubjectLabel];
    [self setupBodyLabel];
    [self setupDateLabel];
}

- (void)setupFromLabel {
    self.fromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fromLabel.numberOfLines = 1;
    
    NSLayoutConstraint *top, *left, *right;
    top = [self.fromLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16];
    left = [self.fromLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16];
    right = [self.fromLabel.rightAnchor constraintGreaterThanOrEqualToAnchor:self.dateLabel.leftAnchor constant:-16];
    
    [NSLayoutConstraint activateConstraints:@[top, left, right]];
}

- (void)setupSubjectLabel {
    self.subjectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subjectLabel.numberOfLines = 1;
    
    NSLayoutConstraint *top, *left, *right;
    top = [self.subjectLabel.topAnchor constraintEqualToAnchor:self.fromLabel.bottomAnchor constant:8];
    left = [self.subjectLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16];
    right = [self.subjectLabel.rightAnchor constraintLessThanOrEqualToAnchor:self.contentView.rightAnchor constant:-16];
    
    [NSLayoutConstraint activateConstraints:@[top, left, right]];
}

- (void)setupBodyLabel {
    self.bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyLabel.numberOfLines = 2;
    
    NSLayoutConstraint *top, *left, *right;
    top = [self.bodyLabel.topAnchor constraintEqualToAnchor:self.subjectLabel.bottomAnchor constant:8];
    left = [self.bodyLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16];
    right = [self.bodyLabel.rightAnchor constraintLessThanOrEqualToAnchor:self.contentView.rightAnchor constant:-16];
    
    [NSLayoutConstraint activateConstraints:@[top, left, right]];
}

- (void)setupDateLabel {
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *baseLine, *right;
    baseLine = [self.dateLabel.firstBaselineAnchor constraintEqualToAnchor:self.fromLabel.firstBaselineAnchor];
    right = [self.dateLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16];
    
    [NSLayoutConstraint activateConstraints:@[baseLine, right]];
}

@end
