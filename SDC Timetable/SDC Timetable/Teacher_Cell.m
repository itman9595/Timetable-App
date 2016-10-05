//
//  Teacher_Cell.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/6/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "Teacher_Cell.h"
static CGFloat const kBounceValue = 20.0f;
@implementation Teacher_Cell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    if([MFMessageComposeViewController canSendText]) {
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
        [self.panRecognizer setDelegate:self];
        [self.myContentView addGestureRecognizer:self.panRecognizer];
    }
    else {
        [self.message_button removeFromSuperview];
        [self.swipeSign removeFromSuperview];
        [self.myContentView removeConstraint:self.myTextLabelCenterX];
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.myTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.myTextLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.myTextLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8]];
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.myTextLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) {
                //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }
            else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }
            
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant;
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was opening
                CGFloat halfOfButtons;
                
                halfOfButtons = CGRectGetWidth(self.message_button.frame) / 2;
                
                
                if (self.contentViewRightConstraint.constant >= halfOfButtons) {
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                //Cell was closing
                CGFloat buttonOnePlusHalfOfButton2;
                
                buttonOnePlusHalfOfButton2 = CGRectGetWidth(self.message_button.frame) / 2;
                
                if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) {
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //Cell was open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
        default:
            break;
    }
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    //TODO: Notify delegate.
    
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {

        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            [self.swipeSign setImage:[UIImage imageNamed:@"SwipeRight.png"]];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            
            id view = [self superview];
            
            while (view && [view isKindOfClass:[UITableView class]] == NO) {
                view = [view superview];
            }
            
            UITableView *tableView = (UITableView *)view;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSNumber numberWithInteger:self.swipedCellIndex]forKey:@"swipedCellIndex"];
            NSArray *visibleCellsIndexPaths = [tableView indexPathsForVisibleRows];
            for (int i=0;i<[visibleCellsIndexPaths count];i++) {
                if (self.swipedCellIndex != [[visibleCellsIndexPaths objectAtIndex:i]row]) {
                    [[[tableView visibleCells]objectAtIndex:i] resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
        }];
    }];
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate {
    //TODO: Notify delegate.
    
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            [self.swipeSign setImage:[UIImage imageNamed:@"SwipeLeft.png"]];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

-(CGFloat)buttonTotalWidth {
    return CGRectGetWidth(self.myContentView.frame) - CGRectGetMinX(self.message_button.frame);
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

- (IBAction)buttonClicked:(id)sender {
    if (sender == self.message_button) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",self.email]]];//Mail Of Teacher
    }
}

@end
