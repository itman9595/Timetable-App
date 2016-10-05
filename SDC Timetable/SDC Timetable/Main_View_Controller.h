//
//  Main_View_Controller.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/22/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface Main_View_Controller : UIViewController {
    BOOL warning_view_is_dismissed;
}
@property (strong, nonatomic) UIView *warningView;
@property (strong, nonatomic) UIButton *last_clicked_button;
@property (weak, nonatomic) IBOutlet UIButton *start_button, *student_timetable_button, *teachers_timetable_button, *settings_button, *search_button, *about_us_button, *unity_Club_Button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *base_top_space, *centerX, *teachers_timetable_button_trailing_space,*teachers_timetable_button_bottom_space, *search_button_top_space,*teachers_Timetable_Button_Width,*teachers_Timetable_Button_Height,*settings_Button_Width,*settings_Button_Height,*search_Button_Width,*search_Button_Height,*about_Us_Button_Width,*about_Us_Button_Height;
@property (strong,nonatomic)NSMutableArray *arrayOfConstraintsOfPortraitMode, *arrayOfConstraintsOfLandscapeMode;
@property BOOL device_Turned;
- (IBAction)go_To_Students_timetable:(id)sender;
- (IBAction)go_to_Teachers_timetable:(id)sender;
- (IBAction)go_To_Students_Settings:(id)sender;
- (IBAction)go_To_Search:(id)sender;
- (IBAction)go_to_Unity_Club:(id)sender;
- (IBAction)show_menu_buttons:(id)sender;
@end
