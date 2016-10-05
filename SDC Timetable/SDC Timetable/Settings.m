//
//  Settings.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/14/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "Settings.h"

@implementation Settings
@synthesize year_Label, speciality_Label, course_language_Label;
@synthesize settings_Scroll_View, year_Picker, speciality_Picker, course_language_Picker;
@synthesize year_Text_Field, speciality_Text_Field, course_language_Text_Field, active_Field;
@synthesize years, specialities, course_languages, years_set, specialities_set, course_languages_set;
@synthesize next_text_field, done;
@synthesize dimmed_View, activityIndicatorView;
@synthesize updateIt;
@synthesize app_Delegate;
@synthesize timetable, databasePath;

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:done];  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    if ([[app_Delegate.defaults objectForKey:@"NotificationForLesson"]isEqualToString:@"On"]) {
        [app_Delegate.defaults setObject:@"On" forKey:@"NotificationForLesson"];
        [self.notifications_Controller setOn:YES];
        [self.notification_Label setText:@"If you turn it off, you won't be notified about any events any more"];
    }
    else {
        [app_Delegate.defaults setObject:@"Off" forKey:@"NotificationForLesson"];
        [self.notification_Label setText:@"If you turn it on, you will be notified every time your lesson is about to begin and when it is over "];
        
    }
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    if ([self.navigationController respondsToSelector:
         @selector(interactivePopGestureRecognizer)]) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDatabase" object:nil];
    [updateIt.query cancel];
}

-(void)didRotate:(NSNotification *)notification
{
    [self set_Scroll_View_Content_Size_According_To_Orientation];
}

- (void)viewDidLayoutSubviews {
    [self set_Scroll_View_Content_Size_According_To_Orientation];
}

-(void)set_Scroll_View_Content_Size_According_To_Orientation {
    [dimmed_View setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    activityIndicatorView.center = CGPointMake(dimmed_View.frame.size.width / 2, dimmed_View.frame.size.height / 2);
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if ((newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight))
    {
        [settings_Scroll_View setContentSize:CGSizeMake(self.view.frame.size.height,
                                                        self.view.frame.size.width)];
    }
    else if (newOrientation == UIInterfaceOrientationPortrait || newOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [settings_Scroll_View setContentSize:CGSizeMake(self.view.frame.size.width,
                                                        self.view.frame.size.height)];
    }
}

-(void)create_Download_Signs {
    dimmed_View = [[UIView alloc]init];
    [dimmed_View setBackgroundColor:[UIColor blackColor]];
    [dimmed_View setAlpha:0.5];
    [dimmed_View.layer setMasksToBounds:YES];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self set_Scroll_View_Content_Size_According_To_Orientation];
    [self.view addSubview:dimmed_View];
    [self.view addSubview:activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remove_Download_Signs) name:@"updateDatabase" object:nil];
}

-(void)remove_Download_Signs {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDatabase" object:nil];
    [activityIndicatorView removeFromSuperview];
    [dimmed_View removeFromSuperview];
    [self.navigationController.navigationBar.topItem.rightBarButtonItem setEnabled:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:
         @selector(interactivePopGestureRecognizer)]) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    }
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"timetable.db"]];
    
    app_Delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    updateIt = [[updateDatabase alloc]init];
    [updateIt initializeElementsForUpdate];
    
    years = [[NSArray alloc]initWithObjects:@"1", @"2", @"3", @"4", nil];
    years_set = [[NSSet alloc]initWithArray:years];
    specialities = [[NSArray alloc]initWithObjects:@"Translation Studies",@"Accounting",@"Economics", @"Finance", @"Marketing", @"Management", @"IT", nil];
    specialities_set = [[NSSet alloc]initWithArray:specialities];
    course_languages = [[NSArray alloc]initWithObjects:@"KZ", @"RU", nil];
    course_languages_set = [[NSSet alloc]initWithArray:course_languages];
    
    [year_Text_Field setDelegate:self];
    year_Picker = [[UIPickerView alloc]init];
    [year_Picker setBackgroundColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
    [year_Picker setDataSource:self];
    [year_Picker setDelegate:self];
    [year_Picker showsSelectionIndicator];
    [year_Text_Field setInputView:year_Picker];

    [speciality_Text_Field setDelegate:self];
    speciality_Picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 100, settings_Scroll_View.frame.size.width, 161)];
    [speciality_Picker setBackgroundColor:[year_Picker backgroundColor]];
    [speciality_Picker setDataSource:self];
    [speciality_Picker setDelegate:self];
    [speciality_Picker showsSelectionIndicator];
    [speciality_Text_Field setInputView:speciality_Picker];
    
    [course_language_Text_Field setDelegate:self];
    course_language_Picker = [[UIPickerView alloc]init];
    [course_language_Picker setBackgroundColor:[year_Picker backgroundColor]];
    [course_language_Picker setDataSource:self];
    [course_language_Picker setDelegate:self];
    [course_language_Picker showsSelectionIndicator];
    [course_language_Text_Field setInputView:course_language_Picker];
    
    next_text_field = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(turn_to_next_text_field:)];

    done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissChoice)];
    [self.view addGestureRecognizer:gesture];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    active_Field = textField;
    
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:next_text_field];
    
    if (year_Text_Field == textField) {
        [settings_Scroll_View setContentOffset:CGPointMake(settings_Scroll_View.frame.origin.x, year_Label.frame.origin.y-(year_Label.frame.size.height+self.navigationController.navigationBar.frame.size.height)) animated:YES];
        [next_text_field setTitle:@"Next"];
    }
    else if (speciality_Text_Field == textField) {
        [settings_Scroll_View setContentOffset:CGPointMake(settings_Scroll_View.frame.origin.x, speciality_Label.frame.origin.y-(speciality_Label.frame.size.height+self.navigationController.navigationBar.frame.size.height)) animated:YES];
        if (![next_text_field.title isEqualToString:@"Next"]) {
            [next_text_field setTitle:@"Next"];
        }
    }
    else{
        [settings_Scroll_View setContentOffset:CGPointMake(settings_Scroll_View.frame.origin.x, course_language_Label.frame.origin.y-(course_language_Label.frame.size.height+self.navigationController.navigationBar.frame.size.height)) animated:YES];
        [next_text_field setTitle:@"Again"];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    active_Field = nil;
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:nil];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (year_Picker == pickerView) {
        [year_Text_Field setText:[years objectAtIndex:row]];
        if ([year_Text_Field.text isEqualToString:@"4"]) {
            specialities = [[NSArray alloc]initWithObjects:@"IT", nil];
            [speciality_Picker reloadAllComponents];
            [speciality_Text_Field setText:[specialities objectAtIndex:0]];
        }
        else {
            specialities = [[NSArray alloc]initWithObjects:@"Translation Studies",@"Accounting",@"Economics", @"Finance", @"Marketing", @"Management", @"IT", nil];
        }
        [speciality_Picker reloadAllComponents];
    }
    else if (speciality_Picker == pickerView) {
        [speciality_Text_Field setText:[specialities objectAtIndex:row]];
    }
    else if (course_language_Picker == pickerView) {
        [course_language_Text_Field setText:[course_languages objectAtIndex:row]];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (year_Picker == pickerView) {
        return [years count];
    }
    else if (speciality_Picker == pickerView) {
        return [specialities count];
    }
    else if (course_language_Picker == pickerView) {
        return [course_languages count];
    }
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSAttributedString*)formatText:(NSString*)string {
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attString;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (year_Picker == pickerView) {
        return [self formatText:[years objectAtIndex:row]];
    }
    else if (speciality_Picker == pickerView) {
        return [self formatText:[specialities objectAtIndex:row]];
    }
    else if (course_language_Picker == pickerView) {
        return [self formatText:[course_languages objectAtIndex:row]];
    }
    return nil;
}

-(void)dismissChoice {
    [year_Text_Field resignFirstResponder];
    [speciality_Text_Field resignFirstResponder];
    [course_language_Text_Field resignFirstResponder];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController&&(year_Text_Field||speciality_Text_Field||course_language_Text_Field)) {
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

- (void)done:(id)sender{
    
    if (year_Text_Field == active_Field) {
        [year_Text_Field resignFirstResponder];
    }
    else if (speciality_Text_Field == active_Field) {
        [speciality_Text_Field resignFirstResponder];
    }
    else{
        [course_language_Text_Field resignFirstResponder];
    }

    [self.navigationController.navigationBar.topItem.rightBarButtonItem setEnabled:NO];
    NSString *groupName = speciality_Text_Field.text;
    groupName = [[groupName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]componentsJoinedByString:@""];
    groupName = [groupName stringByAppendingString:year_Text_Field.text];
    groupName = [groupName stringByAppendingString:course_language_Text_Field.text];
    [self create_Download_Signs];
    [updateIt performUpdate:groupName speciality_Text_Field_Text:[speciality_Text_Field text] year_Text_Field_Text:[year_Text_Field text] course_language_Text_Field:[course_language_Text_Field text] options:@"Student_Settings"];
}

- (void)turn_to_next_text_field:(id)sender{
    if (year_Text_Field == active_Field) {
        [speciality_Text_Field becomeFirstResponder];
    }
    else if (speciality_Text_Field == active_Field) {
        [course_language_Text_Field becomeFirstResponder];
    }
    else{
        [year_Text_Field becomeFirstResponder];
    }
}

- (IBAction)TurnNotificationsForLessons:(id)sender {
    if (self.notifications_Controller.on) {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
            sqlite3_stmt *select_statement;
            NSString *select_querySQL = [NSString stringWithFormat:@"SELECT DATABASENAME, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, LUNCH FROM DATABASENAMES WHERE id=%d",1];
            const char *select_query_stmt = [select_querySQL UTF8String];
            if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(select_statement) == SQLITE_ROW) {
                    NSString *object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                    if (![object isEqualToString:@""]) {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 1)]isEqualToString:@"00:00\n00:00"]&&[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 2)]isEqualToString:@"00:00\n00:00"]&&[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 3)]isEqualToString:@"00:00\n00:00"]&&[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 4)]isEqualToString:@"00:00\n00:00"]&&[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 5)]isEqualToString:@"00:00\n00:00"]&&[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 6)]isEqualToString:@"00:00\n00:00"]&&[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 7)]isEqualToString:@"00:00\n00:00"]&&[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 8)]isEqualToString:@"00:00\n00:00"]&&[[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 9)]isEqualToString:@"00:00\n00:00"]) {
                            
                                [[[UIAlertView alloc]initWithTitle:@"FATAL ERROR" message:@"Smth wrong occured on the server, perhaps the durations of your lessons are badly constructed, please warn the person who is responsible for managing schedules about it immediately, otherwise you won't be able to use this feature" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                                [self.notifications_Controller setOn:NO];
                            
                        }
                        else {
                            [app_Delegate.defaults setObject:@"On" forKey:@"NotificationForLesson"];
                            [self.notification_Label setText:@"If you turn it off, you won't be notified about any events anymore"];
                            [[[UIAlertView alloc]initWithTitle:@"WARNING" message:@"This will effect only for the timetable that was updated last & you should use app regularly in order to be notified about events" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                            [app_Delegate start_Timer];
                        }
                    }
                    else {
                        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"You can't turn it on, because there is not available any saved timetable" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                        [self.notifications_Controller setOn:NO];
                    }
                }
            }
            sqlite3_finalize(select_statement);
        }
        sqlite3_close(timetable);
    }
    else {
        [app_Delegate.defaults setObject:@"Off" forKey:@"NotificationForLesson"];
        [self.notification_Label setText:@"If you turn it on, you will be notified every time your lesson is about to begin and when it is over"];
        [[app_Delegate timer]invalidate];
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
    }
}

@end
