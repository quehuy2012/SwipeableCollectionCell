//
//  TestSwipeCell.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/11/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeTableViewCell.h"

@class IndicatorView;

@interface TestSwipeCell : ZASwipeTableViewCell

@property (nonatomic) IBOutlet UILabel *fromLabel;
@property (nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) IBOutlet UILabel *subjectLabel;
@property (nonatomic) IBOutlet UILabel *bodyLabel;

@property (nonatomic, readwrite) IndicatorView *indicatorView;
@property (nonatomic, readwrite) BOOL unread;

@end
