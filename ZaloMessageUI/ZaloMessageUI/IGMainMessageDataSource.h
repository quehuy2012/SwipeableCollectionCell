//
//  IGMainMessageDataSource.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>

@interface IGMainMessageDataSource : NSObject <IGListAdapterDataSource>

- (instancetype)initWithViewModels:(NSArray<id<IGListDiffable>> *)viewModels;
@end
