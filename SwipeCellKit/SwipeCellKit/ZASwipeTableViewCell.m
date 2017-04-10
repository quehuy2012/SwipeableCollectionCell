//
//  ZASwipeTableViewCell.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeTableViewCell.h"
#import "ZASwipeActionState.h"
#import "ZASwipeActionsView.h"
#import "ZASwipeExpansionStyle.h"
#import "ZASwipeCellOptions.h"
#import "UIPanGestureRecognizer+SwipeCellKit.h"
#import "UITableView+SwipeCellKit.h"

@interface ZASwipeTableViewCell () <ZASwipeActionsViewDelegate, ZASwipeable>

@end

@implementation ZASwipeTableViewCell

@synthesize actionsView = _actionsView;
@synthesize actionState = _actionState;
@synthesize frame = _frame;
@synthesize layoutMargins = _layoutMargins;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    _actionState = [ZASwipeActionState center];
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
        [self hideSwipeWithAnimation:animated];
    }
}


#pragma mark - Gesture
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    if (self.editing == NO || gesture.view == nil) {
        return;
    }
    
    UIView *target = gesture.view;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            //TODO: stopAnimatorIfNeeded
            
            self.originalCenter = self.center.x;
            
            if (self.actionState.state == ZASwipeStateCenter || self.actionState.state == ZASwipeStateAnimatingToCenter) {
                CGPoint velocity = [gesture velocityInView:target];
                ZASwipeActionsOrientation orientation = velocity.x > 0 ? ZASwipeActionsOrientationLeft : ZASwipeActionsOrientationRight;
                [self showActionsViewForOrientation:orientation];
            }
            break;
        
        case UIGestureRecognizerStateChanged:
            if (self.actionsView) {
                return;
            }
            
            CGFloat translation = [gesture translationInView:target].x;
            self.scrollRatio = 1.0;
            
            // Check if dragging past the center of the oppsite direction of action view
#warning debug antionView.orientation
            if ( (translation + self.originalCenter - CGRectGetMidX(self.bounds)) * self.actionsView.orientation) {
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
#warning animateToOffset
                    // [self animateToOffset: centerForTranslationToEdge];
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
            self.actionState = [self targetStateForVelocity:velocity];
            
            if (self.actionsView.expanded == YES && self.actionsView.expandableAction) {
                [self performAction:self.actionsView.expandableAction];
            }
            else {
                CGFloat targetOffset = [self targetCenterActive:self.actionState.isActive];
                CGFloat distance = targetOffset - self.center.x;
                CGFloat normalizedVelocity = velocity.x * self.scrollRatio / distance;
#warning animate
                //[self animateToOffset:targetOffset withInitialVelocity:normalizedVelocity];
                
                if (!self.actionState.isActive) {
                    [self notifyEditingStateChangeIsActive:NO];
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    [self hideSwipeWithAnimation:YES];
}

- (void)handleTablePanGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self hideSwipeWithAnimation:YES];
    }
}

#pragma mark - Private

- (BOOL)showActionsViewForOrientation:(ZASwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    NSArray<ZASwipeAction *> *actions;
    if (indexPath) {
        actions = [self.delegate tableView:self.tableView editActionsForRowAtIndexPath:indexPath forOrientation:orientation];
        if (actions == nil || actions.count == 0) {
            return NO;
        }
    }
    else {
        return NO;
    }
    
    self.originalLayoutMargins = [super layoutMargins];
    
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
    
#warning minimum required ios 9
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
    
    //stopAnimatorIfNeeded
    
    [self layoutIfNeeded];
    
#warning sua animator thanh animate de support ios 9
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:18.0 initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.center = CGPointMake(offset, self.center.y);
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

//TODO: stopAnimatorIfNeeded

// This is required to detect touches on the ZASwipeActionView sitting along the ZASwipeTableCell
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint pointInSuperView = [self convertPoint:point toView:self.superview];
    
    if (!UIAccessibilityIsVoiceOverRunning()) {
        for (ZASwipeTableViewCell *cell in self.tableView.swipeCells) {
            if ((cell.actionState.state == ZASwipeStateLeft || cell.actionState.state == ZASwipeStateRight) && ![cell containsPoint:pointInSuperView]) {
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
    if (self.actionState.state == ZASwipeStateCenter) {
        [super setHighlighted:highlighted animated:animated];
    }
}

#warning override super property with getter
- (UIEdgeInsets)layoutMargins {
    return self.frame.origin.x != 0 ? _originalLayoutMargins : _layoutMargins;
}

- (void)setLayoutMargins:(UIEdgeInsets)layoutMargins {
    _layoutMargins = layoutMargins;
}

#pragma mark - Swipe state

- (ZASwipeActionState *)targetStateForVelocity:(CGPoint)velocity {
    if (!self.actionsView) {
        return [ZASwipeActionState center];
    }
    
    switch (self.actionsView.orientation) {
        case ZASwipeActionsOrientationLeft:
            return (velocity.x < 0 && !self.actionsView.expanded) ? [ZASwipeActionState center] : [ZASwipeActionState left];
            break;
        case ZASwipeActionsOrientationRight:
            return (velocity.x > 0 && !self.actionsView.expanded) ? [ZASwipeActionState center] : [ZASwipeActionState right];
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
    self.actionState = [ZASwipeActionState center];
    
    [self.tableView setGestureEnabled:YES];
    
    [self.actionsView removeFromSuperview];
    self.actionState = nil;
}

- (void)hideSwipeWithAnimation:(BOOL)animated {
    if (self.actionState.state != ZASwipeStateLeft &&
        self.actionState.state != ZASwipeStateRight) {
        return;
    }
    
    self.actionState = [ZASwipeActionState animatingToCenter];
    
    [self.tableView setGestureEnabled:YES];
    
    CGFloat targetCenter = [self targetCenterActive:NO];
    
    if (animated) {
        [self animateToOffset:targetCenter completion:^{
            [self reset];
        }];
    }
    else {
        self.center = CGPointMake(targetCenter, self.center.y);
        [self reset];
    }
    
    [self notifyEditingStateChangeIsActive:NO];
}

- (void)showSwipe:(ZASwipeActionsOrientation)orientation animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    ZASwipeActionState *targetState = [ZASwipeActionState stateFromOrientation:orientation];
    
    if ([self.actionState isEqual:targetState] || ![self showActionsViewForOrientation:orientation]) {
        return;
    }
    
    [self.tableView hideSwipeCell];
    
    self.actionState = targetState;
    
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
    
    CGFloat newCenter =CGRectGetMidX(self.bounds) - (self.bounds.size.width + self.actionsView.minimumButtonWidth) * self.actionsView.orientation;
    
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGestureRecognizer) {
        if (UIAccessibilityIsVoiceOverRunning()) {
            [self.tableView hideSwipeCell];
        }
        
        NSArray<ZASwipeTableViewCell *> *cells = self.tableView.visibleCells;
        for (ZASwipeTableViewCell *cell in cells) {
            if ([cell.actionState isActive]) {
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


@end
