//
//  Teacher_Cell.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/6/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface Teacher_Cell : UITableViewCell <UIGestureRecognizerDelegate>
@property NSInteger swipedCellIndex;
@property (nonatomic, weak) IBOutlet UIButton *message_button;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (nonatomic, weak) IBOutlet UILabel *myTextLabel;
@property (nonatomic, strong) NSString *email;
@property (weak, nonatomic) IBOutlet UIImageView *swipeSign;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTextLabelCenterX;
- (IBAction)buttonClicked:(id)sender;
- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate;
- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate;
@end
