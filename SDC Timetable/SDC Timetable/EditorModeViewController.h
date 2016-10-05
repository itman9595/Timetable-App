//
//  EditorModeViewController.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/21/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CellEditorMode.h"
#import "EditorModeTableViewCell.h"
#import "EditorModeExtraOptions.h"
@interface EditorModeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property BOOL teachers_Are_Shown, groups_Are_Shown, table_Of_Targets_Is_Shown, chooseLesson, lessons_Are_Ready_To_Update;
@property (weak, nonatomic) IBOutlet UIScrollView *editorModeScrollView;
@property (weak, nonatomic) IBOutlet UINavigationBar *custom_Navigation_Bar;
@property (strong, nonatomic) IBOutlet UITableView *monday_Table_View, *tuesday_Table_View, *wednesday_Table_View,*thursday_Table_View,*friday_Table_View, *table_Of_Targets;
@property (strong, nonatomic) NSArray *days_titles;
@property (strong, nonatomic) NSMutableArray *lessons, *lessons_duration, *array_Of_Targets;
@property (strong, nonatomic) EditorModeTableViewCell *cellToUpdate;
@property (strong, nonatomic) NSMutableArray *selectedCells, *selectedCellsIndexPaths, *selectedCellsDays,*selectedCellsObjectIds, *indexesForParentObjectIds;
@property (strong, nonatomic) PFQuery *query, *chooseQuery1, *chooseQuery2, *queryToUpdate, *queryForTeachers;
@property (strong, nonatomic) CellEditorMode *cellEditorMode;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) UISegmentedControl *editorTools;
@property (strong, nonatomic) UIView *dimmed_View;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIBarButtonItem *saveButton, *cancelButton, *backButton;
@property (strong, nonatomic) NSString *targetName, *fullTargetName, *title_Target_Name, *previous_target_Name, *previous_full_Target_Name;
@property (strong, nonatomic) NSString *copied_Lesson_Name, *cellToUpdateObjectId, *cellToUpdateTableViewDay;
@property int currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes;
@property int lunchTimeIndex, lessonIndex, year;
@property (strong, nonatomic) NSArray *arrayOfLessonsDurations;
@property NSInteger cellToUpdateIndex;
- (IBAction)editorToolsClick:(id)sender;
@end
