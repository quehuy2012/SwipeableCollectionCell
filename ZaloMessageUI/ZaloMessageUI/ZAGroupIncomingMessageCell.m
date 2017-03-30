//
//  ZAGroupIncomingCell.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/23/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZAGroupIncomingMessageCell.h"
#import "ZAIncomingMessageCellProtected.h"

@interface ZAGroupIncomingMessageCell ()

/**
 Array chứa những imageView dùng để hiển thị profile image của các member trong group
 */
@property (nonatomic, readonly) NSArray<UIImageView *> *imageViews;

@end

@implementation ZAGroupIncomingMessageCell

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

#pragma mark - Setup
- (void)setUp {
    [super setUp];
    
    _imageViews = @[
                    [[UIImageView alloc] init],
                    [[UIImageView alloc] init],
                    [[UIImageView alloc] init],
                    [[UIImageView alloc] init]
                    ];
    
    for (UIImageView *imageView in self.imageViews) {
        [self.imageContainerView addSubview:imageView];
        self.imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageContainerView.opaque = YES;
    }
}

- (void)displayProfileImagas:(NSArray<UIImage *> *)profileImages {
    if (![profileImages isKindOfClass:[NSArray class]] || !profileImages || profileImages.count == 0) {
        // show default image if needed
        return;
    }
    
    // Khi cell mói được tạo thì đã có bounds nhưng chưa layout mấy thằng subview
    // Phải force layout thì mới bắt đầu autolayout imageContainerView
    if(CGRectEqualToRect(self.imageContainerView.bounds, CGRectZero)) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
    CGFloat containerWidth = self.imageContainerView.bounds.size.width;
    CGFloat containerHeight = self.imageContainerView.bounds.size.height;
    CGFloat offset = containerHeight / 12;
    
    // layout image views
    switch (profileImages.count) {
        case 1:
            self.imageViews[0].frame = CGRectMake(0, 0, containerWidth, containerHeight);
            
            self.imageViews[1].hidden = YES;
            self.imageViews[2].hidden = YES;
            self.imageViews[3].hidden = YES;
            break;
        case 2:
            self.imageViews[0].frame = CGRectMake(0, offset, containerWidth/2 + offset, containerHeight/2 + offset);
            self.imageViews[1].frame = CGRectMake(containerWidth/2, containerHeight/2 - offset, containerWidth/2 + offset, containerHeight/2 + offset);
            
            self.imageViews[1].hidden = NO;
            self.imageViews[2].hidden = YES;
            self.imageViews[3].hidden = YES;
            break;

        case 3:
            self.imageViews[0].frame = CGRectMake(containerWidth/4, offset, containerWidth/2, containerHeight/2);
            self.imageViews[1].frame = CGRectMake(0, containerHeight/2, containerWidth/2, containerHeight/2);
            self.imageViews[2].frame = CGRectMake(containerWidth/2, containerHeight/2, containerWidth/2, containerHeight/2);
            
            self.imageViews[1].hidden = NO;
            self.imageViews[2].hidden = NO;
            self.imageViews[3].hidden = YES;
            break;
        default:
            self.imageViews[0].frame = CGRectMake(0, 0, containerWidth/2, containerHeight/2);
            self.imageViews[1].frame = CGRectMake(containerWidth/2, 0, containerWidth/2, containerHeight/2);
            self.imageViews[2].frame = CGRectMake(0, containerHeight/2, containerWidth/2, containerHeight/2);
            self.imageViews[3].frame = CGRectMake(containerWidth/2, containerHeight/2, containerWidth/2, containerHeight/2);
            
            self.imageViews[0].hidden = NO;
            self.imageViews[1].hidden = NO;
            self.imageViews[2].hidden = NO;
            self.imageViews[3].hidden = NO;
            break;
    }
    
    NSInteger imageCount = MIN(profileImages.count, 4);
    for (NSInteger i = 0; i < imageCount; i++) {
        self.imageViews[i].image = profileImages[i];
    }
    
    [self.imageContainerView layoutIfNeeded];
}

@end
