//
//  ZASwipeGestureHandler.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeCellHandler.h"
#import "ZASwipeCellContext.h"
#import "ZASwipeActionsView.h"
#import "ZASwipeExpansionStyle.h"
#import "ZASwipeCellOptions.h"
#import "ZASwipeAccessibilityCustomAction.h"
#import "UIPanGestureRecognizer+SwipeCellKit.h"
#import "UITableView+SwipeCellKit.h"

@interface ZASwipeCellHandler () <ZASwipeActionsViewDelegate>

@end

@implementation ZASwipeCellHandler

- (instancetype)initWithCell:(UIView<ZASwipeable> *)cell {
    if (self = [super init]) {
        _swipeCell = cell;
    }
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    [self hideSwipeWithAnimation:YES];
}

- (void)handleCellParentPanGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self hideSwipeWithAnimation:YES];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.view == nil) {
        return;
    }
    
    UIView<ZASwipeable> *target = (UIView<ZASwipeable> *)gesture.view;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            target.context.originalCenter = target.center.x;
            
            if (target.context.state == ZASwipeStateCenter || target.context.state == ZASwipeStateAnimatingToCenter) {
                CGPoint velocity = [gesture velocityInView:target];
                ZASwipeActionsOrientation orientation = velocity.x > 0 ? ZASwipeActionsOrientationLeft : ZASwipeActionsOrientationRight;
                [self showActionsViewForOrientation:orientation];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
            if (!target.context.actionsView) {
                return;
            }
            
            CGFloat translation = [gesture translationInView:target].x;
            target.context.scrollRatio = 1.0;
            
            // Check if dragging past the center of the oppsite direction of action view
            if ( (translation + target.context.originalCenter - CGRectGetMidX(target.bounds)) * target.context.actionsView.orientation > 0) {
                CGPoint center = target.center;
                center.x = [gesture elasticTranslationInView:target withLimit:CGSizeZero fromOriginalCenter:CGPointMake(target.context.originalCenter, 0)].x;
                target.center = center;
                
                target.context.scrollRatio = target.context.elasticScrollRatio;
                return;
            }
            
            if (target.context.actionsView.options.expansionStyle) {
                ZASwipeExpansionStyle *expansionStyle = target.context.actionsView.options.expansionStyle;
                BOOL expanded = [expansionStyle shouldExpandView:target ByGesture:gesture inSuperView:target.parentView];
                CGFloat targetOffset = [expansionStyle targetOffsetForView:target inSuperview:target.parentView];
                CGFloat currentOffset = fabs(translation + target.context.originalCenter - CGRectGetMidX(target.bounds));
                
                if (expanded && !target.context.actionsView.expanded && targetOffset > currentOffset) {
                    CGFloat centerForTranslationToEdge = CGRectGetMidX(target.bounds) - targetOffset * target.context.actionsView.orientation;
                    CGFloat delta = centerForTranslationToEdge - target.context.originalCenter;
                    
                    [self animateWithDuration:0.7 toOffset:centerForTranslationToEdge withInitialVelocity:0 completion:nil];
                    [gesture setTranslation:CGPointMake(delta, 0) inView:target.superview];
                }
                else {
                    CGPoint center = target.center;
                    center.x = [gesture elasticTranslationInView:target withLimit:CGSizeMake(targetOffset, 0) fromOriginalCenter:CGPointMake(target.context.originalCenter, 0)].x;
                    target.center = center;
                }
                
                target.context.actionsView.expanded = expanded;
            }
            else {
                CGPoint center = target.center;
                center.x = [gesture elasticTranslationInView:target
                                                   withLimit:CGSizeMake(target.context.actionsView.preferredWidth, 0)
                                          fromOriginalCenter:CGPointMake(target.context.originalCenter, 0)
                                               applyingRatio:target.context.elasticScrollRatio].x;
                target.center = center;
                if ((target.center.x - target.context.originalCenter) / translation != 1.0) {
                    target.context.scrollRatio = target.context.elasticScrollRatio;
                }
                
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (!target.context.actionsView) {
                return;
            }
            
            CGPoint velocity = [gesture velocityInView:target];
            target.context.state = [self targetStateForVelocity:velocity];
            
            if (target.context.actionsView.expanded == YES && target.context.actionsView.expandableAction) {
                [self performAction:target.context.actionsView.expandableAction];
            }
            else {
                CGFloat targetOffset = [self targetCenterActive:(target.context.state != ZASwipeStateCenter)];
                CGFloat distance = targetOffset - target.center.x;
                CGFloat normalizedVelocity = velocity.x * target.context.scrollRatio / distance;
                
                [self animateWithDuration:0.7 toOffset:targetOffset withInitialVelocity:normalizedVelocity completion:^{
                    if (target.context.state == ZASwipeStateCenter) {
                        [self reset];
                    }
                }];
                
                if (target.context.state == ZASwipeStateCenter) {
                    [self notifyEditingStateChangeIsActive:NO];
                }
            }
            break;
            
        default:
            break;
    }
}


#pragma mark - Private

- (BOOL)showActionsViewForOrientation:(ZASwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.swipeCell.parentView indexPathForCell:self.swipeCell];
    NSArray<ZASwipeAction *> *actions;
    
    if (!indexPath) {
        return NO;
    }
    actions = [self.swipeCell.delegate view:self.swipeCell.parentView editActionsForRowAtIndexPath:indexPath forOrientation:orientation];
    if (actions == nil || actions.count <= 0) {
        return NO;
    }
    
//TODO
    //swipeCell.originalLayoutMargins = super.layoutMargins;
    
    // Remove hightlight and deselect any selected cells
    //self.highlighted = NO;
    NSArray<NSIndexPath *> *selectedIndexPaths = [self.swipeCell.parentView indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [self.swipeCell.parentView deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    // Temporarily remove table gestures
    [self.swipeCell.parentView setGestureEnabled:NO];
    
    [self configureActionsViewWithActions:actions forOrientation:orientation];
    
    return YES;
}

- (void)configureActionsViewWithActions:(NSArray<ZASwipeAction *> *)actions forOrientation:(ZASwipeActionsOrientation)orientation {
    NSIndexPath *indexPath = [self.swipeCell.parentView indexPathForCell:self.swipeCell];
    if (!indexPath) {
        return;
    }
    
    ZASwipeCellOptions *options = [self.swipeCell.delegate view:self.swipeCell.parentView editActionsOptionsForRowAtIndexPath:indexPath forOrientation:orientation];
    if (!options) {
        options = [[ZASwipeCellOptions alloc] init];
    }
    
    [self.swipeCell.context.actionsView removeFromSuperview];
    self.swipeCell.context.actionsView = nil;
    
    ZASwipeActionsView *actionsView = [[ZASwipeActionsView alloc] initWithMaxSize:self.swipeCell.bounds.size option:options orientation:orientation actions:actions];
    actionsView.delegate = self;
    [self.swipeCell addSubview:actionsView];
    
    NSLayoutConstraint *height, *width, *top, *pinHorizontal;
    height = [actionsView.heightAnchor constraintEqualToAnchor:self.swipeCell.heightAnchor];
    width = [actionsView.widthAnchor constraintEqualToAnchor:self.swipeCell.widthAnchor multiplier:2.0];
    top = [actionsView.topAnchor constraintEqualToAnchor:self.swipeCell.topAnchor];
    
    if (orientation == ZASwipeActionsOrientationLeft) {
        pinHorizontal = [actionsView.rightAnchor constraintEqualToAnchor:self.swipeCell.leftAnchor];
    }
    else {
        pinHorizontal = [actionsView.leftAnchor constraintEqualToAnchor:self.swipeCell.rightAnchor];
    }
    [NSLayoutConstraint activateConstraints:@[height, width, top, pinHorizontal]];
    
    self.swipeCell.context.actionsView = actionsView;
    [self notifyEditingStateChangeIsActive:YES];
}

- (void)notifyEditingStateChangeIsActive:(BOOL)active {
    NSIndexPath *indexPath = [self.swipeCell.parentView indexPathForCell:self.swipeCell];
    if (indexPath && self.swipeCell.context.actionsView) {
        if (active) {
            [self.swipeCell.delegate view:self.swipeCell.parentView willBeginEdittingRowAtIndexPath:indexPath forOrientation:self.swipeCell.context.actionsView.orientation];
        }
        else {
            [self.swipeCell.delegate view:self.swipeCell.parentView didEndEdittingRowAtIndexPath:indexPath forOrientation:self.swipeCell.context.actionsView.orientation];
        }
    }
}

- (void)animateWithDuration:(double)duration toOffset:(CGFloat)offset withInitialVelocity:(CGFloat)velocity completion:(void (^)())completion {
    [self.swipeCell layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint newCenter = CGPointMake(offset, weakSelf.swipeCell.center.y);
        weakSelf.swipeCell.center = newCenter;
        [weakSelf.swipeCell layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)animateToOffset:(CGFloat)offset completion:(void (^)())completion {
    [self animateWithDuration:0.7 toOffset:offset withInitialVelocity:0 completion:completion];
}


#pragma mark - ZASwipeActionsViewDelegate

- (void)swipeActionView:(ZASwipeActionsView *)swipeActionsView didSelectAction:(ZASwipeAction *)action {
    [self performAction:action];
}

- (void)performAction:(ZASwipeAction *)action {
    if (!self.swipeCell.context.actionsView) {
        return;
    }
    
    if (action == self.swipeCell.context.actionsView.expandableAction && self.swipeCell.context.actionsView.options.expansionStyle) {
        // Trigger the expansion
        self.swipeCell.context.actionsView.expanded = YES;
        ZACompletionAnimation *completionAnimation = self.swipeCell.context.actionsView.options.expansionStyle.completionAnimation;
        
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
        [self performAction:action hide:self.swipeCell.context.actionsView.expandableAction.hideWhenSelected];
    }
}

- (void)performAction:(ZASwipeAction *)action hide:(BOOL)hide {
    NSIndexPath *indexPath = [self.swipeCell.parentView indexPathForCell:self.swipeCell];
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
    NSIndexPath *indexPath = [self.swipeCell.parentView indexPathForCell:self.swipeCell];
    if (!self.swipeCell.context.actionsView || !indexPath) {
        return;
    }
    
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(MIN(0, CGRectGetMinX(self.swipeCell.context.actionsView.frame)), 0, self.swipeCell.bounds.size.width + self.swipeCell.context.actionsView.bounds.size.width, self.swipeCell.bounds.size.height)];
    mask.backgroundColor = [UIColor whiteColor];
    self.swipeCell.maskView = mask;
    
    CGFloat newCenter = CGRectGetMidX(self.swipeCell.bounds) - (self.swipeCell.bounds.size.width + self.swipeCell.context.actionsView.minimumButtonWidth) * self.swipeCell.context.actionsView.orientation;
    
    __weak typeof(self) weakSelf = self;
    __weak ZASwipeAction *weakAction = action;
    action.completionHandler = ^void(ZAExpansionFulfillmentStyle style) {
        weakAction.completionHandler = nil;
        
        [weakSelf.swipeCell.delegate view:weakSelf.swipeCell.parentView didEndEdittingRowAtIndexPath:indexPath forOrientation:weakSelf.swipeCell.context.actionsView.orientation];
        
        switch (style) {
            case ZAExpansionFulfillmentStyleDelete: {
                
                [weakSelf.swipeCell.parentView deleteItemsAtIndexPaths:@[indexPath]];
                
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint center = weakSelf.swipeCell.center;
                    center.x = newCenter;
                    weakSelf.swipeCell.center = center;
                    
                    CGRect maskFrame = mask.frame;
                    maskFrame.size.height = 0;
                    mask.frame = maskFrame;
                    
                    if (fillOption.timming == ZAHandlerInvocationTimingAfter) {
                        weakSelf.swipeCell.context.actionsView.alpha = 0;
                    }
                } completion:^(BOOL finished) {
                    weakSelf.swipeCell.maskView = nil;
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
    
    [self animateWithDuration:0.3 toOffset:newCenter withInitialVelocity:0.0 completion:^{
        if (fillOption.timming == ZAHandlerInvocationTimingAfter) {
            invokeAction();
        }
    }];
    
    if (fillOption.timming == ZAHandlerInvocationTimingWith) {
        invokeAction();
    }
}

#pragma mark - Handle swipe state

- (ZASwipeState)targetStateForVelocity:(CGPoint)velocity {
    if (!self.swipeCell.context.actionsView) {
        return ZASwipeStateCenter;
    }
    
    switch (self.swipeCell.context.actionsView.orientation) {
        case ZASwipeActionsOrientationLeft:
            return (velocity.x < 0 && !self.swipeCell.context.actionsView.expanded) ? ZASwipeStateCenter : ZASwipeStateLeft;
            break;
        case ZASwipeActionsOrientationRight:
            return (velocity.x > 0 && !self.swipeCell.context.actionsView.expanded) ? ZASwipeStateCenter: ZASwipeStateRight;
            break;
        default:
            break;
    }
}

- (CGFloat)targetCenterActive:(BOOL)active {
    if (self.swipeCell.context.actionsView && active == true) {
        return CGRectGetMidX(self.swipeCell.bounds) - self.swipeCell.context.actionsView.preferredWidth * self.swipeCell.context.actionsView.orientation;
    }
    else {
        return CGRectGetMidX(self.swipeCell.bounds);
    }
}

- (void)reset {
    self.swipeCell.context.state = ZASwipeStateCenter;
    
    [self.swipeCell.parentView setGestureEnabled:YES];
    
    [self.swipeCell.context.actionsView removeFromSuperview];
    self.swipeCell.context.actionsView = nil;
}

- (void)hideSwipeWithAnimation:(BOOL)animated {
    if (self.swipeCell.context.state != ZASwipeStateLeft &&
        self.swipeCell.context.state != ZASwipeStateRight) {
        return;
    }
    
    self.swipeCell.context.state = ZASwipeStateAnimatingToCenter;
    
    //[self.swipeCell.parentView setGestureEnabled:YES];
    
    CGFloat targetCenter = [self targetCenterActive:NO];
    
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [self animateToOffset:targetCenter completion:^{
            [weakSelf reset];
        }];
    }
    else {
        self.swipeCell.center = CGPointMake(targetCenter, self.swipeCell.center.y);
        [self reset];
    }
    
    [self notifyEditingStateChangeIsActive:NO];
}

- (void)showSwipe:(ZASwipeActionsOrientation)orientation animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    ZASwipeState targetState = orientation == ZASwipeActionsOrientationLeft ? ZASwipeStateLeft : ZASwipeStateRight;
    
    if (self.swipeCell.context.state == targetState || ![self showActionsViewForOrientation:orientation]) {
        return;
    }
    
    [self.swipeCell.parentView hideSwipeCell];
    
    self.swipeCell.context.state = targetState;
    
    CGFloat targetCenter = [self targetCenterActive:YES];
    
    if (animated) {
        [self animateToOffset:targetCenter completion:^{
            completion(YES);
        }];
    }
    else {
        CGPoint center = self.swipeCell.center;
        center.x = targetCenter;
        self.swipeCell.center = center;
    }
}

@end
