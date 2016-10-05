//
//  EditorModeExtraOptions.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/26/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface EditorModeExtraOptions : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property BOOL noStudents, studentEditorModeIsShown, transferAllStudentsToAnotherGroupIsShown, STUDENT_MODE, typeDuplication, addButtonClicked, deleteButtonClicked, chooseStudentsToTranslate, multipleChoiceOfStudentsBegin;
@property (weak, nonatomic) IBOutlet UIButton *duplicate_Button, *deleteButton;
- (IBAction)EditStudentsList:(id)sender;
- (IBAction)EditTeachersList:(id)sender;
- (IBAction)EditLessonsList:(id)sender;
- (IBAction)EditLessonsDuration:(id)sender;
- (IBAction)Duplicate:(id)sender;
- (IBAction)Delete:(id)sender;
@property NSInteger objectIndex;
@property (strong, nonatomic) NSString *prohibitedSymbolsRegEx;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) PFQuery *main_Query,*queryToGetClassForDuplication;
@property (strong, nonatomic) NSArray *days_titles;
@property (strong, nonatomic) UITableView *tableOfTargets;
@property (strong, nonatomic) UIView *dimmed_View;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UINavigationBar *custom_Navigation_Bar;
@property (strong, nonatomic) NSString *formattedTitle, *nameOfReflectedClass,*parallelGroup, *tableOfTargetsTitleName;
@property (strong, nonatomic) NSMutableArray *arrayOfAllGroups, *array_Of_Targets, *array_Of_Groups,
*array_Of_Students_To_Transform;
@property (strong, nonatomic) PFQuery *chooseQuery1, *chooseQuery2;
@property (strong, nonatomic) UIBarButtonItem *editOptions, *backButton, *backToEditing,*backButtonOfCalledViews, *saveButton, *dismissDeleteButton, *deleteTargetsButton, *doneButton, *backToStudents, *doneChoice, *cancelChoice;
@property (strong, nonatomic) UISegmentedControl *editSegment;
@property (strong, nonatomic) UIAlertView *warningAlert;
@property (strong, nonatomic) UITableView *choiceFromStudentGroup;
@property (strong, nonatomic) UIScrollView *editor_Mode_For_Students, *editor_Mode_For_Teachers, *editor_Mode_For_Lessons, *editor_Mode_For_Lessons_Duration;
@property BOOL reviewApplaused;
//editor_Mode_For_Teachers
@property (strong, nonatomic) UILabel *teacherNameLabel, *teacherSurnameLabel, *teacherEmailLabel, *teacherClassNameLabel, *fixedClassNameLabel;
@property (strong, nonatomic) UITextField *teacherNameTextField, *teacherSurnameTextField,
*teacherEmailTextField;
@property (strong, nonatomic) NSString *teacherName, *teacherSurname, *teacherFullName;
//editor_Mode_For_Lessons
@property (strong, nonatomic) UILabel *lessonNameLabel;
@property (strong, nonatomic) UITextField *lessonNameTextField;
//editor_Mode_For_Lessons_Duration
@property (strong, nonatomic) UILabel *firstLessonDurationLabel, *secondLessonDurationLabel, *thirdLessonDurationLabel, *fourthLessonDurationLabel, *fifthLessonDurationLabel, *sixthLessonDurationLabel, *seventhLessonDurationLabel, *eigththLessonDurationLabel, *lunchTimeDurationLabel;
@property (strong, nonatomic) UITextField *firstLessonDurationTextField, *secondLessonDurationTextField, *thirdLessonDurationTextField, *fourthLessonDurationTextField, *fifthLessonDurationTextField, *sixthLessonDurationTextField, *seventhLessonDurationTextField, *eighthLessonDurationTextField, *lunchTimeDurationTextField;
@property (strong, nonatomic) UITextField *ActiveField;
@property (strong, nonatomic) NSString *lessonBeginningHour, *lessonBeginningMinute, *lessonFinishingHour, *lessonFinishingMinute;
@property (strong, nonatomic) UIPickerView *lesson_Duration_Picker;
@property (strong, nonatomic) NSMutableArray *hours, *minutes;
@property int currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes,
previousBeginningHour, previousBeginningMinutes, previousFinishingHour, previousFinishingMinutes;
//editor_Mode_For_Students
@property int studentGroupIndex, changingStudentGroupIndex;
@property (strong, nonatomic) UILabel *studentNameLabel, *studentSurnameLabel, *studentGroupLabel;
@property (strong, nonatomic) UITextField *studentNameTextField, *studentSurnameTextField, *studentGroupTextField, *hiddenTextFieldForStudentsGroup;
@property (strong, nonatomic) UIPickerView *student_Group_Picker;
@end
