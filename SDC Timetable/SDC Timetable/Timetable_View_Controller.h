//
//  Main_View_Controller.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/12/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "AppDelegate.h"
@interface Timetable_View_Controller : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate> {
    BOOL teacher_Settings_Is_Presented, updateHasBeenCompleted, mainDatabasesHaveBeenUpdated, constraintsShouldBeAdded;
}
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UITableView *savedDatabaseTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *extraToolButtons;
@property (strong, nonatomic) NSArray *days_titles;
@property (strong, nonatomic) NSMutableArray *lessons, *lessons_per_day, *lessons_duration, *formatted_lessons_duration, *saved_Databases, *exchange_Databases;
@property (strong, nonatomic) IBOutlet UISegmentedControl *days_switch;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *first, *second, *third, *fourth, *fifth, *sixth, *seventh, *eighth, *lunch;
@property (nonatomic) sqlite3 *timetable;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDateFormatter *postedDateFormat;
@property BOOL savedDatabaseTableViewOpened;
@property (weak, nonatomic) NSLayoutConstraint *savedDatabaseTableViewTopConstraint, *savedDatabaseTableViewLeading, *savedDatabaseTableViewTrailing, *savedDatabaseTableViewWidth;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (strong, nonatomic) NSArray *specialities;
@property (strong, nonatomic) UITableViewController *teachers_Settings_Table_View_Controller;
@property (strong, nonatomic) AppDelegate *app_Delegate;
@property (strong, nonatomic) NSString *superView, *TitleFromDatabase;
@property int currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes,
LastRowFromDatabase, hour, minute, indexOfLesson, previousIndexOfLesson;
@property BOOL lessonIsGrayed;
- (IBAction)changeDay;
- (IBAction)extraButtonsClick:(id)sender;
-(void)setTheSuperview:(NSString*)incomingSuperview;
@end
