//
//  ZASwipeTableCell.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeTableCell.h"
#import "ZASwipeCellContext.h"
#import "ZASwipeCellHandler.h"
#import "ZASwipeActionsView.h"
#import "UITableView+SwipeCellKit.h"

@interface ZASwipeTableCell ()

@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, readonly) ZASwipeCellHandler *swipeHandler;

@end

@implementation ZASwipeTableCell

- (CGRect)frame {
    return [super frame];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:self.context.state != ZASwipeStateCenter ? CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(frame), frame.size.width, frame.size.height) : frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    @try {
        [self removeObserver:self forKeyPath:@"center"];
    } @catch(id anException){
    
    }
    
    [self.parentView.panGestureRecognizer removeTarget:self action:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
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

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.swipeHandler reset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"center" compare:keyPath] == NSOrderedSame) {
        self.context.actionsView.visibleWidth = fabs(CGRectGetMinX(self.frame));
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    UIView *view = self;
    while (view) {
        view = view.superview;
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;
            self.parentView = tableView;

            [tableView.panGestureRecognizer removeTarget:self action:nil];
            [tableView.panGestureRecognizer addTarget:self action:@selector(handleTablePanGesture:)];
            return;
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint pointInSuperView = [self convertPoint:point toView:self.superview];
    if (!UIAccessibilityIsVoiceOverRunning()) {
        for (UIView<ZASwipeable> *cell in self.parentView.swipeCells) {
            ZASwipeTableCell *tableViewCell = (ZASwipeTableCell *)cell;
            if ((cell.context.state == ZASwipeStateLeft || cell.context.state == ZASwipeStateRight) && ![tableViewCell containsPoint:pointInSuperView]) {
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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.context.state == ZASwipeStateCenter) {
        [super setHighlighted:highlighted animated:animated];
    }
}

- (void)hideSwipeWithAnimation:(BOOL)animated {
    [self.swipeHandler hideSwipeWithAnimation:animated];
}

#pragma mark - Gesture
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    if (self.isEditing) {
        return;
    }
    
    [self.swipeHandler handlePanGesture:gesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    [self.swipeHandler handleTapGesture:gesture];
}

- (void)handleTablePanGesture:(UIPanGestureRecognizer *)gesture {
    [self.swipeHandler handleCellParentPanGesture:gesture];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGestureRecognizer) {

        NSArray<UIView<ZASwipeable> *> *cells = [self.parentView swipeCells];
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
