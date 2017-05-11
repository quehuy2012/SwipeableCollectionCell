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
#import "ZACheckMark.h"
#import "UICollectionView+SwipeCellKit.h"

#define EDITING_MARGIN 8

@interface ZASwipeCollectionCell () <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, readonly) ZASwipeCellHandler *swipeHandler;

@property (nonatomic, readwrite) NSLayoutConstraint *checkMarkLeading;
@property (nonatomic, readwrite) ZACheckMark *checkMark;



@end

@implementation ZASwipeCollectionCell

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    
    if (editing) {
        self.checkMarkLeading.constant = 8;
    } else {
        self.checkMarkLeading.constant = -self.checkMark.bounds.size.width - EDITING_MARGIN * 4;
    }

    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        
    }];

    [UIView animateWithDuration:0.2 animations:^{
        self.checkMark.alpha = editing ? 1.0 : 0;
    }];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    _editing = editing;
    
    if (editing) {
        self.checkMarkLeading.constant = 8;
    } else {
        self.checkMarkLeading.constant = -self.checkMark.bounds.size.width - EDITING_MARGIN * 4;
    }

    if (animated) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
            
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.checkMark.alpha = editing ? 1.0 : 0;
        }];
    }
    else {
        [self layoutIfNeeded];
    }
}

- (void)setSelected:(BOOL)selected {
    if(super.selected == selected) {
        return;
    }
    
    [super setSelected:selected];
    
    [self.checkMark setChecked:selected animated:YES];
}

- (void)setParentView:(UIView<ZASwipeCellParentViewProtocol> *)parentView {
    _parentView = parentView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.editing) {
        self.contentView.frame = CGRectMake(self.checkMark.frame.size.width + EDITING_MARGIN, 0, self.bounds.size.width - (self.checkMark.frame.size.width + EDITING_MARGIN), self.bounds.size.height);
    } else {
        self.contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
}

- (CGRect)frame {
    return [super frame];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:self.context.state != ZASwipeStateCenter ? CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(frame), frame.size.width, frame.size.height) : frame];
}

- (void)dealloc {
    NSLog(@"Cell dealloc");
    
    @try {
        [self removeObserver:self forKeyPath:@"center"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    _checkMark = [[ZACheckMark alloc] init];
    _swipeHandler = [[ZASwipeCellHandler alloc] initWithCell:self];
    _context = [[ZASwipeCellContext alloc] init];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    _panGestureRecognizer.delegate = self;
    _tapGestureRecognizer.delegate = self;
    
    self.clipsToBounds = NO;
    [self setupCheckMark];
    
    [self addGestureRecognizer:self.panGestureRecognizer];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    [self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupCheckMark {
    [self addSubview:self.checkMark];
    self.checkMark.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading = [self.checkMark.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:-22];
    NSLayoutConstraint *width = [self.checkMark.widthAnchor constraintEqualToConstant:22];
    NSLayoutConstraint *height = [self.checkMark.heightAnchor constraintEqualToConstant:22];
    NSLayoutConstraint *centerY = [self.checkMark.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    self.checkMarkLeading = leading;
    
    [NSLayoutConstraint activateConstraints:@[leading, width, height, centerY]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"center" compare:keyPath] == NSOrderedSame) {
        self.context.actionsView.visibleWidth = fabs(CGRectGetMinX(self.frame));
        return;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.swipeHandler reset];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSwipeCellKitCollectionEditingNotification object:nil];
    
    UIView *view = self;
    while(view) {
        view = view.superview;
        if ([view isKindOfClass:[UICollectionView class]]) {
            UICollectionView<ZASwipeCellParentViewProtocol> *collectionView = (UICollectionView<ZASwipeCellParentViewProtocol> *)view;
            self.parentView = collectionView;
            
            [collectionView.panGestureRecognizer removeTarget:self action:nil];
            [collectionView.panGestureRecognizer addTarget:self action:@selector(handleCollectionPanGesture:)];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyParentViewEditingChange:) name:kSwipeCellKitCollectionEditingNotification object:nil];
            
            [self setEditing:collectionView.editing animated:NO];
            
            return;
        }
    }
}

- (void)notifyParentViewEditingChange:(NSNotification *)notification {
    if ([notification.name  isEqual: kSwipeCellKitCollectionEditingNotification]) {
        self.editing = self.parentView.editing;
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
    if (self.parentView.editing) {
        return;
    }
    
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
