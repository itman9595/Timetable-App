//
//  EditorModeLogin.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/23/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "EditorModeLogin.h"

@implementation EditorModeLogin
@synthesize passwordField;
@synthesize dimmed_View, activityIndicatorView;
@synthesize custom_Navigation_Bar;

-(void)viewWillDisappear:(BOOL)animated {
    [self.query cancel];
    [self remove_Download_Signs];
}

-(void)viewDidAppear:(BOOL)animated {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self goToMenu:self.Back];
    }
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults setObject:nil forKey:@"UpdateType"];
    [self.defaults setObject:nil forKey:@"FullTargetName"];
    [self.defaults setObject:nil forKey:@"indexForParentObject"];
    [self.defaults setObject:nil forKey:@"FullLesson"];
    [self.defaults setObject:nil forKey:@"TargetName"];
    [self.defaults setObject:nil forKey:@"objectId"];
    [self.defaults setObject:nil forKey:@"day"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *secretPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showLogin)];
    secretPress.minimumPressDuration = 5.0;
    [self.secretButton addGestureRecognizer:secretPress];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)]];
    [passwordField setDelegate:self];
    [passwordField setHidden:YES];
    [self.Done setHidden:YES];
}

-(void)dismissKeyboard {
    [passwordField resignFirstResponder];
}

-(void)showLogin {
    [passwordField setHidden:NO];
    [passwordField setText:@""];
    [passwordField setBackgroundColor:[UIColor clearColor]];
    [self.Done setHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self checkPassword:textField];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@""]) {
        if ([[NSCharacterSet whitespaceAndNewlineCharacterSet]characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
    }
    return YES;
}

-(void)create_Download_Signs {
    [self.Done setUserInteractionEnabled:NO];
    [self.secretButton setUserInteractionEnabled:NO];
    dimmed_View = [[UIView alloc]init];
    [dimmed_View setBackgroundColor:[UIColor blackColor]];
    [dimmed_View setAlpha:0.5];
    [dimmed_View.layer setMasksToBounds:YES];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] <= 7) {
        dimmed_View = [[UIView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20))];
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            dimmed_View = [[UIView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)];
        }
        else {
            dimmed_View = [[UIView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))];
        }
    }
    activityIndicatorView.center = CGPointMake(dimmed_View.frame.size.width / 2, (dimmed_View.frame.size.height / 2)+activityIndicatorView.frame.size.height);
    [self.view addSubview:dimmed_View];
    [self.view addSubview:activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

-(void)remove_Download_Signs {
    [self.Done setUserInteractionEnabled:YES];
    [self.secretButton setUserInteractionEnabled:YES];
    [activityIndicatorView removeFromSuperview];
    [dimmed_View removeFromSuperview];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController&&passwordField) {
        NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        if ([[ver objectAtIndex:0] intValue] >= 7) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
            }];
        }
        else {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
    }
    return NO;
}

- (IBAction)checkPassword:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self showAlert];
        [passwordField setBackgroundColor:[UIColor clearColor]];
    }
    else {
        NSString *realText = [passwordField text];
        if ([realText length]<10) {
            [passwordField setText:realText];
            [passwordField setBackgroundColor:[UIColor redColor]];
            [self wrongInput:@"Password has less characters than 10"];
        }
        else {
            [self create_Download_Signs];
            self.query = [PFQuery queryWithClassName:@"VeryImportant"];
            [self.query orderByAscending:@"SubjectNumber"];
            [self.query findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
                if (!error) {
                    if ([list count]==1) {
                        NSString *password = [[list objectAtIndex:0]objectForKey:@"Password"];
                        password = [[password componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]componentsJoinedByString:@""];
                        if (!password) {
                            password = @"";
                        }
                        if ([password length]>=10) {
                            if (![realText isEqualToString:password]) {
                                [self wrongInput:@"Invalid Password"];
                                [passwordField setBackgroundColor:[UIColor redColor]];
                            }
                            else {
                                EditorModeViewController *editor = [self.storyboard instantiateViewControllerWithIdentifier:@"EditorModeViewController"];
                                [self presentViewController:editor animated:YES completion:nil];
                            }
                            [self remove_Download_Signs];
                        }
                        else if ([password length]<10) {
                            [self wrongInput:@"Column \"Password\" doesn't contain characters more than or equal to 10, please go to the server and fill in valid password, note that password mustn't contain SPACE or NEW LINE!"];
                            [self goToMenu:self.Back];
                        }
                    }
                    else {
                        [self wrongInput:@"Check server, smth wrong occured with \"VeryImportant\" class, perhaps it doesn't have column: \"Password\", it must have only 1 row on it"];
                        [self goToMenu:self.Back];
                    }
                }
                else {
                    [self wrongInput:@"Check server perhaps \"VeryImportant\" class doesn't exist or there is no the Internet Connection"];
                    [self goToMenu:self.Back];
                }
            }];
        }
    }
}

-(void)wrongInput:(NSString*)message {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

- (IBAction)goToMenu:(id)sender {
    UIViewController *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"main_Navigation_Controller"];
    [self presentViewController:menu animated:YES completion:nil];
}

-(void)showAlert {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"NO INTERNET CONNECTION" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
