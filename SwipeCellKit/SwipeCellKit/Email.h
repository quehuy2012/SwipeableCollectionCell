//
//  Email.h
//  SwipeCellKit
//
//  Created by CPU11713 on 4/10/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Email : NSObject

@property (nonatomic, readwrite) NSString *from;
@property (nonatomic, readwrite) NSString *subject;
@property (nonatomic, readwrite) NSString *body;
@property (nonatomic, readwrite) NSDate *date;
@property (nonatomic, readwrite) BOOL unread;

- (instancetype)initWithSubject:(NSString *)subject from:(NSString *)from body:(NSString *)body date:(NSDate *)date;

- (NSString *)relativeDateString;
@end
