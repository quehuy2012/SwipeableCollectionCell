//
//  ZASwipeTableViewCell.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeTableViewCell.h"
#import "ZASwipeActionsView.h"
#import "ZASwipeExpansionStyle.h"
#import "ZASwipeCellOptions.h"
#import "ZASwipeAccessibilityCustomAction.h"
#import "UIPanGestureRecognizer+SwipeCellKit.h"
#import "UITableView+SwipeCellKit.h"

@interface ZASwipeTableViewCell () <ZASwipeActionsViewDelegate, ZASwipeable, UIGestureRecognizerDelegate>

@end

@implementation ZASwipeTableViewCell

//@synthesize swipeViewFrame = _frame;
@synthesize layoutMargins = _layoutMargins;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return self.frame.origin.x != 0 ? _originalLayoutMargins : [super layoutMargins];
}


#pragma mark - Life cycle

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self reset];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"center"];
    [self.tableView.panGestureRecognizer removeTarget:self action:nil];
}

- (void)setUp {
    _state = ZASwipeStateCenter;
    _originalLayoutMargins = UIEdgeInsetsZero;
    _originalCenter = 0;
    _elasticScrollRatio = 1.0;
    _scrollRatio = 1.0;
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    _panGestureRecognizer.delegate = self;
    _tapGestureRecognizer.delegate = self;
    
    [self addGestureRecognizer:_panGestureRecognizer];
    [self addGestureRecognizer:_tapGestureRecognizer];
    self.clipsToBounds = NO;
    
    self.userInteractionEnabled = YES;
    
    [self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"center" compare:keyPath] == NSOrderedSame) {
        self.actionsView.visibleWidth = fabs(CGRectGetMinX(self.frame));
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    UIView *view = self;
    while (view) {
        view = view.superview;
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;
            self.tableView = tableView;
            
            [tableView.panGestureRecognizer removeTarget:self action:nil];
            [tableView.panGestureRecognizer addTarget:self action:@selector(handleTablePanGesture:)];
            return;
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        [self hideSwipeWithAnimation:NO];
    }
}


#pragma mark - Gesture
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
//    CGPoint location = [gesture locationInView:self.tableView];
//    NSLog(@"Pan position: (%f, %f)", location.x, location.y);
   
    
    if (self.editing == YES || gesture.view == nil) {
        return;
    }
    
    UIView *target = gesture.view;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            UITableViewCell *cell = gesture.view;
            NSIndexPath *cellIndex = [self.tableView indexPathForCell:cell];
            NSLog(@"Panning Cell At Index: %d", cellIndex.row);
            self.originalCenter = self.center.x;
            
            if (self.state == ZASwipeStateCenter || self.state == ZASwipeStateAnimatingToCenter) {
                CGPoint velocity = [gesture velocityInView:target];
                ZASwipeActionsOrientation orientation = velocity.x > 0 ? ZASwipeActionsOrientationLeft : ZASwipeActionsOrientationRight;
                [self showActionsViewForOrientation:orientation];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
            if (!self.actionsView) {
                return;
            }
            
            CGFloat translation = [gesture translationInView:target].x;
            self.scrollRatio = 1.0;
            
            // Check if dragging past the center of the oppsite direction of action view
            if ( (translation + self.originalCenter - CGRectGetMidX(self.bounds)) * self.actionsView.orientation > 0) {
                CGPoint center = target.center;
                center.x = [gesture elasticTranslationInView:target withLimit:CGSizeZero fromOriginalCenter:CGPointMake(self.originalCenter, 0)].x;
                target.center = center;
                
                self.scrollRatio = self.elasticScrollRatio;
                return;
            }
            
            if (self.actionsView.options.expansionStyle) {
                ZASwipeExpansionStyle *expansionStyle = self.actionsView.options.expansionStyle;
                BOOL expanded = [expansionStyle shouldExpandView:self ByGesture:gesture inSuperView:self.tableView];
                CGFloat targetOffset = [expansionStyle targetOffsetForView:self inSuperview:self.tableView];
                CGFloat currentOffset = fabs(translation + self.originalCenter - CGRectGetMidX(self.bounds));
                
                if (expanded && !self.actionsView.expanded && targetOffset > currentOffset) {
                    CGFloat centerForTranslationToEdge = CGRectGetMidX(self.bounds) - targetOffset * self.actionsView.orientation;
                    CGFloat delta = centerForTranslationToEdge - self.originalCenter;
                    
                    // [self animateToOffset: centerForTranslationToEdge];
                    [self animateWithDuration:0.7 toOffset:centerForTranslationToEdge withInitialVelocity:0 completion:nil];
                    [gesture setTranslation:CGPointMake(delta, 0) inView:self.superview];
                }
                else {
                    CGPoint center = target.center;
                    center.x = [gesture elasticTranslationInView:target withLimit:CGSizeMake(targetOffset, 0) fromOriginalCenter:CGPointMake(self.originalCenter, 0)].x;
                    target.center = center;
                }
                
                self.actionsView.expanded = expanded;
            }
            else {
                CGPoint center = target.center;
                center.x = [gesture elasticTranslationInView:target
                                                   withLimit:CGSizeMake(self.actionsView.preferredWidth, 0)
                                          fromOriginalCenter:CGPointMake(self.originalCenter, 0)
                                               applyingRatio:self.elasticScrollRatio].x;
                target.center = center;
                if ((target.center.x - self.originalCenter) / translation != 1.0) {
                    self.scrollRatio = self.elasticScrollRatio;
                }
                
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (!self.actionsView) {
                return;
            }
            
            CGPoint velocity = [gesture velocityInView:target];
            self.state = [self targetStateForVelocity:velocity];
            
            if (self.actionsView.expanded == YES && self.actionsView.expandableAction) {
                [self performAction:self.actionsView.expandableAction];
            }
            else {
                CGFloat targetOffset = [self targetCenterActive:(self.state != ZASwipeStateCenter)];
                CGFloat distance = targetOffset - self.center.x;
                CGFloat normalizedVelocity = velocity.x * self.scrollRatio / distance;

                __weak typeof(self) weakSelf = self;
                [self animateWithDuration:0.7 toOffset:targetOffset withInitialVelocity:normalizedVelocity completion:^{
                    if (weakSelf.state == ZASwipeStateCenter) {
                        [weakSelf reset];
                    }
                }];
                
                if (self.state == ZASwipeStateCenter) {
                    [self notifyEditingStateChangeIsActive:NO];
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)handleTapGesture:(UIGestureRecognizer *)gesture {
    NSLog(@"Tapping");
    [self hideSwipeWithAnimation:YES];
}

- (void)handleTablePanGesture:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self hideSwipeWithAnimation:YES];
    }
}

#pragma mark - Private

- (BOOL)showActionsViewForOrientation:(ZASwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    NSArray<ZASwipeAction *> *actions;
    
    if (!indexPath) {
        return NO;
    }
    actions = [self.delegate tableView:self.tableView editActionsForRowAtIndexPath:indexPath forOrientation:orientation];
    if (actions == nil || actions.count == 0) {
        return NO;
    }
    
    
    self.originalLayoutMargins = super.layoutMargins;
    
    // Remove hightlight and deselect any selected cells
    [self setHighlighted:NO];
    NSArray<NSIndexPath *> *selectedIndexPaths = self.tableView.indexPathsForSelectedRows;
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    // Temporarily remove table gestures
    [self.tableView setGestureEnabled:NO];
    
    [self configureActionsViewWithActions:actions forOrientation:orientation];
    
    return YES;
}

- (void)configureActionsViewWithActions:(NSArray<ZASwipeAction *> *)actions
                         forOrientation:(ZASwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (!indexPath) {
        return;
    }
    
    ZASwipeCellOptions *options = [self.delegate tableView:self.tableView editActionsOptionsForRowAtIndexPath:indexPath forOrientation:orientation];
    if (!options) {
        options = [[ZASwipeCellOptions alloc] init];
    }
    
    [self.actionsView removeFromSuperview];
    self.actionsView = nil;
    
    ZASwipeActionsView *actionsView = [[ZASwipeActionsView alloc] initWithMaxSize:self.bounds.size option:options orientation:orientation actions:actions];
    actionsView.delegate = self;
    [self addSubview:actionsView];

    NSLayoutConstraint *height, *width, *top, *pinHorizontal;
    height = [actionsView.heightAnchor constraintEqualToAnchor:self.heightAnchor];
    width = [actionsView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:2.0];
    top = [actionsView.topAnchor constraintEqualToAnchor:self.topAnchor];
    
    if (orientation == ZASwipeActionsOrientationLeft) {
        pinHorizontal = [actionsView.rightAnchor constraintEqualToAnchor:self.leftAnchor];
    }
    else {
        pinHorizontal = [actionsView.leftAnchor constraintEqualToAnchor:self.rightAnchor];
    }
    [NSLayoutConstraint activateConstraints:@[height, width, top, pinHorizontal]];
    
    self.actionsView = actionsView;
    [self notifyEditingStateChangeIsActive:YES];
}

- (void)notifyEditingStateChangeIsActive:(BOOL)active {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (indexPath && self.actionsView) {
        if (active) {
            [self.delegate tableView:self.tableView willBeginEdittingRowAtIndexPath:indexPath forOrientation:self.actionsView.orientation];
        }
        else {
            [self.delegate tableView:self.tableView didEndEdittingRowAtIndexPath:indexPath forOrientation:self.actionsView.orientation];
        }
    }
}

- (void)animateWithDuration:(double)duration toOffset:(CGFloat)offset withInitialVelocity:(CGFloat)velocity completion:(void (^)())completion {
    [self layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint newCenter = CGPointMake(offset, weakSelf.center.y);
        weakSelf.center = newCenter;
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)animateToOffset:(CGFloat)offset completion:(void (^)())completion {
    [self animateWithDuration:0.7 toOffset:offset withInitialVelocity:0 completion:completion];
}

// This is required to detect touches on the ZASwipeActionView sitting along the ZASwipeTableCell
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint pointInSuperView = [self convertPoint:point toView:self.superview];
    
    if (!UIAccessibilityIsVoiceOverRunning()) {
        for (ZASwipeTableViewCell *cell in self.tableView.swipeCells) {
            if ((cell.state == ZASwipeStateLeft || cell.state == ZASwipeStateRight) && ![cell containsPoint:pointInSuperView]) {
                [self.tableView hideSwipeCell];
                return NO;
            }
        }
    }
    
    return [self containsPoint:point];
}

- (BOOL)containsPoint:(CGPoint)point {
    return point.y > CGRectGetMinY(self.frame) && point.y < CGRectGetMaxX(self.frame);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.state == ZASwipeStateCenter) {
        [super setHighlighted:highlighted animated:animated];
    }
}

#pragma mark - Swipe state

- (ZASwipeState)targetStateForVelocity:(CGPoint)velocity {
    if (!self.actionsView) {
        return ZASwipeStateCenter;
    }
    
    switch (self.actionsView.orientation) {
        case ZASwipeActionsOrientationLeft:
            return (velocity.x < 0 && !self.actionsView.expanded) ? ZASwipeStateCenter : ZASwipeStateLeft;
            break;
        case ZASwipeActionsOrientationRight:
            return (velocity.x > 0 && !self.actionsView.expanded) ? ZASwipeStateCenter: ZASwipeStateRight;
        default:
            break;
    }
}

- (CGFloat)targetCenterActive:(BOOL)active {
    if (self.actionsView && active == true) {
        return CGRectGetMidX(self.bounds) - self.actionsView.preferredWidth * self.actionsView.orientation;
    }
    else {
        return CGRectGetMidX(self.bounds);
    }
}

- (void)reset {
    self.state = ZASwipeStateCenter;
    
    [self.tableView setGestureEnabled:YES];
    
    [self.actionsView removeFromSuperview];
    self.actionsView = nil;
}

- (void)hideSwipeWithAnimation:(BOOL)animated {
    if (self.state != ZASwipeStateLeft &&
        self.state != ZASwipeStateRight) {
        return;
    }
    
    self.state = ZASwipeStateAnimatingToCenter;
    
    [self.tableView setGestureEnabled:YES];
    
    CGFloat targetCenter = [self targetCenterActive:NO];
    
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [self animateToOffset:targetCenter completion:^{
            [weakSelf reset];
        }];
    }
    else {
        self.center = CGPointMake(targetCenter, self.center.y);
        [self reset];
    }
    
    [self notifyEditingStateChangeIsActive:NO];
}

- (void)showSwipe:(ZASwipeActionsOrientation)orientation animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    ZASwipeState targetState = orientation == ZASwipeActionsOrientationLeft ? ZASwipeStateLeft : ZASwipeStateRight;
    
    if (self.state == targetState || ![self showActionsViewForOrientation:orientation]) {
        return;
    }
    
    [self.tableView hideSwipeCell];
    
    self.state = targetState;
    
    CGFloat targetCenter = [self targetCenterActive:YES];
    
    if (animated) {
        [self animateToOffset:targetCenter completion:^{
#warning completion(position == .end)
            completion(YES);
        }];
    }
    else {
        CGPoint center = self.center;
        center.x = targetCenter;
        self.center = center;
    }
}

#pragma mark - ZASwipeActonViewDelgate
- (void)swipeActionView:(ZASwipeActionsView *)swipeActionsView didSelectAction:(ZASwipeAction *)action {
    [self performAction:action];
}

- (void)performAction:(ZASwipeAction *)action {
    if (!self.actionsView) {
        return;
    }
    
    if (action == self.actionsView.expandableAction && self.actionsView.options.expansionStyle) {
        // Trigger the expansion
        self.actionsView.expanded = YES;
        ZACompletionAnimation *completionAnimation = self.actionsView.options.expansionStyle.completionAnimation;
        
        switch (completionAnimation.animationStyle) {
            case ZACompletionAnimationStyleBounce:
                [self performAction:action hide:YES];
                break;
            case ZACompletionAnimationStyleFill:
                [self performFillAction:action fillOption:completionAnimation.fillOption];
                break;
            default:
                break;
        }
    }
    else {
        [self performAction:action hide:self.actionsView.expandableAction.hideWhenSelected];
    }
}

- (void)performAction:(ZASwipeAction *)action hide:(BOOL)hide {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (!indexPath) {
        return;
    }
    
    if (hide) {
        [self hideSwipeWithAnimation:YES];
    }
    
    if (action.handler) {
        action.handler(action, indexPath);
    }
}

- (void)performFillAction:(ZASwipeAction *)action fillOption:(ZAFillOption *)fillOption {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (!self.actionsView || !indexPath) {
        return;
    }
    
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(MIN(0, CGRectGetMinX(self.actionsView.frame)), 0, self.bounds.size.width + self.actionsView.bounds.size.width, self.bounds.size.height)];
    mask.backgroundColor = [UIColor whiteColor];
    self.maskView = mask;
    
    CGFloat newCenter = CGRectGetMidX(self.bounds) - (self.bounds.size.width + self.actionsView.minimumButtonWidth) * self.actionsView.orientation;
    
    __weak typeof(self) weakSelf = self;
    __weak ZASwipeAction *weakAction = action;
    action.completionHandler = ^void(ZAExpansionFulfillmentStyle style) {
        weakAction.completionHandler = nil;
        
        [weakSelf.delegate tableView:weakSelf.tableView didEndEdittingRowAtIndexPath:indexPath forOrientation:weakSelf.actionsView.orientation];
        
        switch (style) {
            case ZAExpansionFulfillmentStyleDelete: {
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.center = CGPointMake(newCenter, weakSelf.center.y);
                    CGRect maskFrame = mask.frame;
                    maskFrame.size.height = 0;
                    mask.frame = maskFrame;
                    
                    if (fillOption.timming == ZAHandlerInvocationTimingAfter) {
                        weakSelf.actionsView.alpha = 0;
                    }
                } completion:^(BOOL finished) {
                    weakSelf.maskView = nil;
                    [weakSelf reset];
                }];
                break;
            }
            case ZAExpansionFulfillmentStyleReset: {
                [weakSelf hideSwipeWithAnimation:YES];
                break;
            }
            default:
                break;
        }
    };
    
    void (^invokeAction)() = ^void() {
        if (action.handler) {
            action.handler(action, indexPath);
        }
        
        if (fillOption.autoFulfillmentStyle != ZAHandlerInvocationTimingNone) {
            [action fulFillWithStyle:fillOption.autoFulfillmentStyle];
        }
    };
    
    [weakSelf animateWithDuration:0.3 toOffset:newCenter withInitialVelocity:0.0 completion:^{
        if (fillOption.timming == ZAHandlerInvocationTimingAfter) {
            invokeAction();
        }
    }];
    
    if (fillOption.timming == ZAHandlerInvocationTimingWith) {
        invokeAction();
    }
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGestureRecognizer) {
        if (UIAccessibilityIsVoiceOverRunning()) {
            [self.tableView hideSwipeCell];
        }
        
        NSArray<ZASwipeTableViewCell *> *cells = self.tableView.visibleCells;
        for (ZASwipeTableViewCell *cell in cells) {
            if (cell.state != ZASwipeStateCenter) {
                return YES;
            }
        }
        
        return NO;
    }
    
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIView *view = gestureRecognizer.view;
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        
        CGPoint translation = [panGesture translationInView:view];
        return fabs(translation.y) <= fabs(translation.x);
    }
    
    return YES;
}

#pragma mark - Accessibility
- (NSInteger)accessibilityElementCount {
    if (self.state == ZASwipeStateCenter) {
        return [super accessibilityElementCount];
    }
    return 1;
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    if (self.state == ZASwipeStateCenter) {
        return [super accessibilityElementAtIndex:index];
    }
    return self.actionsView;
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    if (self.state == ZASwipeStateCenter) {
        return [super indexOfAccessibilityElement:element];
    }
    return [element isKindOfClass:[ZASwipeActionsView class]] ? 0 : NSNotFound;
}

- (NSArray<UIAccessibilityCustomAction *> *)accessibilityCustomActions {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    if (!indexPath) {
        return [super accessibilityCustomActions];
    }
    
    NSArray<ZASwipeAction *> *leftActions = [self.delegate tableView:self.tableView editActionsForRowAtIndexPath:indexPath forOrientation:ZASwipeActionsOrientationLeft];
    NSArray<ZASwipeAction *> *rightActions = [self.delegate tableView:self.tableView editActionsForRowAtIndexPath:indexPath forOrientation:ZASwipeActionsOrientationRight];
    
    NSMutableArray<ZASwipeAction *> *actions = [NSMutableArray array];
    [actions addObject:rightActions.firstObject];
    [actions addObject:leftActions.firstObject];
    for (ZASwipeAction *action in rightActions) {
        if (action != rightActions.firstObject) {
            [actions addObject:action];
        }
    }
    for (ZASwipeAction *action in leftActions) {
        if (action != leftActions.firstObject) {
            [actions addObject:action];
        }
    }
    
    if (actions.count > 0) {
        NSMutableArray<UIAccessibilityCustomAction *> *customActions = [NSMutableArray array];
        for (ZASwipeAction *action in actions) {
            ZASwipeAccessibilityCustomAction *customAction = [[ZASwipeAccessibilityCustomAction alloc] initWithAction:action indexPath:indexPath target:self selector:@selector(performAccessibilityCustomAction:)];
            
            [customActions addObject:customAction];
        }
        return [customActions copy];
    }
    else {
        return [super accessibilityCustomActions];
    }
    
}

- (BOOL)performAccessibilityCustomAction:(ZASwipeAccessibilityCustomAction *)accessibilityCustomAction {
    if (!self.tableView) {
        return NO;
    }
    
    ZASwipeAction *action = accessibilityCustomAction.action;
    
    if (action.handler) {
        action.handler(action, accessibilityCustomAction.indexPath);
    }
    
    if (action.style == ZASwipeActionStyleDestructive) {
        [self.tableView deleteRowsAtIndexPaths:@[accessibilityCustomAction.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    return YES;
}

@end
