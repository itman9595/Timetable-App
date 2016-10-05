//
//  Main_View_Controller.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/22/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "Main_View_Controller.h"
#import "Timetable_View_Controller.h"
#import "Teachers_Settings.h"
#import "Search_View_Controller.h"
#import "Settings.h"
#import "Reachability.h"

@implementation Main_View_Controller
@synthesize start_button, student_timetable_button, teachers_timetable_button, settings_button, search_button,
about_us_button;
@synthesize warningView;

-(void)performConstraintsPlacementForLandscape:(BOOL)turnedLandscape forPortrait:(BOOL)turnedPortrait forBackgroundImage:(BOOL)background {
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if ((newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight))
    {
        NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        if (([[ver objectAtIndex:0] intValue] <= 7&&UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)||
            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.device_Turned = turnedLandscape;
        }
    }
    else {
        self.device_Turned = turnedPortrait;
    }
    [self set_Scroll_View_Content_Size_According_To_Orientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self performConstraintsPlacementForLandscape:YES forPortrait:NO forBackgroundImage:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)didRotate:(NSNotification *)notification {
    warning_view_is_dismissed = YES;
    [warningView setFrame:CGRectMake(self.last_clicked_button.center.x-70, self.last_clicked_button.center.y-70, 140, 140)];
    [self performConstraintsPlacementForLandscape:YES forPortrait:NO forBackgroundImage:NO];
}

-(void)set_Scroll_View_Content_Size_According_To_Orientation {
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if ((newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight))
    {
        if (self.device_Turned) {
            self.device_Turned = NO;
            [self.view removeConstraints:self.arrayOfConstraintsOfPortraitMode];
            [self.view addConstraints:self.arrayOfConstraintsOfLandscapeMode];
        }
    }
    else if (newOrientation == UIInterfaceOrientationPortrait || newOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        if (!self.device_Turned) {
            self.device_Turned = YES;
            [self.view removeConstraints:self.arrayOfConstraintsOfLandscapeMode];
            [self.view addConstraints:self.arrayOfConstraintsOfPortraitMode];
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            if (screenSize.height == 480.0f) {
                //iPhone 4, 4s, iPod Touch 4-th
                self.base_top_space.constant = 61;
            }
            else  if (screenSize.height == 667.0f) {
                //iPhone 6
                self.base_top_space.constant = 121;
            }
            else  if (screenSize.height == 568.0f||screenSize.height == 736.0f) {
                //iPhone 6 Plus
                self.base_top_space.constant = 101;
            }
        }
    }
}

-(void)execute_Animation:(NSTimeInterval)duration object:(UIButton*)button{
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [button setAlpha:1];
                         }
                         completion:^(BOOL finished) {
                         }];
}



- (IBAction)go_To_Students_timetable:(id)sender {
    Timetable_View_Controller *timetable_View_Controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"Timetable_View_Controller"];
    [timetable_View_Controller setTheSuperview:@"Student"];
    [self.navigationController pushViewController:timetable_View_Controller animated:YES];
}

- (IBAction)go_to_Teachers_timetable:(id)sender {
    Timetable_View_Controller *timetable_View_Controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"Timetable_View_Controller"];
    [timetable_View_Controller setTheSuperview:@"Teacher"];
    [self.navigationController pushViewController:timetable_View_Controller animated:YES];
}

- (IBAction)go_To_Students_Settings:(id)sender {
    Settings *settings =
    [self.storyboard instantiateViewControllerWithIdentifier:
     @"Settings"];
    [self.navigationController pushViewController:
     settings animated:YES];
}

- (IBAction)go_To_Search:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self show_warning_view:sender];
    }
    else {
        Search_View_Controller *search_View_Controller =
        [self.storyboard instantiateViewControllerWithIdentifier:
         @"Search_View_Controller"];
        [self.navigationController pushViewController:
         search_View_Controller animated:YES];
    }
}

- (IBAction)go_to_Unity_Club:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self show_warning_view:sender];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://vk.com/unity_sdc"]];
    }
}

- (IBAction)show_menu_buttons:(id)sender {
    [self execute_Animation:0.5 object:student_timetable_button];
    [self execute_Animation:0.8 object:teachers_timetable_button];
    [self execute_Animation:1.1 object:settings_button];
    [self execute_Animation:1.4 object:search_button];
    [self execute_Animation:1.7 object:about_us_button];
}

-(void)viewDidLayoutSubviews {
    [self performConstraintsPlacementForLandscape:NO forPortrait:YES forBackgroundImage:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [student_timetable_button setAlpha:0];
    [teachers_timetable_button setAlpha:0];
    [settings_button setAlpha:0];
    [search_button setAlpha:0];
    [about_us_button setAlpha:0];
    
    warning_view_is_dismissed = YES;
    
    CGFloat distanceOfStartButton=100, horizontal_distance = 20, vertical_distance = 40, unity_Club_Button_bottom_space = 20;
    CGFloat settings_button_Vertical_Distance = horizontal_distance;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height == 480.0f) {
            //iPhone 4, 4s, iPod Touch 4-th
            self.base_top_space.constant = 61;
        }
        else if (screenSize.height == 568.0f) {
            //iPhone 5, 5c, 5s, iPod Touch 5-th
            self.base_top_space.constant = 101;
        }
        else  if (screenSize.height == 667.0f) {
            //iPhone 6
            self.base_top_space.constant = 121;
            NSLayoutConstraint *changing_constraint = [start_button.constraints objectAtIndex:0];
            changing_constraint.constant = 200;
            changing_constraint = [start_button.constraints objectAtIndex:1];
            changing_constraint.constant = 200;
            changing_constraint = [student_timetable_button.constraints objectAtIndex:0];
            changing_constraint.constant = 60;
            changing_constraint = [student_timetable_button.constraints objectAtIndex:1];
            changing_constraint.constant = 60;
            changing_constraint = [self.unity_Club_Button.constraints objectAtIndex:0];
            changing_constraint.constant = 25;
            self.teachers_timetable_button_trailing_space.constant = 55;
            self.teachers_timetable_button_bottom_space.constant = 50;
            [self.unity_Club_Button.titleLabel setFont:[UIFont fontWithName:@"Hoefler Text" size:20]];
            vertical_distance = 45;
            horizontal_distance = 20;
            distanceOfStartButton=100;
        }
        else  if (screenSize.height == 736.0f) {
            //iPhone 6 Plus
            self.base_top_space.constant = 101;
            NSLayoutConstraint *changing_constraint = [start_button.constraints objectAtIndex:0];
            changing_constraint.constant = 250;
            changing_constraint = [start_button.constraints objectAtIndex:1];
            changing_constraint.constant = 250;
            changing_constraint = [student_timetable_button.constraints objectAtIndex:0];
            changing_constraint.constant = 70;
            changing_constraint = [student_timetable_button.constraints objectAtIndex:1];
            changing_constraint.constant = 70;
            changing_constraint = [self.unity_Club_Button.constraints objectAtIndex:0];
            changing_constraint.constant = 31;
            changing_constraint = [self.unity_Club_Button.constraints objectAtIndex:1];
            changing_constraint.constant = 120;
            self.teachers_timetable_button_trailing_space.constant = 65;
            self.search_button_top_space.constant = -30;
            self.teachers_timetable_button_bottom_space.constant = 60;
            [self.unity_Club_Button.titleLabel setFont:[UIFont fontWithName:@"Hoefler Text" size:25]];
            vertical_distance = 45;
            horizontal_distance = 30;
            distanceOfStartButton=100;
        }
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        NSLayoutConstraint *changing_constraint = [start_button.constraints objectAtIndex:0];
        changing_constraint.constant = 300;
        changing_constraint = [start_button.constraints objectAtIndex:1];
        changing_constraint.constant = 300;
        changing_constraint = [student_timetable_button.constraints objectAtIndex:0];
        changing_constraint.constant = 100;
        changing_constraint = [student_timetable_button.constraints objectAtIndex:1];
        changing_constraint.constant = 100;
        changing_constraint = [self.unity_Club_Button.constraints objectAtIndex:0];
        changing_constraint.constant = 42;
        changing_constraint = [self.unity_Club_Button.constraints objectAtIndex:1];
        changing_constraint.constant = 200;
        self.teachers_timetable_button_trailing_space.constant = 65;
        self.teachers_timetable_button_bottom_space.constant = 60;
        self.search_button_top_space.constant = -30;
        [self.unity_Club_Button.titleLabel setFont:[UIFont fontWithName:@"Hoefler Text" size:35]];
        self.centerX.constant = -150;
        vertical_distance = 65;
        horizontal_distance = 40;
        settings_button_Vertical_Distance = horizontal_distance;
        distanceOfStartButton=250;
        unity_Club_Button_bottom_space = 100;
    }
    
    self.arrayOfConstraintsOfPortraitMode = [[NSMutableArray alloc]init];
    for (NSLayoutConstraint *constraint in [[self view]constraints]) {
        if (constraint!=[[self.unity_Club_Button constraints]objectAtIndex:0]&&constraint!=[[self.unity_Club_Button constraints]objectAtIndex:1]&&constraint!=[[self.start_button constraints]objectAtIndex:0]&&constraint!=[[self.start_button constraints]objectAtIndex:1]&&constraint!=[[self.student_timetable_button constraints]objectAtIndex:0]&&constraint!=[[self.student_timetable_button constraints]objectAtIndex:1]&&constraint!=self.teachers_Timetable_Button_Width&&constraint!=self.teachers_Timetable_Button_Height&&constraint!=self.settings_Button_Width&&constraint!=self.settings_Button_Height&&constraint!=self.search_Button_Width&&constraint!=self.search_Button_Height&&constraint!=self.about_Us_Button_Width&&constraint!=self.about_Us_Button_Height) {
            [self.arrayOfConstraintsOfPortraitMode addObject:constraint];
        }
    }
    
    self.arrayOfConstraintsOfLandscapeMode = [NSMutableArray arrayWithObjects:
    //start_button
    [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.start_button attribute:NSLayoutAttributeTop multiplier:1 constant:-distanceOfStartButton],[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.start_button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                              
    //student_timetable_button
    [NSLayoutConstraint constraintWithItem:self.start_button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.student_timetable_button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:self.start_button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.student_timetable_button attribute:NSLayoutAttributeTrailing multiplier:1 constant:horizontal_distance],
                                              
    //teachers_timetable_button
    [NSLayoutConstraint constraintWithItem:self.student_timetable_button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.teachers_timetable_button attribute:NSLayoutAttributeBottom multiplier:1 constant:vertical_distance],[NSLayoutConstraint constraintWithItem:self.student_timetable_button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.teachers_timetable_button attribute:NSLayoutAttributeLeading multiplier:1 constant:horizontal_distance],
                                              
    //settings_button
    [NSLayoutConstraint constraintWithItem:self.start_button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.settings_button attribute:NSLayoutAttributeBottom multiplier:1 constant:settings_button_Vertical_Distance],[NSLayoutConstraint constraintWithItem:self.start_button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.settings_button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                              
    //about_us_button
    [NSLayoutConstraint constraintWithItem:self.start_button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.about_us_button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:self.start_button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.about_us_button attribute:NSLayoutAttributeLeading multiplier:1 constant:-horizontal_distance],
                                              
    //search_button
    [NSLayoutConstraint constraintWithItem:self.about_us_button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.search_button attribute:NSLayoutAttributeBottom multiplier:1 constant:vertical_distance],[NSLayoutConstraint constraintWithItem:self.about_us_button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.search_button attribute:NSLayoutAttributeTrailing multiplier:1 constant:-horizontal_distance],
                                              
    //unity_Club_Button
    [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:
    NSLayoutRelationEqual toItem:self.unity_Club_Button attribute:NSLayoutAttributeBottom multiplier:1 constant:unity_Club_Button_bottom_space],[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.unity_Club_Button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],nil];
}

-(void)show_warning_view:(id)sender{
    
    if (warning_view_is_dismissed) {
    self.last_clicked_button = sender;
        UILabel *no_Internet_Connection_Label;
        CGFloat changingSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            changingSize = 140;
            warningView = [[UIView alloc] initWithFrame:CGRectMake(self.last_clicked_button.center.x-changingSize/2, self.last_clicked_button.center.y-changingSize/2, changingSize, changingSize)];
            no_Internet_Connection_Label = [[UILabel alloc]initWithFrame:
                                                     CGRectMake(0, 0, changingSize, changingSize)];
            [no_Internet_Connection_Label setFont:[UIFont systemFontOfSize:18]];
        }
        else {
            changingSize = 250;
            warningView = [[UIView alloc] initWithFrame:CGRectMake(self.last_clicked_button.center.x-changingSize/2, self.last_clicked_button.center.y-changingSize/2, changingSize, changingSize)];
            no_Internet_Connection_Label = [[UILabel alloc]initWithFrame:
                                            CGRectMake(0, 0, changingSize, changingSize)];
            [no_Internet_Connection_Label setFont:[UIFont systemFontOfSize:38]];
        }
    
    [no_Internet_Connection_Label setText:@"No Internet Connection"];
    [no_Internet_Connection_Label setNumberOfLines:0];
    [no_Internet_Connection_Label setTextAlignment:NSTextAlignmentCenter];
    
    [no_Internet_Connection_Label setTextColor:[UIColor blackColor]];
    [warningView addSubview:no_Internet_Connection_Label];
    
    [warningView setBackgroundColor:[UIColor whiteColor]];
    warningView.layer.cornerRadius = 5;
    warningView.layer.borderWidth = 3.f;
    warningView.layer.masksToBounds = YES;
    [warningView setAlpha:0];
    [self.view addSubview:warningView];
    
    [UIView animateWithDuration:0.4 animations:^{
        [warningView setAlpha:1.0];
    } completion:^(BOOL finished) {

            [UIView animateWithDuration:0.4 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [warningView setAlpha:0];
            } completion:^(BOOL finished) {
                [warningView removeFromSuperview];
                warning_view_is_dismissed = YES;
            }];

    }];
        warning_view_is_dismissed = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
