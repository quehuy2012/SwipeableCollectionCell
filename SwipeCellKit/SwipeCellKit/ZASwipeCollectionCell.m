//
//  ZASwipeCollectionCell.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/21/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeCollectionCell.h"
#import "ZASwipeCellContext.h"
#import "ZASwipeCellHandler.h"
#import "ZASwipeActionsView.h"
#import "UITableView+SwipeCellKit.h"

@interface ZASwipeCollectionCell () <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, readonly) ZASwipeCellHandler *swipeHandler;

@end

@implementation ZASwipeCollectionCell

- (CGRect)frame {
    return [super frame];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:self.context.state != ZASwipeStateCenter ? CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(frame), frame.size.width, frame.size.height) : frame];
}

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:@"center"];
    } @catch(id exception) {
        
    }
    
    [self.parentView.panGestureRecognizer removeTarget:self action:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _swipeHandler = [[ZASwipeCellHandler alloc] initWithCell:self];
    _context = [[ZASwipeCellContext alloc] init];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    _panGestureRecognizer.delegate = self;
    _tapGestureRecognizer.delegate = self;
    
    self.clipsToBounds = NO;
    [self addGestureRecognizer:self.panGestureRecognizer];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    [self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"center" compare:keyPath] == NSOrderedSame) {
        self.context.actionsView.visibleWidth = fabs(CGRectGetMinX(self.frame));
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.swipeHandler reset];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    UIView *view = self;
    while(view) {
        view = view.superview;
        if ([view isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)view;
            self.parentView = collectionView;
            
            [collectionView.panGestureRecognizer removeTarget:self action:nil];
            [collectionView.panGestureRecognizer addTarget:self action:@selector(handleCollectionPanGesture:)];
            return;
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint pointInSuperView = [self convertPoint:point toView:self.superview];
    if (!UIAccessibilityIsVoiceOverRunning()) {
        for (UIView<ZASwipeable> *cell in self.parentView.swipeCells) {
            ZASwipeCollectionCell *collectionViewCell = (ZASwipeCollectionCell *)cell;
            if ((cell.context.state == ZASwipeStateLeft || cell.context.state == ZASwipeStateRight) && ![collectionViewCell containsPoint:pointInSuperView]) {
                [self.parentView hideSwipeCell];
                return NO;
            }
        }
    }
    
    return [self containsPoint:pointInSuperView];
}

- (BOOL)containsPoint:(CGPoint)point {
    return point.y > CGRectGetMinY(self.frame) && point.y < CGRectGetMaxY(self.frame);
}

- (void)hideSwipeWithAnimation:(BOOL)animated {
    [self.swipeHandler hideSwipeWithAnimation:animated];
}

#pragma mark - Gesture 
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    [self.swipeHandler handlePanGesture:gesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    [self.swipeHandler handleTapGesture:gesture];
}

- (void)handleCollectionPanGesture:(UIPanGestureRecognizer *)gesture {
    [self.swipeHandler handleCellParentPanGesture:gesture];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGestureRecognizer) {
        if (UIAccessibilityIsVoiceOverRunning()) {
            [self.parentView hideSwipeCell];
        }
        
        NSArray<UIView<ZASwipeable> *> *cells = self.parentView.swipeCells;
        for (UIView<ZASwipeable> *cell in cells) {
            if (cell.context.state != ZASwipeStateCenter) {
                return YES;
            }
        }
        
        return NO;
    }
    
    if (gestureRecognizer == self.panGestureRecognizer && gestureRecognizer.view && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIView *view = gestureRecognizer.view;
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        
        CGPoint translation = [panGesture translationInView:view];
        return fabs(translation.y) <= fabs(translation.x);
    }
    
    return YES;
}


@end
