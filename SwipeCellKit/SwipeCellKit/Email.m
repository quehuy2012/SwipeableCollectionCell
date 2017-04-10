//
//  Email.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "Email.h"

@implementation Email

- (instancetype)initWithSubject:(NSString *)subject from:(NSString *)from body:(NSString *)body date:(NSDate *)date {
    if (self = [super init]) {
        _subject = subject;
        _from = from;
        _body = body;
        _date = date;
    }
    return self;
}

- (NSString *)relativeDateString {
    if ([[NSCalendar currentCalendar] isDateInToday:self.date]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterShortStyle;
        return [formatter stringFromDate:self.date];
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.doesRelativeDateFormatting = YES;
        return [formatter stringFromDate:self.date];
    }
}
@end
