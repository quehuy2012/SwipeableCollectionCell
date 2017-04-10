//
//  ZAFillOption.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZAFillOption.h"

@implementation ZAFillOption

- (instancetype)initWithStyle:(ZAExpansionFulfillmentStyle)style timing:(ZAHandlerInvocationTiming)timing {
    if (self = [super init]) {
        _autoFulfillmentStyle = style;
        _timming = timing;
    }
    return self;
}

+ (instancetype)automaticWithStyle:(ZAExpansionFulfillmentStyle)style timing:(ZAHandlerInvocationTiming)timing {
    return [[ZAFillOption alloc] initWithStyle:style timing:timing];
}

+ (instancetype)manualWithTiming:(ZAHandlerInvocationTiming)timing {
    return [[ZAFillOption alloc] initWithStyle:ZAExpansionFulfillmentStyleNone timing:timing];
}

@end
