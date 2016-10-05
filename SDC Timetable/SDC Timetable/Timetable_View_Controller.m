//
//  Main_View_Controller.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/12/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "Timetable_View_Controller.h"
#import "Timetable.h"
#import "Timetable_Cell.h"
#import "Settings.h"
@implementation Timetable_View_Controller
@synthesize pageViewController;
@synthesize days_titles, lessons, lessons_per_day, lessons_duration, formatted_lessons_duration, saved_Databases, exchange_Databases;
@synthesize days_switch, extraToolButtons;
@synthesize timetable, databasePath;
@synthesize timer;
@synthesize savedDatabaseTableView;
@synthesize savedDatabaseTableViewTopConstraint, savedDatabaseTableViewLeading, savedDatabaseTableViewTrailing, savedDatabaseTableViewWidth;
@synthesize superView;
@synthesize teachers_Settings_Table_View_Controller;
@synthesize currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes, hour, minute;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self initialize_Saved_Databases];
    
    [savedDatabaseTableView setDelegate:self];
    [savedDatabaseTableView setDataSource:self];
    
}

-(void)initialize_Saved_Databases {
    
    const char *dbpath = [databasePath UTF8String];
    
    saved_Databases = [[NSMutableArray alloc]init];
    
    BOOL studentFound = NO;
    
    for (int i=1;i<=4;i++) {
        if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
            sqlite3_stmt *select_statement;
            NSString *selectQuerySQL;
            
            selectQuerySQL = [NSString stringWithFormat:@"SELECT DATABASENAME FROM DATABASENAMES WHERE id=%d",i];
            
            const char *select_query_stmt = [selectQuerySQL UTF8String];
            if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(select_statement) == SQLITE_ROW) {
                    NSString *nameForDatabase = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                    if (![nameForDatabase isEqualToString:@""]) {
                        [saved_Databases addObject:nameForDatabase];
                    }
                    
                    if (!studentFound) {
                        if ([superView isEqualToString:@"Teacher"]) {
                            if (![nameForDatabase isEqualToString:@""]) {
                                for (int j=0;j<[self.specialities count];j++) {
                                    if ([nameForDatabase rangeOfString:[self.specialities objectAtIndex:j] options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                        studentFound = YES;
                                    }
                                }
                            }
                            else {
                                studentFound = YES;
                            }
                            if (!studentFound) {
                                if (i==4||!studentFound) {
                                    updateHasBeenCompleted = YES;
                                    studentFound = YES;
                                }
                            }
                            else {
                                if (i==4) {
                                    updateHasBeenCompleted = NO;
                                }
                            }
                        }
                    }
                    
                }
            }
            sqlite3_finalize(select_statement);
        }
        sqlite3_close(timetable);
    }
    
    if ([saved_Databases count] < 2) {
        [extraToolButtons setEnabled:NO forSegmentAtIndex:0];
        [savedDatabaseTableView setHidden:YES];
    }
    else {
        [extraToolButtons setEnabled:YES forSegmentAtIndex:0];
        [savedDatabaseTableView setHidden:NO];
        [savedDatabaseTableView reloadData];
    }
    
    if ([superView isEqualToString:@"Student"]) {
        [pageViewController.view setUserInteractionEnabled:YES];
        [days_switch setUserInteractionEnabled:YES];
    }
    else if ([superView isEqualToString:@"Teacher"]) {
        [pageViewController.view setUserInteractionEnabled:YES];
        [days_switch setUserInteractionEnabled:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"submit_Choice" object:nil];
    [savedDatabaseTableView setHidden:YES];
}

-(void)didRotate:(NSNotification *)notification
{
    [self set_Scroll_View_Content_Size_According_To_Orientation];
}

-(void)set_Scroll_View_Content_Size_According_To_Orientation {
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if ((newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight))
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
            if ([[ver objectAtIndex:0] intValue] >= 8) {
                CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                if (screenSize.width == 736.0f) {
                    [pageViewController.view setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+days_switch.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-33)];
                }
                else {
                    [pageViewController.view setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+days_switch.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-23)];
                }
                
                if (teacher_Settings_Is_Presented) {
                    [[teachers_Settings_Table_View_Controller view] setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height))];
                }
                
                savedDatabaseTableViewTopConstraint.constant = self.navigationController.navigationBar.frame.size.height;
            }
            else {
                [pageViewController.view setFrame:CGRectMake(0, 20+self.navigationController.navigationBar.frame.size.height+days_switch.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-43)];
                
                if (teacher_Settings_Is_Presented) {
                    [[teachers_Settings_Table_View_Controller view] setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height+20))];
                }
                
                savedDatabaseTableViewTopConstraint.constant = self.navigationController.navigationBar.frame.size.height+20;
            }
        }
        else {
            [pageViewController.view setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+days_switch.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height+12))];
            
            if (teacher_Settings_Is_Presented) {
                [[teachers_Settings_Table_View_Controller view] setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height+20))];
            }
            
            savedDatabaseTableViewTopConstraint.constant = self.navigationController.navigationBar.frame.size.height+20;
        }
    }
    else if (newOrientation == UIInterfaceOrientationPortrait || newOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [pageViewController.view setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height+days_switch.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.navigationController.navigationBar.frame.size.height+12))];
        
        if (teacher_Settings_Is_Presented) {
            [[teachers_Settings_Table_View_Controller view] setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-([UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height))];
        }
        
        savedDatabaseTableViewTopConstraint.constant = [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height;
    }
    if (!self.savedDatabaseTableViewOpened) {
        savedDatabaseTableViewLeading.constant = -self.view.frame.size.width;
        savedDatabaseTableViewTrailing.constant = -self.view.frame.size.width;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if ([self.navigationController respondsToSelector:
         @selector(interactivePopGestureRecognizer)]) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    }
    [self set_Scroll_View_Content_Size_According_To_Orientation];
    [self check_timetable_availability];
    if (!constraintsShouldBeAdded) {
        constraintsShouldBeAdded = YES;
        [self.view removeConstraint:savedDatabaseTableViewWidth];
        savedDatabaseTableViewLeading = [NSLayoutConstraint constraintWithItem:savedDatabaseTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:-self.view.frame.size.width];
        [self.view addConstraint:savedDatabaseTableViewLeading];
        savedDatabaseTableViewTrailing = [NSLayoutConstraint constraintWithItem:savedDatabaseTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-self.view.frame.size.width];
        [self.view addConstraint:savedDatabaseTableViewTrailing];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
}

-(void)goToSetings{
    Settings *settings =
    [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:settings animated:YES];
}

-(void)previous_lesson:(NSIndexPath*)previous_index_path current_lesson:(NSIndexPath*)index_path {
    
    Timetable_Cell *cell = (Timetable_Cell*)[[[pageViewController.viewControllers objectAtIndex:0] tableView] cellForRowAtIndexPath:index_path];
    
        if (cell&&![[cell.lesson.text capitalizedString] isEqualToString:@""]) {
            
            if (previous_index_path) {
                
                Timetable_Cell *prev_cell = (Timetable_Cell*)[[[pageViewController.viewControllers objectAtIndex:0] tableView] cellForRowAtIndexPath:previous_index_path];
                
                if (previous_index_path.row%2!=0) {
                    [prev_cell.lesson setBackgroundColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
                    [prev_cell.lesson setTextColor:[UIColor whiteColor]];
                }
                else{
                    [prev_cell.lesson setBackgroundColor:[UIColor whiteColor]];
                    [prev_cell.lesson setTextColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
                }
                
                [prev_cell.number_of_lesson setBackgroundColor:[prev_cell.lesson textColor]];
                [prev_cell.number_of_lesson setTextColor:[prev_cell.lesson backgroundColor]];
                [prev_cell.lesson_duration setBackgroundColor:[prev_cell.lesson textColor]];
                [prev_cell.lesson_duration setTextColor:[prev_cell.lesson backgroundColor]];
                
            }
            
            self.lessonIsGrayed = YES;
            [cell.lesson setBackgroundColor:[UIColor lightGrayColor]];
        }
        else {
            self.lessonIsGrayed = NO;
        }
    
}

-(void)verifyTimeDurationAtIndex:(int)i {
    if ([[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue]) {
        if (hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]&&(minute>=[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]&&minute<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:3]intValue])) {
            self.indexOfLesson = i;
        }
    }
    else if ([[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]==59&&[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:3]intValue]==0) {
        if ((hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]&&minute==59)||(hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue]&&(minute==0))) {
            self.indexOfLesson = i;
        }
    }
    else if ([[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]==59) {
        if ((hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]&&minute==59)||(hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue]&&(minute>=0&&minute<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:3]intValue]))) {
            self.indexOfLesson = i;
        }
    }
    else if ([[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:3]intValue]==0) {
        if ((hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]&&(minute>=[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]&&minute<=59))||(hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue]&&(minute==0))) {
            self.indexOfLesson = i;
        }
    }
    else {
        if ((hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]&&(minute>=[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]&&minute<=59))||(hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue]&&(minute>=0&&minute<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:3]intValue]))) {
            self.indexOfLesson = i;
        }
    }
}

-(void)check_current_lesson {
    BOOL arraysContainTheSameObjects = YES;
    for (NSString *duration in lessons_duration) {
        if (![duration isEqualToString:@"00:00\n00:00"]) {
            arraysContainTheSameObjects = NO;
            break;
        }
    }
    if (arraysContainTheSameObjects) {
        [timer invalidate];
    }
    if (!arraysContainTheSameObjects) {
        
        NSDate *date = [NSDate date];
        
        NSDate *currentTime = [NSDate date];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponants = [calendar components:
                                            (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: currentTime];
        currentTime = [calendar dateFromComponents:dateComponants];
        [self.postedDateFormat setDateFormat:@"EEEE"];
        [self.postedDateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
        NSString *today=[self.postedDateFormat stringFromDate:currentTime];
        
        if (([today isEqualToString:@"Monday"]&&[days_switch selectedSegmentIndex]==0)||
            ([today isEqualToString:@"Tuesday"]&&[days_switch selectedSegmentIndex]==1)||
            ([today isEqualToString:@"Wednesday"]&&[days_switch selectedSegmentIndex]==2)||
            ([today isEqualToString:@"Thursday"]&&[days_switch selectedSegmentIndex]==3)||
            ([today isEqualToString:@"Friday"]&&[days_switch selectedSegmentIndex]==4)) {
            
            [self.postedDateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"kk_KZ"]];
            NSString *hour_string, *minute_string;
            
            [self.postedDateFormat setDateFormat:@"HH"];
            hour_string = [self.postedDateFormat stringFromDate:date];
            hour = [hour_string intValue];
            
            [self.postedDateFormat setDateFormat:@"mm"];
            minute_string = [self.postedDateFormat stringFromDate:date];
            minute = [minute_string intValue];
            
            self.indexOfLesson = 9;
            self.previousIndexOfLesson = 9;
            for (int i=0;i<[lessons_duration count];i++) {
                if (![[lessons_duration objectAtIndex:i]isEqualToString:@"00:00\n00:00"]) {
                    [self verifyTimeDurationAtIndex:i];
                    if (self.indexOfLesson!=9) {
                        break;
                    }
                }
            }
            
            
            if (self.indexOfLesson!=9) {
                
                NSIndexPath *index_path = [NSIndexPath indexPathForRow:self.indexOfLesson inSection:0];
                NSIndexPath *previous_index_path;
                
                self.previousIndexOfLesson = self.indexOfLesson;
                self.previousIndexOfLesson--;
                
                if (self.previousIndexOfLesson>=0&&self.previousIndexOfLesson<8) {
                    previous_index_path = [NSIndexPath indexPathForRow:self.previousIndexOfLesson inSection:0];
                }
                else {
                    previous_index_path = nil;
                }
                
                if ([[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:0]intValue]==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:2]intValue]) {
                    if (hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:0]intValue]&&(minute>=[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:1]intValue]&&minute<[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:3]intValue])) {
                        [self previous_lesson:previous_index_path current_lesson:index_path];
                        }
                }
                else if ([[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:1]intValue]==59&&[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:3]intValue]==0) {
                    if ((hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:0]intValue]&&minute==59)||(hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:2]intValue]&&
                         (minute==0))) {
                        [self previous_lesson:previous_index_path current_lesson:index_path];
                        }
                }
                else if ([[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:1]intValue]==59) {
                    if ((hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:0]intValue]&&minute==59)||(hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:2]intValue]&&(minute>=0&&minute<[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:3]intValue]))) {
                        [self previous_lesson:previous_index_path current_lesson:index_path];
                         }
                }
                else if ([[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:3]intValue]==0) {
                    if ((hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:0]intValue]&&(minute>=[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:1]intValue]&&minute<=59))||(hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:2]intValue]&&
                         (minute==0))) {
                        [self previous_lesson:previous_index_path current_lesson:index_path];
                        }
                }
                else {
                    if ((hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:0]intValue]&&(minute>=[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:1]intValue]&&minute<=59))||(hour==[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:2]intValue]&&(minute>=0&&minute<[[[formatted_lessons_duration objectAtIndex:self.indexOfLesson]objectAtIndex:3]intValue]))) {
                        [self previous_lesson:previous_index_path current_lesson:index_path];
                         }
                }
            }
            else {
                if (self.lessonIsGrayed) {
                    for (int i=0;i<9;i++) {
                        NSIndexPath *previous_index_path = [NSIndexPath indexPathForRow:i inSection:0];
                        Timetable_Cell *cell = (Timetable_Cell*)[[[pageViewController.viewControllers objectAtIndex:0] tableView] cellForRowAtIndexPath:previous_index_path];
                        if ([cell.lesson backgroundColor]==[UIColor lightGrayColor]) {
                            self.lessonIsGrayed = NO;
                        }
                        if (previous_index_path.row%2!=0) {
                            [cell.lesson setBackgroundColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
                            [cell.lesson setTextColor:[UIColor whiteColor]];
                        }
                        else{
                            [cell.lesson setBackgroundColor:[UIColor whiteColor]];
                            [cell.lesson setTextColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
                        }
                        
                        [cell.number_of_lesson setBackgroundColor:[cell.lesson textColor]];
                        [cell.number_of_lesson setTextColor:[cell.lesson backgroundColor]];
                        [cell.lesson_duration setBackgroundColor:[cell.lesson textColor]];
                        [cell.lesson_duration setTextColor:[cell.lesson backgroundColor]];
                        if (!self.lessonIsGrayed) {
                            break;
                        }
                    }
                }
            }
        }
    }
}

-(void)foundDatabase:(int)index dbpath:(const char *)dbpath lastrow:(int)lastrow {
    lessons_duration = [[NSMutableArray alloc]initWithObjects:self.first,self.second,self.third,self.fourth,self.fifth,self.sixth,self.seventh,self.eighth,self.lunch,nil];
    lessons = [NSMutableArray new];
    for (int j=0;j<[days_titles count];j++) {
        lessons_per_day = [NSMutableArray new];
        for (int i=1;i<=lastrow;i++) {
            if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
                sqlite3_stmt *statement;
                NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM DATABASE%i WHERE id=%d",[days_titles objectAtIndex:j],index,i];
                const char *query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(timetable, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_ROW) {
                        NSString *object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                        [lessons_per_day addObject:object];
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(timetable);
        }
        [lessons addObject:lessons_per_day];
    }
     
    lessons_per_day = [NSMutableArray new];
    
    if ([lessons count]!=0) {
        self.postedDateFormat = [[NSDateFormatter alloc] init];
        [self.postedDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Almaty"]];
        
        NSDate *currentTime = [NSDate date];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponants = [calendar components:
                                            (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: currentTime];
        currentTime = [calendar dateFromComponents:dateComponants];
        [self.postedDateFormat setDateFormat:@"EEEE"];
        [self.postedDateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
        NSString *today=[self.postedDateFormat stringFromDate:currentTime];
        
        NSInteger today_index = 0;
        
        [self.postedDateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"kk_KZ"]];
        NSString *hour_string, *minute_string;
        
        NSDate *date = [NSDate date];
        
        [self.postedDateFormat setDateFormat:@"HH"];
        hour_string = [self.postedDateFormat stringFromDate:date];
        hour = [hour_string intValue];
        
        [self.postedDateFormat setDateFormat:@"mm"];
        minute_string = [self.postedDateFormat stringFromDate:date];
        minute = [minute_string intValue];

        NSArray *arrayOfLastLessonDurations = [self formatLessonDurationBeforeUpdate:self.eighth];

        if ([today isEqualToString:@"Monday"]) {
            if (hour>[[arrayOfLastLessonDurations objectAtIndex:2]intValue]||(hour==[[arrayOfLastLessonDurations objectAtIndex:2]intValue]&&minute>[[arrayOfLastLessonDurations objectAtIndex:3]intValue])) {
                today_index++;
            }
        }
        else if ([today isEqualToString:@"Tuesday"]) {
            today_index = 1;
            if (hour>[[arrayOfLastLessonDurations objectAtIndex:2]intValue]||(hour==[[arrayOfLastLessonDurations objectAtIndex:2]intValue]&&minute>[[arrayOfLastLessonDurations objectAtIndex:3]intValue])) {
                today_index++;
            }
        }
        else if ([today isEqualToString:@"Wednesday"]) {
            today_index = 2;
            if (hour>[[arrayOfLastLessonDurations objectAtIndex:2]intValue]||(hour==[[arrayOfLastLessonDurations objectAtIndex:2]intValue]&&minute>[[arrayOfLastLessonDurations objectAtIndex:3]intValue])) {
                today_index++;
            }
        }
        else if ([today isEqualToString:@"Thursday"]) {
            today_index = 3;
            if (hour>[[arrayOfLastLessonDurations objectAtIndex:2]intValue]||(hour==[[arrayOfLastLessonDurations objectAtIndex:2]intValue]&&minute>[[arrayOfLastLessonDurations objectAtIndex:3]intValue])) {
                today_index++;
            }
        }
        else if ([today isEqualToString:@"Friday"]) {
            today_index = 4;
            if (hour>[[arrayOfLastLessonDurations objectAtIndex:2]intValue]||(hour==[[arrayOfLastLessonDurations objectAtIndex:2]intValue]&&minute>[[arrayOfLastLessonDurations objectAtIndex:3]intValue])) {
                today_index = 0;
            }
        }
        
        arrayOfLastLessonDurations = nil;
        
        NSArray *currentDayLessons = [lessons objectAtIndex:today_index];
        for (int i=0;i<[currentDayLessons count];i++) {
            if ([currentDayLessons objectAtIndex:i]&&![[currentDayLessons objectAtIndex:i]isEqualToString:@""]&&([[currentDayLessons objectAtIndex:i] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Bon appetit" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Приятного аппетита" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Afiyet olsun" options:NSCaseInsensitiveSearch].location!= NSNotFound)) {
                for (int j=i;j<[currentDayLessons count]-1;j++) {
                    [lessons_duration exchangeObjectAtIndex:j withObjectAtIndex:[lessons_duration count]-1];
                }
                break;
            }
        }
        
        formatted_lessons_duration = [NSMutableArray new];
        
        for (int i=0;i<[lessons_duration count];i++) {
            [formatted_lessons_duration addObject:[self formatLessonDurationBeforeUpdate:[lessons_duration objectAtIndex:i]]];
        }
        
        [days_switch setSelectedSegmentIndex:today_index];
        
        Timetable *startingViewController = [self viewControllerAtIndex:today_index];
        NSArray *viewControllers = @[startingViewController];
        
        [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [timer invalidate];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(check_current_lesson) userInfo:self repeats:YES];
        
        
        
        if ([[self.app_Delegate.defaults objectForKey:@"NotificationForLesson"]isEqualToString:@"On"]) {
            [[UIApplication sharedApplication]cancelAllLocalNotifications];
        }
        
        [extraToolButtons setEnabled:YES forSegmentAtIndex:1];
        
    }
    else {
        [[[UIAlertView alloc]initWithTitle:nil message:@"The timetable is currently unavailable. You should go to the Settings and update it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",nil]show];
    }
    
}

-(NSArray*)formatLessonDurationBeforeUpdate:(NSString*)text {
    
    int counter = 0;
    int lastDecimalIndex = 0;
    
    currentBeginningHour = 0;
    currentBeginningMinutes = 0;
    currentFinishingHour = 0;
    currentFinishingMinutes = 0;
    
    for (int i=0;i<[text length];i++) {
        if (i==[text length]-1) {
            if ([[text substringWithRange:NSMakeRange(lastDecimalIndex, [text length]-lastDecimalIndex)]characterAtIndex:0]=='0'&&[[text substringWithRange:NSMakeRange(lastDecimalIndex, [text length]-lastDecimalIndex)]length]==2) {
                currentFinishingMinutes = [[text substringWithRange:NSMakeRange(lastDecimalIndex+1, 1)]
                                           intValue];
            }
            else {
                currentFinishingMinutes = [[text substringWithRange:NSMakeRange(lastDecimalIndex, 2)]intValue];
            }
        }
        else if (![[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i]]) {
            if (counter==1) {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i-1]]) {
                    if ([[text substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]characterAtIndex:0]=='0'&&[[text substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]length]==2) {
                        currentBeginningMinutes = [[text substringWithRange:NSMakeRange(lastDecimalIndex+1, 1)]intValue];
                    }
                    else {
                        currentBeginningMinutes = [[text substringWithRange:NSMakeRange(lastDecimalIndex, 2)]intValue];
                    }
                    lastDecimalIndex = i+1;
                    counter++;
                }
            }
            else if (counter==2) {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i-1]]) {
                    if ([[text substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]characterAtIndex:0]=='0'&&[[text substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]length]==2) {
                        currentFinishingHour = [[text substringWithRange:NSMakeRange(lastDecimalIndex+1, 1)]intValue];
                    }
                    else {
                        currentFinishingHour = [[text substringWithRange:NSMakeRange(lastDecimalIndex, 2)]intValue];
                    }
                    lastDecimalIndex = i+1;
                }
            }
            else {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i-1]]) {
                    if ([[text substringWithRange:NSMakeRange(0, i)]characterAtIndex:0]=='0'&&[[text substringWithRange:NSMakeRange(0, i)]length]==2) {
                        currentBeginningHour = [[text substringWithRange:NSMakeRange(1, i-1)]intValue];
                    }
                    else {
                        currentBeginningHour = [[text substringWithRange:NSMakeRange(0, i)]intValue];
                    }
                    lastDecimalIndex = i+1;
                    counter++;
                }
            }
        }
    }
    
    NSArray *arrayOfValidDurations = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:currentBeginningHour],[NSNumber numberWithInt:currentBeginningMinutes],[NSNumber numberWithInt:currentFinishingHour],[NSNumber numberWithInt:currentFinishingMinutes],nil];
    
    return arrayOfValidDurations;
}

-(void)check_timetable_availability {
    
    const char *dbpath = [databasePath UTF8String];
    
    for (int i=1;i<=4;i++) {
        
        if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
            sqlite3_stmt *statement;
            NSString *querySQL = [NSString stringWithFormat:@"SELECT DATABASENAME, LASTROW, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, LUNCH FROM DATABASENAMES WHERE id=%d",i];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(timetable, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    self.TitleFromDatabase = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    self.first = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                    self.second = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    self.third = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                    self.fourth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                    self.fifth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                    self.sixth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                    self.seventh = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                    self.eighth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                    self.lunch = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                    self.LastRowFromDatabase = sqlite3_column_int(statement, 1);
                    if ([superView isEqualToString:@"Student"]) {
                        for (int j=0;j<[self.specialities count];j++) {
                            if ([self.TitleFromDatabase rangeOfString:[self.specialities objectAtIndex:j] options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                [self foundDatabase:i dbpath:dbpath lastrow:self.LastRowFromDatabase];
                                [self.navigationController.navigationBar.topItem setTitle:self.TitleFromDatabase];
                                i=5;
                            } else {
                                if (i==4 && j==[self.specialities count]-1) {
                                    [[[UIAlertView alloc]initWithTitle:nil message:@"None of saved timetables assigned for students are currently available. You should go to the Settings and update it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",nil]show];
                                    [extraToolButtons setEnabled:NO forSegmentAtIndex:0];
                                    [extraToolButtons setEnabled:NO forSegmentAtIndex:1];
                                }
                            }
                        }
                    }
                    else if ([superView isEqualToString:@"Teacher"]) {
                        
                        BOOL studentFound = NO;
                        
                        if (![self.TitleFromDatabase isEqualToString:@""]) {
                            for (int j=0;j<[self.specialities count];j++) {
                                if ([self.TitleFromDatabase rangeOfString:[self.specialities objectAtIndex:j] options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                    studentFound = YES;
                                }
                            }
                        }
                        else {
                            studentFound = YES;
                        }
                        if (!studentFound) {
                            [self foundDatabase:i dbpath:dbpath lastrow:self.LastRowFromDatabase];
                            [self.navigationController.navigationBar.topItem setTitle:self.TitleFromDatabase];
                                i = 5;
                        }
                        else {
                            if (i==4 && studentFound) {
                                [[[UIAlertView alloc]initWithTitle:nil message:@"None of saved timetables assigned for teachers are currently available. You should update it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",nil]show];
                                [extraToolButtons setEnabled:NO forSegmentAtIndex:0];
                                [extraToolButtons setEnabled:NO forSegmentAtIndex:1];
                            }
                        }
                    }
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(timetable);
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [pageViewController.view setUserInteractionEnabled:NO];
        [days_switch setUserInteractionEnabled:NO];
    }
    else if (buttonIndex == 1) {
        if ([superView isEqualToString:@"Student"]) {
            [self goToSetings];
        }
        else if ([superView isEqualToString:@"Teacher"]) {
                [extraToolButtons setEnabled:NO forSegmentAtIndex:0];
                [extraToolButtons setEnabled:NO forSegmentAtIndex:1];
                teacher_Settings_Is_Presented = YES;
                teachers_Settings_Table_View_Controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Teachers_Settings"];
                [self set_Scroll_View_Content_Size_According_To_Orientation];
                [self.view addSubview:[teachers_Settings_Table_View_Controller view]];
                [teachers_Settings_Table_View_Controller.view setAlpha:0];
                [teachers_Settings_Table_View_Controller.view setUserInteractionEnabled:NO];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submit_Choice) name:@"submit_Choice" object:nil];
                [UIView animateWithDuration:0.5 animations:^{
                    [teachers_Settings_Table_View_Controller.view setAlpha:1];
                } completion:^(BOOL finished) {
                    [teachers_Settings_Table_View_Controller.view setUserInteractionEnabled:YES];
                }];
        }
    }
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.app_Delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.specialities = [[NSArray alloc]initWithObjects:@"Translation Studies",@"Accounting",@"Economics", @"Finance", @"Marketing", @"Management", @"IT", nil];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"timetable.db"]];

    days_titles = [[NSArray alloc]initWithObjects:
                   @"MONDAY",@"TUESDAY",@"WEDNESDAY",@"THURSDAY",@"FRIDAY", nil];

    pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    [pageViewController setDataSource:self];
    [pageViewController setDelegate:self];
    
    NSArray *subviews = pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++)
    {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]])
        {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    
    [thisControl removeFromSuperview];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
    
    savedDatabaseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    [savedDatabaseTableView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.5 blue:0.5 alpha:0.3]];
    
    [savedDatabaseTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:savedDatabaseTableView];
    
    savedDatabaseTableViewTopConstraint = [NSLayoutConstraint constraintWithItem:savedDatabaseTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:savedDatabaseTableViewTopConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:savedDatabaseTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    savedDatabaseTableViewWidth = [NSLayoutConstraint constraintWithItem:savedDatabaseTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.view addConstraint:savedDatabaseTableViewWidth];
    
}

- (void)resetConstraintContstantsToTheInitialValues:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate {
    
    if (self.startingRightLayoutConstraintConstant == -self.view.frame.size.width &&
        self.savedDatabaseTableViewTrailing.constant == -self.view.frame.size.width) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.savedDatabaseTableViewTrailing.constant = -self.view.frame.size.width;
        self.savedDatabaseTableViewLeading.constant = -self.view.frame.size.width;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.savedDatabaseTableViewTrailing.constant;
            self.savedDatabaseTableViewOpened = NO;
        }];
    }];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:completion];
}

-(void)enableEverything {
    [[pageViewController view] setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [days_switch setUserInteractionEnabled:YES];
}

- (IBAction)extraButtonsClick:(id)sender {
    UISegmentedControl *usedExtraToolButtons = (UISegmentedControl*)sender;
    if ([usedExtraToolButtons selectedSegmentIndex]==0) {
        [[pageViewController view] setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [days_switch setUserInteractionEnabled:NO];
        [extraToolButtons setEnabled:NO forSegmentAtIndex:0];
        [extraToolButtons setEnabled:NO forSegmentAtIndex:1];
        if (!self.savedDatabaseTableViewOpened) {
            self.savedDatabaseTableViewOpened = YES;
            savedDatabaseTableViewLeading.constant = 0;
            savedDatabaseTableViewTrailing.constant = 0;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [self.view layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 [extraToolButtons setEnabled:YES forSegmentAtIndex:0];
                                 [self enableEverything];
                             }];
        }
        else {
            self.savedDatabaseTableViewOpened = NO;
            savedDatabaseTableViewLeading.constant = -self.view.frame.size.width;
            savedDatabaseTableViewTrailing.constant = -self.view.frame.size.width;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [self.view layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 [extraToolButtons setEnabled:YES forSegmentAtIndex:0];
                                 [extraToolButtons setEnabled:YES forSegmentAtIndex:1];
                                 [self enableEverything];
                             }];
        }
    }
    else if ([usedExtraToolButtons selectedSegmentIndex]==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"prepareToMakeTimetablePhoto" object:nil];
    }
    else {
        if ([superView isEqualToString:@"Student"]) {
            [self goToSetings];
        }
        else if ([superView isEqualToString:@"Teacher"]) {
            if (!teacher_Settings_Is_Presented) {
                [extraToolButtons setEnabled:NO forSegmentAtIndex:0];
                [extraToolButtons setEnabled:NO forSegmentAtIndex:1];
                teacher_Settings_Is_Presented = YES;
                teachers_Settings_Table_View_Controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Teachers_Settings"];
                [self set_Scroll_View_Content_Size_According_To_Orientation];
                [self.view addSubview:[teachers_Settings_Table_View_Controller view]];
                [teachers_Settings_Table_View_Controller.view setAlpha:0];
                [teachers_Settings_Table_View_Controller.view setUserInteractionEnabled:NO];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submit_Choice) name:@"submit_Choice" object:nil];
                [UIView animateWithDuration:0.5 animations:^{
                    [teachers_Settings_Table_View_Controller.view setAlpha:1];
                } completion:^(BOOL finished) {
                    [teachers_Settings_Table_View_Controller.view setUserInteractionEnabled:YES];
                }];
            }
            else {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"submit_Choice" object:nil];
                [teachers_Settings_Table_View_Controller.view setUserInteractionEnabled:NO];
                [UIView animateWithDuration:0.5 animations:^{
                    [teachers_Settings_Table_View_Controller.view setAlpha:0];
                } completion:^(BOOL finished) {
                    [self initialize_Saved_Databases];
                    [teachers_Settings_Table_View_Controller.view removeFromSuperview];
                    teacher_Settings_Is_Presented = NO;
                    [extraToolButtons setEnabled:YES forSegmentAtIndex:1];
                }];
            }
        }
    }
    [extraToolButtons setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

-(void)submit_Choice {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"submit_Choice" object:nil];
    [days_switch setSelectedSegmentIndex:0];
    [teachers_Settings_Table_View_Controller.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [teachers_Settings_Table_View_Controller.view setAlpha:0];
    } completion:^(BOOL finished) {
        [extraToolButtons setEnabled:YES forSegmentAtIndex:0];
        [self initialize_Saved_Databases];
        [teachers_Settings_Table_View_Controller.view removeFromSuperview];
        teacher_Settings_Is_Presented = NO;
        [self check_timetable_availability];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [saved_Databases count];
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Database"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Database"];
    }
    [cell setBackgroundColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setText:[saved_Databases objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row!=0) {
        
        [tableView beginUpdates];
        
        NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:destinationIndexPath];
        NSIndexPath *previousIndexPath = destinationIndexPath;
        [tableView moveRowAtIndexPath:previousIndexPath toIndexPath:indexPath];
        
        const char *dbpath = [databasePath UTF8String];
        
        exchange_Databases = [[NSMutableArray alloc]init];
        
        if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
        
        mainDatabasesHaveBeenUpdated = NO;
            
        NSInteger selectedIndex = indexPath.row+1;
            
        [self selectDatabaseAtIndex:selectedIndex];
            
        mainDatabasesHaveBeenUpdated = YES;
        
        [self selectDatabaseAtIndex:selectedIndex];
            
        self.TitleFromDatabase = @"Empty Timetable";
        self.LastRowFromDatabase = 0;
    
        mainDatabasesHaveBeenUpdated = NO;
            
        [self updateDatabaseAtIndex:selectedIndex];
            
        mainDatabasesHaveBeenUpdated = YES;
            
        [self updateDatabaseAtIndex:selectedIndex];
         
        [exchange_Databases removeAllObjects];
            
        }
        sqlite3_close(timetable);
        
        [self foundDatabase:1 dbpath:dbpath lastrow:self.LastRowFromDatabase];
        [self.navigationController.navigationBar.topItem setTitle:self.TitleFromDatabase];
        
        [tableView endUpdates];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetConstraintContstantsToTheInitialValues:YES notifyDelegateDidClose:YES];
        [self.view setUserInteractionEnabled:YES];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    });
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
            mainDatabasesHaveBeenUpdated = NO;
            [self cleanDatabaseAtIndex:indexPath.row];
            mainDatabasesHaveBeenUpdated = YES;
            [self cleanDatabaseAtIndex:indexPath.row];
            [saved_Databases removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            if (indexPath.row<3) {
                exchange_Databases = [[NSMutableArray alloc]init];
                mainDatabasesHaveBeenUpdated = NO;
                [self replaceDatabaseAtIndex:indexPath.row];
                [exchange_Databases removeAllObjects];
                mainDatabasesHaveBeenUpdated = YES;
                [self replaceDatabaseAtIndex:indexPath.row];
                [exchange_Databases removeAllObjects];
            }
            if ([saved_Databases count]<=1) {
                if (indexPath.row==0) {
                    mainDatabasesHaveBeenUpdated = NO;
                    [self obliteratePreviousDatabases];
                    mainDatabasesHaveBeenUpdated = YES;
                    [self obliteratePreviousDatabases];
                }
                self.savedDatabaseTableViewOpened = NO;
                savedDatabaseTableViewLeading.constant = -self.view.frame.size.width;
                savedDatabaseTableViewTrailing.constant = -self.view.frame.size.width;
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     [self.view layoutIfNeeded];
                                 } completion:^(BOOL finished) {
                                     [extraToolButtons setEnabled:NO forSegmentAtIndex:0];
                                     [extraToolButtons setEnabled:YES forSegmentAtIndex:1];
                                     [self enableEverything];
                                 }];
            }
            if (indexPath.row==0) {
                NSString *selectQuerySQL = [NSString stringWithFormat:@"SELECT DATABASENAME, LASTROW, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, LUNCH FROM DATABASENAMES WHERE id=%i",1];
                sqlite3_stmt *select_statement;
                const char *select_query_stmt = [selectQuerySQL UTF8String];
                if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(select_statement) == SQLITE_ROW) {
                        self.TitleFromDatabase = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                        self.LastRowFromDatabase = sqlite3_column_int(select_statement, 1);
                        self.first = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 2)];
                        self.second = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 3)];
                        self.third = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 4)];
                        self.fourth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 5)];
                        self.fifth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 6)];
                        self.sixth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 7)];
                        self.seventh = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 8)];
                        self.eighth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 9)];
                        self.lunch = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 10)];
                    }
                }
                sqlite3_finalize(select_statement);
                [self foundDatabase:1 dbpath:dbpath lastrow:self.LastRowFromDatabase];
                [self.navigationController.navigationBar.topItem setTitle:self.TitleFromDatabase];
            }
        }
        sqlite3_close(timetable);
    }
}

-(void)obliteratePreviousDatabases {
    NSString *cleanQuerySQL;
    sqlite3_stmt *clean_query_statement;
    for (int j=2;j<5;j++) {
        for (int d=0;d<[days_titles count];d++) {
            for (int i=1;i<10;i++) {
                if (!mainDatabasesHaveBeenUpdated) {
                    cleanQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASE%i SET %@=\"\" WHERE id=\"%d\"", j, [[days_titles objectAtIndex:d]uppercaseString],i];
                }
                else {
                    cleanQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASENAMES SET DATABASENAME=\"\", LASTROW=%i, FIRST=\"\", SECOND=\"\", THIRD=\"\", FOURTH=\"\", FIFTH=\"\", SIXTH=\"\", SEVENTH=\"\", EIGHTH=\"\", LUNCH=\"\" WHERE id=\"%i\"",0,j];
                }
                const char *clean_query_stmt = [cleanQuerySQL UTF8String];
                sqlite3_prepare_v2(timetable, clean_query_stmt, -1, &clean_query_statement, NULL);
                if (sqlite3_step(clean_query_statement) == SQLITE_DONE) {}
                sqlite3_finalize(clean_query_statement);
                if (mainDatabasesHaveBeenUpdated) {
                    break;
                }
            }
            if (mainDatabasesHaveBeenUpdated) {
                break;
            }
        }
    }
}

-(void)replaceDatabaseAtIndex:(NSInteger)index {
    sqlite3_stmt *select_statement;
    NSString *selectQuerySQL;
    NSMutableArray *arrayOfLessonsInDay = [NSMutableArray new], *arrayOfAllLessonsInOneWeek = [NSMutableArray new];
    for (int j=(int)index+2;j<5; j++) {
        for (NSString *day in days_titles) {
            for (int i=1;i<10;i++) {
                if (!mainDatabasesHaveBeenUpdated) {
                    selectQuerySQL  = [NSString stringWithFormat:@"SELECT %@ FROM DATABASE%li WHERE id=%d",
                                       [day uppercaseString],(long)j,i];
                }
                else {
                    selectQuerySQL = [NSString stringWithFormat:@"SELECT DATABASENAME, LASTROW, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, LUNCH FROM DATABASENAMES WHERE id=%li",(long)j];
                }
                const char *select_query_stmt = [selectQuerySQL UTF8String];
                if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(select_statement) == SQLITE_ROW) {
                        NSString *first, *second, *third, *fourth, *fifth, *sixth, *seventh, *eighth, *lunch, *object; int lastrow = 0;
                        if (!mainDatabasesHaveBeenUpdated) {
                            object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                            [arrayOfLessonsInDay addObject:object];
                        }
                        else {
                            object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                            lastrow = sqlite3_column_int(select_statement, 1);
                            first = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 2)];
                            second = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 3)];
                            third = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 4)];
                            fourth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 5)];
                            fifth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 6)];
                            sixth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 7)];
                            seventh = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 8)];
                            eighth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 9)];
                            lunch = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 10)];
                            
                            [arrayOfAllLessonsInOneWeek addObject:object];
                            [arrayOfAllLessonsInOneWeek addObject:[NSNumber numberWithInt:lastrow]];
                            [arrayOfAllLessonsInOneWeek addObject:first];
                            [arrayOfAllLessonsInOneWeek addObject:second];
                            [arrayOfAllLessonsInOneWeek addObject:third];
                            [arrayOfAllLessonsInOneWeek addObject:fourth];
                            [arrayOfAllLessonsInOneWeek addObject:fifth];
                            [arrayOfAllLessonsInOneWeek addObject:sixth];
                            [arrayOfAllLessonsInOneWeek addObject:seventh];
                            [arrayOfAllLessonsInOneWeek addObject:eighth];
                            [arrayOfAllLessonsInOneWeek addObject:lunch];
                        }
                    }
                }
                sqlite3_finalize(select_statement);
                if (mainDatabasesHaveBeenUpdated) {
                    break;
                }
            }//for ROW IDS
            if (!mainDatabasesHaveBeenUpdated) {
                [arrayOfAllLessonsInOneWeek addObject:arrayOfLessonsInDay];
                arrayOfLessonsInDay = [NSMutableArray new];
            }
            else {
                break;
            }
        }//for DAYS
        [exchange_Databases addObject:arrayOfAllLessonsInOneWeek];
        arrayOfAllLessonsInOneWeek = [NSMutableArray new];
    }//for DATABASES
    
    NSString *replaceQuerySQL;
    sqlite3_stmt *replace_query_statement;
    NSInteger indexOfDatabase = index+1;
    for (int j=0;j<[exchange_Databases count];j++) {
        for (int d=0;d<[days_titles count];d++) {
            for (int i=1;i<10;i++) {
                if (!mainDatabasesHaveBeenUpdated) {
                    replaceQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASE%li SET %@=\"%@\" WHERE id=\"%d\"", (long)indexOfDatabase, [[days_titles objectAtIndex:d]uppercaseString], [[[exchange_Databases objectAtIndex:j]objectAtIndex:d]objectAtIndex:i-1]
                                      , i];
                }
                else {
                    NSString *databaseName = [[exchange_Databases objectAtIndex:j]objectAtIndex:0],
                    *first = [[exchange_Databases objectAtIndex:j]objectAtIndex:2],
                    *second = [[exchange_Databases objectAtIndex:j]objectAtIndex:3],
                    *third = [[exchange_Databases objectAtIndex:j]objectAtIndex:4],
                    *fourth = [[exchange_Databases objectAtIndex:j]objectAtIndex:5],
                    *fifth = [[exchange_Databases objectAtIndex:j]objectAtIndex:6],
                    *sixth = [[exchange_Databases objectAtIndex:j]objectAtIndex:7],
                    *seventh = [[exchange_Databases objectAtIndex:j]objectAtIndex:8],
                    *eighth = [[exchange_Databases objectAtIndex:j]objectAtIndex:9],
                    *lunch = [[exchange_Databases objectAtIndex:j]objectAtIndex:10];
                    int lastrow = [[[exchange_Databases objectAtIndex:j]objectAtIndex:1]intValue];
                    
                    replaceQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASENAMES SET DATABASENAME=\"%@\", LASTROW=%i, FIRST=\"%@\", SECOND=\"%@\", THIRD=\"%@\", FOURTH=\"%@\", FIFTH=\"%@\", SIXTH=\"%@\", SEVENTH=\"%@\", EIGHTH=\"%@\", LUNCH=\"%@\" WHERE id=\"%li\"", databaseName,lastrow,first,second,third,fourth,fifth,sixth,seventh,eighth,lunch,(long)indexOfDatabase];
                }
                const char *replace_query_stmt = [replaceQuerySQL UTF8String];
                sqlite3_prepare_v2(timetable, replace_query_stmt, -1, &replace_query_statement, NULL);
                if (sqlite3_step(replace_query_statement) == SQLITE_DONE) {}
                sqlite3_finalize(replace_query_statement);
                if (mainDatabasesHaveBeenUpdated) {
                    break;
                }
            }
            if (mainDatabasesHaveBeenUpdated) {
                break;
            }
        }
        indexOfDatabase++;
    }
    [self cleanDatabaseAtIndex:3];
}

-(void)cleanDatabaseAtIndex:(NSInteger)index {
    NSString *cleanQuerySQL;
    sqlite3_stmt *clean_query_statement;
    for (int d=0;d<[days_titles count];d++) {
        for (int i=1;i<10;i++) {
            if (!mainDatabasesHaveBeenUpdated) {
                cleanQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASE%li SET %@=\"\" WHERE id=\"%d\"", (long)index+1, [[days_titles objectAtIndex:d]uppercaseString],i];
            }
            else {
                cleanQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASENAMES SET DATABASENAME=\"\", LASTROW=%i, FIRST=\"\", SECOND=\"\", THIRD=\"\", FOURTH=\"\", FIFTH=\"\", SIXTH=\"\", SEVENTH=\"\", EIGHTH=\"\", LUNCH=\"\" WHERE id=\"%li\"",0,(long)index+1];
            }
            const char *clean_query_stmt = [cleanQuerySQL UTF8String];
            sqlite3_prepare_v2(timetable, clean_query_stmt, -1, &clean_query_statement, NULL);
            if (sqlite3_step(clean_query_statement) == SQLITE_DONE) {}
            sqlite3_finalize(clean_query_statement);
            if (mainDatabasesHaveBeenUpdated) {
                break;
            }
        }
        if (mainDatabasesHaveBeenUpdated) {
            break;
        }
    }
}

-(void) selectDatabaseAtIndex:(NSInteger)index {
    sqlite3_stmt *select_statement;
    NSString *selectQuerySQL;
    BOOL used = NO;
    NSMutableArray *arrayOfLessonsInDay = [NSMutableArray new], *arrayOfAllLessonsInOneWeek = [NSMutableArray new];
    NSInteger indexOfDatabase = 1;
    for (int j=0;j<2; j++) {
        if (used) {
            indexOfDatabase = index;
        }
    for (NSString *day in days_titles) {
        for (int i=1;i<10;i++) {
        if (!mainDatabasesHaveBeenUpdated) {
            selectQuerySQL  = [NSString stringWithFormat:@"SELECT %@ FROM DATABASE%li WHERE id=%d",
                               [day uppercaseString],(long)indexOfDatabase,i];
        }
        else {
            selectQuerySQL = [NSString stringWithFormat:@"SELECT DATABASENAME, LASTROW, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, LUNCH FROM DATABASENAMES WHERE id=%li",(long)indexOfDatabase];
        }
const char *select_query_stmt = [selectQuerySQL UTF8String];
if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
    if (sqlite3_step(select_statement) == SQLITE_ROW) {
        NSString *first, *second, *third, *fourth, *fifth, *sixth, *seventh, *eighth, *lunch, *object; int lastrow = 0;
        if (!mainDatabasesHaveBeenUpdated) {
            object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
            [arrayOfLessonsInDay addObject:object];
        }
        else {
            object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
            lastrow = sqlite3_column_int(select_statement, 1);
            first = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 2)];
            second = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 3)];
            third = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 4)];
            fourth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 5)];
            fifth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 6)];
            sixth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 7)];
            seventh = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 8)];
            eighth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 9)];
            lunch = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 10)];
            
            [arrayOfAllLessonsInOneWeek addObject:object];
            [arrayOfAllLessonsInOneWeek addObject:[NSNumber numberWithInt:lastrow]];
            [arrayOfAllLessonsInOneWeek addObject:first];
            [arrayOfAllLessonsInOneWeek addObject:second];
            [arrayOfAllLessonsInOneWeek addObject:third];
            [arrayOfAllLessonsInOneWeek addObject:fourth];
            [arrayOfAllLessonsInOneWeek addObject:fifth];
            [arrayOfAllLessonsInOneWeek addObject:sixth];
            [arrayOfAllLessonsInOneWeek addObject:seventh];
            [arrayOfAllLessonsInOneWeek addObject:eighth];
            [arrayOfAllLessonsInOneWeek addObject:lunch];
        }
    }
}
sqlite3_finalize(select_statement);
          if (mainDatabasesHaveBeenUpdated) {
              break;
          }
            }//for ROW IDS
        if (!mainDatabasesHaveBeenUpdated) {
            [arrayOfAllLessonsInOneWeek addObject:arrayOfLessonsInDay];
            arrayOfLessonsInDay = [NSMutableArray new];
        }
        else {
            break;
        }
    }//for DAYS
        [exchange_Databases addObject:arrayOfAllLessonsInOneWeek];
        arrayOfAllLessonsInOneWeek = [NSMutableArray new];
        used = YES;
    }//for DATABASES
}

-(void)updateDatabaseAtIndex:(NSInteger)index {
    NSString *updateQuerySQL;
    sqlite3_stmt *update_query_statement;
    BOOL used = NO;
    int indexInArray;
    if (!mainDatabasesHaveBeenUpdated) {
        indexInArray = 0;
    }
    else {
        indexInArray = 2;
    }
    NSInteger indexOfDatabase = index;
    for (int j=0;j<2; j++) {
        if (used) {
            indexOfDatabase = 1;
            if (!mainDatabasesHaveBeenUpdated) {
                indexInArray = 1;
            }
            else {
                indexInArray = 3;
            }
        }
        for (int d=0;d<[days_titles count];d++) {
            for (int i=1;i<10;i++) {
                if (!mainDatabasesHaveBeenUpdated) {
                    updateQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASE%li SET %@=\"%@\" WHERE id=\"%d\"", (long)indexOfDatabase, [[days_titles objectAtIndex:d]uppercaseString], [[[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:d]objectAtIndex:i-1]
                                      , i];
                }
                else {
                    NSString *databaseName = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:0],
                    *first = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:2],
                    *second = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:3],
                    *third = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:4],
                    *fourth = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:5],
                    *fifth = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:6],
                    *sixth = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:7],
                    *seventh = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:8],
                    *eighth = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:9],
                    *lunch = [[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:10];
                    int lastrow = [[[exchange_Databases objectAtIndex:indexInArray]objectAtIndex:1]intValue];
                    updateQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASENAMES SET DATABASENAME=\"%@\", LASTROW=%i, FIRST=\"%@\", SECOND=\"%@\", THIRD=\"%@\", FOURTH=\"%@\", FIFTH=\"%@\", SIXTH=\"%@\", SEVENTH=\"%@\", EIGHTH=\"%@\", LUNCH=\"%@\" WHERE id=\"%li\"", databaseName,lastrow,first,second,third,fourth,fifth,sixth,seventh,eighth,lunch,(long)indexOfDatabase];
                    if (used) {
                        self.TitleFromDatabase = databaseName;
                        self.LastRowFromDatabase = lastrow;
                        self.first = first;
                        self.second = second;
                        self.third = third;
                        self.fourth = fourth;
                        self.fifth = fifth;
                        self.sixth = sixth;
                        self.seventh = seventh;
                        self.eighth = eighth;
                        self.lunch = lunch;
                    }
                }
                const char *update_query_stmt = [updateQuerySQL UTF8String];
                sqlite3_prepare_v2(timetable, update_query_stmt, -1, &update_query_statement, NULL);
                if (sqlite3_step(update_query_statement) == SQLITE_DONE) {}
                sqlite3_finalize(update_query_statement);
                if (mainDatabasesHaveBeenUpdated) {
                    break;
                }
            }
            if (mainDatabasesHaveBeenUpdated) {
                break;
            }
        }
        used = YES;
    }
}

- (IBAction)changeDay{
    Timetable *startingViewController;
    if ([days_switch selectedSegmentIndex]==0){
        startingViewController=[self viewControllerAtIndex:0];
    }
    else if([days_switch selectedSegmentIndex]==1){
        startingViewController=[self viewControllerAtIndex:1];
    }
    else if([days_switch selectedSegmentIndex]==2){
        startingViewController=[self viewControllerAtIndex:2];
    }
    else if([days_switch selectedSegmentIndex]==3){
        startingViewController=[self viewControllerAtIndex:3];
    }
    else if([days_switch selectedSegmentIndex]==4){
        startingViewController=[self viewControllerAtIndex:4];
    }
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (Timetable *)viewControllerAtIndex:(NSUInteger)index
{
    if (([days_titles count] == 0) || (index >= [days_titles count])) {
        return nil;
    }
    Timetable *timetable_table_view = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Timetable"];
    timetable_table_view.day = index;
    timetable_table_view.day_title =  [[self.days_titles objectAtIndex:index]capitalizedString];

    if (index<[lessons count]) {
        if ([[lessons objectAtIndex:index]count]!=0) {
            timetable_table_view.lessons = [lessons objectAtIndex:index];
            timetable_table_view.lessons_duration = lessons_duration;
        }
    }
    
    return timetable_table_view;
}

#pragma mark - Page View Controller Delegate

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        Timetable *current_day =[self.pageViewController.viewControllers lastObject];
        [days_switch setSelectedSegmentIndex:current_day.day];
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((Timetable*) viewController).day;
    if ((index == 0)||(index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((Timetable*) viewController).day;
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [days_titles count]) {
        return [self viewControllerAtIndex:0];
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [days_titles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)setTheSuperview:(NSString*)incomingSuperview {
    superView = incomingSuperview;
}
@end
