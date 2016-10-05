//
//  Settings.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/14/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "updateDatabase.h"
#import "AppDelegate.h"
#import <sqlite3.h>
@interface Settings : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UIView *dimmed_View;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIScrollView *settings_Scroll_View;
@property (weak, nonatomic) IBOutlet UILabel *year_Label, *speciality_Label, *course_language_Label;
@property (weak, nonatomic) IBOutlet UITextField *year_Text_Field, *speciality_Text_Field, *course_language_Text_Field;
@property (weak, nonatomic) UITextField *active_Field;
@property (strong, nonatomic) UIPickerView *year_Picker, *speciality_Picker, *course_language_Picker;
@property (strong, nonatomic) NSArray *years, *specialities, *course_languages;
@property (strong, nonatomic) NSSet *years_set, *specialities_set, *course_languages_set;
@property (strong, nonatomic) UIBarButtonItem *next_text_field, *done;
@property (strong, nonatomic) updateDatabase *updateIt;
@property (strong, nonatomic) AppDelegate *app_Delegate;
@property (weak, nonatomic) IBOutlet UISwitch *notifications_Controller;
@property (weak, nonatomic) IBOutlet UILabel *notification_Label;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *timetable;
- (IBAction)TurnNotificationsForLessons:(id)sender;
- (void)done:(id)sender;
- (void)turn_to_next_text_field:(id)sender;
@end
