//
//  EditorModeLogin.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/23/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <Parse/Parse.h>
#import "EditorModeViewController.h"
@interface EditorModeLogin : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) PFQuery *query;
@property (weak, nonatomic) IBOutlet UINavigationBar *custom_Navigation_Bar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Back;
@property (weak, nonatomic) IBOutlet UIButton *secretButton;
@property (strong, nonatomic) IBOutlet UIButton *Done;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) UIView *dimmed_View;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSUserDefaults *defaults;
- (IBAction)checkPassword:(id)sender;
- (IBAction)goToMenu:(id)sender;
@end
