//
//  ZASwipeViewCell.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeViewCell.h"
#import "ZASwipeActionState.h"
#import "ZASwipeActionsView.h"

@interface ZASwipeViewCell ()

@end

@implementation ZASwipeViewCell

#pragma mark - Life cycle

- (void)prepareForReuse {
    [super prepareForReuse];
    
    //[self reset];
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

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"center"];
}

- (void)setUp {
    _state = [ZASwipeActionState center];
    _originalLayoutMargins = UIEdgeInsetsZero;
    _originalCenter = 0;
    _elasticScrollRatio = 0.4;
    _scrollRatio = 1.0;
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    [self addGestureRecognizer:_panGestureRecognizer];
    [self addGestureRecognizer:_tapGestureRecognizer];
    
    self.clipsToBounds = NO;
    
    [self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"center" compare:keyPath] == NSOrderedSame) {
        CGPoint newCenter = [change[NSKeyValueChangeNewKey] CGPointValue];
        NSLog(@"New center: (%f, %f)", newCenter.x, newCenter.y);
        
        self.actionsView.visibleWidth = fabs(CGRectGetMinX(self.frame));
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    UIView *view = self;
    while (view.superview) {
        view = view.superview;
        if ([view isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)view;
            self.collectionView = collectionView;
            
            [collectionView.panGestureRecognizer removeTarget:self action:nil];
            [collectionView.panGestureRecognizer addTarget:self action:@selector(handleTablePanGesture:)];
            return;
        }
    }
}

//TODO: setEditting equalment in collection view


#pragma mark - Gesture
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    
}

- (void)handleTablePanGesture:(UIPanGestureRecognizer *)gesture {
    
}

@end
