//
//  ZASwipeActionView.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 4/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwipeActionsView.h"
#import "ZASwipeAction.h"
#import "ZASwipeActionButtonWrapperView.h"
#import "ZASwipeActionButton.h"
#import "ZASwipeCellOptions.h"
#import "ZABorderTranstionLayout.h"
#import "ZARevealTransitionLayout.h"
#import "ZADragTransitionLayout.h"
#import "ZASwipeActionTransitioningContext.h"
#import "ZAActionsViewLayoutContext.h"
#import "ZAScaleAndAlphaExpansion.h"
#import "ZASwipeExpansionStyle.h"
#import "ZASwipeExpansionAnimationTimingParameters.h"

@implementation ZASwipeActionsView

- (id<ZASwipeExpanding>)expansionDelegate {
    if (self.options.expansionDelegate) {
        return self.options.expansionDelegate;
    }
    else {
        return self.expandableAction.hasBackgroundColor == false ? [ZAScaleAndAlphaExpansion expansion] : nil;
    }
}

- (CGFloat)maximumImageHeight {
    CGFloat maximum = 0;
    for (ZASwipeAction *action in self.actions) {
        maximum = MAX(maximum, action.image ? action.image.size.height : 0);
    }
    return maximum;
}

- (CGFloat)preferredWidth {
    return self.minimumButtonWidth * (CGFloat)_actions.count;
}

- (CGSize)contentSize {
    if (self.options.expansionStyle.elasticOverscroll != true || self.visibleWidth < self.preferredWidth) {
        return CGSizeMake(self.visibleWidth, self.bounds.size.height);
    }
    else {
        CGFloat scrollRatio = MAX(0, self.visibleWidth - self.preferredWidth);
        return CGSizeMake(self.preferredWidth + (scrollRatio * 0.25), self.bounds.size.height);
    }
}

- (ZASwipeAction *)expandableAction {
    return self.options.expansionStyle != nil ? self.actions.lastObject : nil;
}

- (void)setVisibleWidth:(CGFloat)visibleWidth {
    _visibleWidth = visibleWidth;
    
    NSArray<NSNumber *> *preLayoutVisibleWidths = [_transitionLayout visibleWidthsForViewsWithContext:_layoutContext];
    
    _layoutContext = [ZAActionsViewLayoutContext contextForActionsView:self];
    
    [_transitionLayout containerView:self didChangeVisibleWidthWithContext:_layoutContext];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self notifyVisibleWidthChangedFromOldWidths:preLayoutVisibleWidths to:[_transitionLayout visibleWidthsForViewsWithContext:_layoutContext]];
}

- (void)setExpanded:(BOOL)expanded {
    if (_expanded != expanded) {
        _expanded = expanded;
        
        ZASwipeExpansionAnimationTimingParameters *timingParameters = [self.expansionDelegate animationTimingParametersForButtons:[[self.buttons reverseObjectEnumerator] allObjects] expanding:_expanded];
        
        double duration = timingParameters.duration > 0 ? timingParameters.duration : 0.6;
        double delay = timingParameters.delay > 0 ? timingParameters.delay : 0;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:1.0 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [weakSelf setNeedsLayout];
            [weakSelf layoutIfNeeded];
        } completion:nil];
        
        [self notifyExpandsionChanged:expanded];
    }
}

- (instancetype)initWithMaxSize:(CGSize)maxSize option:(ZASwipeCellOptions *)options orientation:(ZASwipeActionsOrientation)orientation actions:(NSArray<ZASwipeAction *> *)actions {
    if (self = [super initWithFrame:CGRectZero]) {
        _options = options;
        _orientation = orientation;
        _actions = [[actions reverseObjectEnumerator] allObjects];
        
        _minimumButtonWidth = 0;
        _visibleWidth = 0;
        _expanded = NO;
        
        switch (options.transitionStyle) {
            case ZASwipeTransitionStyleBorder:
                _transitionLayout = [[ZABorderTranstionLayout alloc] init];
                break;
            case ZASwipeTransitionStyleReveal:
                _transitionLayout = [[ZARevealTransitionLayout alloc] init];
                break;
            default:
                _transitionLayout = [[ZADragTransitionLayout alloc] init];
                break;
        }
        
        _layoutContext = [[ZAActionsViewLayoutContext alloc] initWithNumberOfActions:actions.count orientation:orientation];
        
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = options.backgroundColor ? options.backgroundColor : [UIColor lightGrayColor];
        
        _buttons = [self addButtonsForActions:self.actions withMaximumSize:maxSize];
    }
    return self;
}

- (NSArray<ZASwipeActionButton *> *)addButtonsForActions:(NSArray<ZASwipeAction *> *)actions withMaximumSize:(CGSize)size {
    NSMutableArray<ZASwipeActionButton *> *buttons = [NSMutableArray array];
    for (ZASwipeAction *action in actions) {
        ZASwipeActionButton *actionButton = [[ZASwipeActionButton alloc] initWithSwipeAction:action];
        [actionButton addTarget:self action:@selector(actionTapped:) forControlEvents:UIControlEventTouchUpInside];
        actionButton.spacing = self.options.buttonSpacing;
        actionButton.contentEdgeInsets = [self buttonEdgeInsetsFromOptions:self.options];
        
        [buttons addObject:actionButton];
    }
    
    CGFloat maximum = self.options.maximumButtonWidth != 0 ? self.options.maximumButtonWidth : (size.width - 30) / (CGFloat)actions.count;
    CGFloat minimum = self.options.minimumButtonWidth != 0 ? self.options.minimumButtonWidth : 74;
    for (ZASwipeActionButton *button in buttons) {
        minimum = MAX(minimum, [button preferredWidthWithMaxinum:maximum]);
    }
    self.minimumButtonWidth = minimum;
    
    [buttons enumerateObjectsUsingBlock:^(ZASwipeActionButton * _Nonnull button, NSUInteger index, BOOL * _Nonnull stop) {
        ZASwipeAction *action = self.actions[index];
        CGRect frame = CGRectMake(0, 0, size.width * 2, size.height);
        ZASwipeActionButtonWrapperView *wrapperView = [[ZASwipeActionButtonWrapperView alloc] initWithFrame:frame action:action orientation:self.orientation contentWidth:self.minimumButtonWidth];
        [wrapperView addSubview:button];
        
        if (action.backgroundEffect) {
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:action.backgroundEffect];
            effectView.frame = wrapperView.frame;
            [effectView.contentView addSubview:wrapperView];
            [self addSubview:effectView];
        }
        else {
            [self addSubview:wrapperView];
        }
        
        button.frame = wrapperView.contentRect;
        button.maximumImageHeight = self.maximumImageHeight;
        button.verticalAlignment = self.options.buttonVerticalAligment;
        button.shouldHightLight = action.hasBackgroundColor;
    }];
    
    return [buttons copy];
}

- (void)actionTapped:(ZASwipeActionButton *)button {
    NSInteger index = [self.buttons indexOfObject:button];
    if (index == NSNotFound) {
        return;
    }
    
    [self.delegate swipeActionView:self didSelectAction:self.actions[index]];
}

- (UIEdgeInsets)buttonEdgeInsetsFromOptions:(ZASwipeCellOptions *)options {
    CGFloat padding = self.options.buttonPadding != 8 ? self.options.buttonPadding : 8.0;
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

- (void)notifyVisibleWidthChangedFromOldWidths:(NSArray<NSNumber *> *)oldWidths to:(NSArray<NSNumber *> *)newWidths {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        typeof(self) strongSelf = weakSelf;
        [oldWidths enumerateObjectsUsingBlock:^(NSNumber * _Nonnull oldWidth, NSUInteger index, BOOL * _Nonnull stop) {
            NSNumber *newWidth = newWidths[index];
            
            if ([oldWidth doubleValue] != [newWidth doubleValue]) {
                ZASwipeActionTransitioningContext *context = [[ZASwipeActionTransitioningContext alloc] initWithActionIdentifier:strongSelf.actions[index].identifier
                                                                                                                          button:strongSelf.buttons[index]
                                                                                                               newPercentVisible:[newWidth doubleValue] / strongSelf.minimumButtonWidth
                                                                                                               oldPercentVisible:[oldWidth doubleValue] / strongSelf.minimumButtonWidth
                                                                                                                     wrapperView:strongSelf.subviews[index]];
                
                [self.actions[index].transitionDelgate didTransitionWithContext:context];
            }
        }];
    });
}

- (void)notifyExpandsionChanged:(BOOL)expanded {
    ZASwipeActionButton *expandedButton = self.buttons.lastObject;
    if (expandedButton) {
        NSMutableArray *otherButtons = [NSMutableArray arrayWithArray:self.buttons];
        [otherButtons removeLastObject];
        [self.expansionDelegate actionButton:expandedButton didChange:expanded otherActionButtons:[[otherButtons reverseObjectEnumerator] allObjects]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger index, BOOL * _Nonnull stop) {
        [weakSelf.transitionLayout layoutView:subview atIndex:index withContext:weakSelf.layoutContext];
    }];
    
    if (self.expanded) {
        if (self.subviews.lastObject) {
            CGRect rect = self.subviews.lastObject.frame;
            rect.origin.x = 0 + self.bounds.origin.x;
            self.subviews.lastObject.frame = rect;
        }
    }
}
@end
