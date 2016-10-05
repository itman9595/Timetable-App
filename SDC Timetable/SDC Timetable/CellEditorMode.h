//
//  CellEditorMode.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/22/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface CellEditorMode : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet UITextField *Lesson, *Teacher;
@property (weak, nonatomic) UITextField *active_Field;
@property (strong, nonatomic) UIPickerView *lesson_Picker, *teacher_Picker;
@property (weak, nonatomic) IBOutlet UILabel *Target_Label, *Lesson_Label;
@property (strong, nonatomic) UIView *dimmed_View;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UINavigationBar *custom_Navigation_Bar;
@property (strong, nonatomic) PFQuery *mainQuery, *query, *query1, *queryForLessons, *queryForTargets;
@property (strong, nonatomic) NSMutableArray *arrayOfLessons, *arrayOfTargets, *arrayOfTargetClasses;
@property (strong, nonatomic) UIBarButtonItem *next_text_field, *done, *back;
@property (weak, nonatomic) IBOutlet UIScrollView *settings_Scroll_View;
@property (strong, nonatomic) NSString *targetClassName;
- (IBAction)go_Back_To_Editor_Mode;
@end
