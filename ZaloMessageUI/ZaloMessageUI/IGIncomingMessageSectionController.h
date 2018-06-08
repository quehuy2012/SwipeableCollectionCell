//
//  IGIncomingMessageSectionController.h
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/23/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import "IGCollapseSupplementary.h"
#import "ZASwippableCell.h"

@interface IGIncomingMessageSectionController : IGListSectionController < IGCollapseSupplementaryDelegate, IGListDisplayDelegate, ZASwippableCellDelegate>
@property (nonatomic, readwrite, copy) NSString *sectionTitle;
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;
@end
