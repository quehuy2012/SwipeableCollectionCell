//
//  MailTableViewCell.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/11/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "MailTableViewCell.h"
#import "IndicatorView.h"

@implementation MailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupIndicatorView];
}
- (IBAction)tapped:(id)sender {
    NSLog(@"Tapped");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupIndicatorView {
    self.indicatorView = [[IndicatorView alloc] initWithFrame:CGRectZero];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView.color = self.tintColor;
    self.indicatorView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.indicatorView];
    
    CGFloat size = 12;
    NSLayoutConstraint *width, *height, *left, *centerY;
    width = [self.indicatorView.widthAnchor constraintEqualToConstant:size];
    height = [self.indicatorView.heightAnchor constraintEqualToAnchor:self.indicatorView.widthAnchor];
    left = [self.indicatorView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:12];
    centerY = [self.indicatorView.centerYAnchor constraintEqualToAnchor:self.fromLabel.centerYAnchor];
    
    [NSLayoutConstraint activateConstraints:@[width, height, left, centerY]];
}

- (void)setUnread:(BOOL)unread {
    CGFloat dutation = unread ? 1.0 : 0.3;
    CGFloat dampingRatio = unread ? 0.4 : 1.0;
    
    [UIView animateWithDuration:dutation delay:0 usingSpringWithDamping:dampingRatio initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _unread = unread;
        _indicatorView.transform = unread ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.001, 0.001);
    } completion:nil];
}


@end
