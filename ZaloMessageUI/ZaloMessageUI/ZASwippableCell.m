//
//  ZASwippableCell.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/28/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZASwippableCell.h"
#import "System.h"

#define UTILITY_BUTTON_WIDTH 80.0

static CGFloat const kBounceValue = 30.0f;

@interface ZASwippableCell () <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, readwrite) NSLayoutConstraint *topContentViewTrailing;
@property (nonatomic, readwrite) NSLayoutConstraint *topContentViewLeading;

@property (nonatomic, assign) CGPoint panLastPoint;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingTrailingConstant;

@property (nonatomic, assign) ZASwippableCellState previousState;
@property (nonatomic, assign) ZASwippableCellState currentState;

@end

@implementation ZASwippableCell

- (instancetype)init {
    if (self = [super init]) {
        [self zasc_setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self zasc_setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self zasc_setUp];
    }
    return self;
}

#pragma mark - Settter
- (void)setCurrentState:(ZASwippableCellState)currentState {
}

- (void)setUtilityButtons:(NSArray<UIButton *> *)utilityButtons {
    // Remove old buttons
    for (UIButton *button in _utilityButtons) {
        [button removeFromSuperview];
    }
    
    _utilityButtons = utilityButtons;
    
    if(_utilityButtons.count > 0) {
        NSInteger buttonsCount = MIN(_utilityButtons.count, 3);
        for (NSInteger i = 0; i < buttonsCount; i++) {
            UIButton *button = utilityButtons[i];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button addTarget:self action:@selector(utilityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:button];
            
            NSLayoutConstraint *trailing, *width, *top, *bottom;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                NSLayoutAnchor *nextAnchor = i == 0 ? self.contentView.trailingAnchor : self.utilityButtons[i-1].leadingAnchor;
                
                trailing = [button.trailingAnchor constraintEqualToAnchor:nextAnchor];
                width = [button.widthAnchor constraintEqualToConstant:UTILITY_BUTTON_WIDTH];
                top = [button.topAnchor constraintEqualToAnchor:self.contentView.topAnchor];
                bottom = [button.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor];
            }
            
            [NSLayoutConstraint activateConstraints:@[trailing, width, top, bottom]];
        }
        
        [self.contentView bringSubviewToFront:_topContentView];
    }
}

- (void)utilityButtonTapped:(UIButton *)button {
    NSInteger index = [self.utilityButtons indexOfObject:button];
    if (index != NSNotFound) {
        [self.utilityButtonDelgate swippableCell:self didTriggerRightUtilityButtonsAtIndex:index];
    }
}

#pragma mark - Setup
- (void)zasc_setUp {
    _topContentView = [[UIView alloc] init];
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognize:)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.panRecognizer.delegate = self;
    self.currentState = ZASwippableCellStateOpen;
    
    [self.contentView addSubview:_topContentView];
    [self.topContentView addGestureRecognizer:self.panRecognizer];
    
    [self setUpTopContentView];
}

- (void)setUpTopContentView {
    self.topContentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topContentView.opaque = YES;
    self.topContentView.backgroundColor = self.contentView.backgroundColor;
    
    NSLayoutConstraint *leading, *trailing, *top, *bottom;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        leading = [self.topContentView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor];
        trailing = [self.topContentView.trailingAnchor constraintEqualToAnchor:self.topContentView.superview.trailingAnchor];
        top = [self.topContentView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor];
        bottom = [self.topContentView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor];
    }
    
    self.topContentViewLeading = leading;
    self.topContentViewTrailing = trailing;
    
    [NSLayoutConstraint activateConstraints:@[ self.topContentViewLeading,  self.topContentViewTrailing, top, bottom]];
}
#pragma mark - UI Event
- (void)panRecognize:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.topContentView];
            self.startingTrailingConstant = self.topContentViewTrailing.constant;
            self.panLastPoint = self.panStartPoint;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.topContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            CGFloat buttonsWidth = [self utilityButtonsWidth];
            
            CGFloat deltaYFromLastPoint = fabs(currentPoint.y - self.panStartPoint.y);
            if (deltaYFromLastPoint > 10) {
                return;
            }
            
            ZASwipeDirection direction = currentPoint.x < self.panStartPoint.x ? ZASwipeDirectionRightToLeft : ZASwipeDirectionLeftToRight;
            
            if (self.startingTrailingConstant == 0) {
                // the cell was closed
                switch (direction) {
                    case ZASwipeDirectionRightToLeft: {
                        CGFloat constant = MIN(-deltaX, buttonsWidth);
                        if (constant == buttonsWidth) {
                            //[self openUltilityButtons:YES notifyDelegateDidOpen:NO];
                        }
                        else {
                            self.topContentViewTrailing.constant = -constant;
                        }
                        break;
                    }
                        
                    case ZASwipeDirectionLeftToRight: {
                        CGFloat constant = MAX(-deltaX, 0);
                        if (constant == 0) {
                            //[self closeUltilityButtons:YES notifyDelegateDidClose:NO];
                        }
                        else {
                            self.topContentViewTrailing.constant = -constant;
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
            else {
                // the cell was partically open
                CGFloat adjustment = -self.startingTrailingConstant - deltaX;
                switch (direction) {
                    case ZASwipeDirectionRightToLeft: {
                        CGFloat constant = MIN(adjustment, buttonsWidth);
                        if (constant == buttonsWidth) {
                            //[self openUltilityButtons:YES notifyDelegateDidOpen:NO];
                        }
                        else {
                            self.topContentViewTrailing.constant = -constant;
                        }
                        break;
                    }
                        
                    case ZASwipeDirectionLeftToRight: {
                        CGFloat constant = MAX(adjustment, 0);
                        if (constant == 0) {
                            //[self closeUltilityButtons:YES notifyDelegateDidClose:NO];
                        }
                        else {
                            self.topContentViewTrailing.constant = -constant;
                        }
                    }
                    default:
                        break;
                }
            }
            
            self.topContentViewLeading.constant = self.topContentViewTrailing.constant;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint currentPoint = [recognizer translationInView:self.topContentView];
            CGFloat buttonsWidth = [self utilityButtonsWidth];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;

            ZASwipeDirection direction = deltaX < 0 ? ZASwipeDirectionRightToLeft : ZASwipeDirectionLeftToRight;
            
            switch (direction) {
                case ZASwipeDirectionRightToLeft:
                    if (fabs(deltaX) < buttonsWidth/3) {
                        // cell continue slide to open if pan over threshhold
                        [self closeUltilityButtons:YES notifyDelegateDidClose:NO];
                    }
                    else {
                        // cell auto close if pan not hitting threshold
                        [self openUltilityButtons:YES notifyDelegateDidOpen:YES];
                    }

                    break;
                case ZASwipeDirectionLeftToRight:
                    if (fabs(deltaX) < buttonsWidth/3) {
                        // cell continue slide to open if pan over threshhold
                        [self openUltilityButtons:YES notifyDelegateDidOpen:NO];
                    }
                    else {
                        // cell auto close if pan not hitting threshold
                        [self closeUltilityButtons:YES notifyDelegateDidClose:YES];
                    }
                    
                    break;
                default:
                    break;
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
            if (self.startingTrailingConstant == 0) {
                [self closeUltilityButtons:YES notifyDelegateDidClose:YES];
            } else {
                [self openUltilityButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
        default:
            break;
    }
}

- (void)prepareForReuse {
    [self hideSwipeButtonAnimated:NO];
}

- (void)showSwipeButtonAnimated:(BOOL)animated {
    [self openUltilityButtons:animated notifyDelegateDidOpen:NO];
}

- (void)hideSwipeButtonAnimated:(BOOL)animated {
    [self closeUltilityButtons:animated notifyDelegateDidClose:NO];
}
#pragma mark - UIGesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//    CGFloat yVelocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:gestureRecognizer.view].y;
//        // return NO nếu user scroll chiều vertical với velocity < 50 vì lúc đó user đang scroll để hiển ultility buttons
//        return fabs(yVelocity) >= 50;
//    }
    return YES;
}

#pragma mark - Private
- (CGFloat)utilityButtonsWidth{
    CGFloat width = 0;
    
    for (UIView *view in self.utilityButtons) {
        width += view.bounds.size.width;
    }
    
    return width;
}

- (void)closeUltilityButtons:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate {
    [self setUserInteractionEnabled:NO];
    
    if (notifyDelegate) {
        [self.utilityButtonDelgate swippableCell:self didScrollToState:ZASwippableCellStateClose];
    }

    if (self.startingTrailingConstant == 0 && self.topContentViewTrailing.constant == 0) {
        // Already closed, no bounce necessary
        return;
    }
    
    self.topContentViewTrailing.constant = kBounceValue;
    self.topContentViewLeading.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.topContentViewTrailing.constant = 0;
        self.topContentViewLeading.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingTrailingConstant = self.topContentViewTrailing.constant;
        }];
    }];
}

- (void)openUltilityButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    [self setUserInteractionEnabled:YES];
    
    if (notifyDelegate) {
        [self.utilityButtonDelgate swippableCell:self didScrollToState:ZASwippableCellStateOpen];
    }
    
    CGFloat buttonsWidth = [self utilityButtonsWidth];
    
    if (self.startingTrailingConstant == buttonsWidth &&
        self.topContentViewTrailing.constant == buttonsWidth) {
        // Already openning
        return;
    }
    
    self.topContentViewLeading.constant = -buttonsWidth - kBounceValue;
    self.topContentViewTrailing.constant = -buttonsWidth - kBounceValue;
    
    __weak typeof(self) weakSelf = self;
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        typeof(self) strongSelf = weakSelf;
        strongSelf.topContentViewLeading.constant = -buttonsWidth;
        strongSelf.topContentViewTrailing.constant = -buttonsWidth;
        
        [strongSelf updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            strongSelf.startingTrailingConstant = self.topContentViewTrailing.constant;
        }];
    }];

}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf layoutIfNeeded];
    } completion:completion];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
//    for (UIButton *view in self.utilityButtons) {
//        view.userInteractionEnabled = userInteractionEnabled;
//    }
}

@end
