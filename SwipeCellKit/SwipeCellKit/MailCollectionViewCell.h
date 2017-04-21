//
//  MailCollectionViewCell.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/21/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASwipeCellKit.h"

@class IndicatorView;

@interface MailCollectionViewCell : ZASwipeCollectionCell
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@property (nonatomic, readwrite) IndicatorView *indicatorView;
@property (nonatomic, readwrite) BOOL unread;

@end
