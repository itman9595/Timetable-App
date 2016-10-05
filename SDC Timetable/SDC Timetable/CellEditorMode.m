//
//  CellEditorMode.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/22/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "CellEditorMode.h"
#import "EditorModeViewController.h"

@implementation CellEditorMode
@synthesize Lesson, Teacher;
@synthesize lesson_Picker, teacher_Picker;
@synthesize dimmed_View, activityIndicatorView;
@synthesize custom_Navigation_Bar;
@synthesize mainQuery, query, query1, queryForLessons, queryForTargets;
@synthesize arrayOfLessons, arrayOfTargets, arrayOfTargetClasses;
@synthesize active_Field;
@synthesize next_text_field, done, back;
@synthesize settings_Scroll_View;
@synthesize Target_Label, Lesson_Label;
@synthesize targetClassName;

-(void)viewWillDisappear:(BOOL)animated {
    [mainQuery cancel];
    [query cancel];
    [query1 cancel];
    [queryForLessons cancel];
    [queryForTargets cancel];
}

- (IBAction)go_Back_To_Editor_Mode {
    [self return_Back_To_Editor_Mode];
}

-(void)showAlert {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"It seems like that there is no Internet Connection or you have improperly set the name for the class of the teacher that is given in the list, or smth wrong occured on the server, please check it out" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

-(void)return_Back_To_Editor_Mode {
    EditorModeViewController *EditorMode = [self.storyboard instantiateViewControllerWithIdentifier:
                                            @"EditorModeViewController"];
    [self presentViewController:EditorMode animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [custom_Navigation_Bar.topItem setTitle:[self.defaults objectForKey:@"FullTargetName"]];
    back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(go_Back_To_Editor_Mode)];
    [back setTintColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
    [custom_Navigation_Bar.topItem setLeftBarButtonItem:back];
    if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Teacher"]) {
        [Target_Label setText:@"Group"];
    }
    NSString *fullLesson = [self.defaults objectForKey:@"FullLesson"];
    int commasCount = 0;
    int indexOfLastComma = 0;
    for (int i=0;i<[fullLesson length];i++) {
        if ([fullLesson characterAtIndex:i]==',') {
            commasCount++;
            if (commasCount == 1) {
                [Lesson setText:[fullLesson substringWithRange:NSMakeRange(0, i)]];
                indexOfLastComma = i+1;
            }
            else {
                [Teacher setText:[fullLesson substringWithRange:NSMakeRange(indexOfLastComma, i-indexOfLastComma)]];
                break;
            }
        }
        else if(commasCount==1&&[fullLesson length]-1==i) {
            [Teacher setText:[fullLesson substringWithRange:NSMakeRange(indexOfLastComma, i-indexOfLastComma+1)]];
            break;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [self create_Download_Signs];
    queryForLessons = [PFQuery queryWithClassName:@"Lessons"];
    [queryForLessons orderByAscending:@"updatedAt"];
    [queryForLessons findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
        if (!error) {
            arrayOfLessons = [NSMutableArray new];
            [self sort_array_Of_Groups:[NSMutableArray arrayWithArray:list]];
            if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Student"]) {
                [self makeQuery:@"Teachers"];
            }
            else {
                [self makeQuery:@"Groups"];
            }
        }
        else {
            [self remove_Download_Signs];
            [self showAlert];
        }
    }];
}

-(void)makeQuery:(NSString*)className {
    queryForTargets = [PFQuery queryWithClassName:className];
    if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Student"]) {
        [queryForTargets orderByAscending:@"updatedAt"];
    }
    [queryForTargets findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
        if (!error) {
            arrayOfTargets = [NSMutableArray new];
            arrayOfTargetClasses = [NSMutableArray new];
            [self sort_array_Of_Targets:[NSMutableArray arrayWithArray:list]];
            
            if ([arrayOfLessons count]!=0) {
                [Lesson setDelegate:self];
                lesson_Picker = [[UIPickerView alloc]init];
                [lesson_Picker setDelegate:self];
                [lesson_Picker setDataSource:self];
                [lesson_Picker showsSelectionIndicator];
                [Lesson setInputView:lesson_Picker];
            }
            else {
                [Lesson setUserInteractionEnabled:NO];
            }
            
            if ([arrayOfTargets count]!=0) {
                [Teacher setDelegate:self];
                teacher_Picker = [[UIPickerView alloc]init];
                [teacher_Picker setDelegate:self];
                [teacher_Picker setDataSource:self];
                [teacher_Picker showsSelectionIndicator];
                [Teacher setInputView:teacher_Picker];
                NSUInteger index = [arrayOfTargets indexOfObject:[Teacher text]];
                if (index != NSNotFound) {
                    targetClassName = [arrayOfTargetClasses objectAtIndex:index];
                }
            }
            else {
                [Teacher setUserInteractionEnabled:NO];
            }
            
            next_text_field = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(turn_to_next_text_field:)];
            done = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
            [custom_Navigation_Bar.topItem setRightBarButtonItem:done];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissChoice)];
            [self.view addGestureRecognizer:gesture];
            
            [self remove_Download_Signs];
        }
        else {
            [self remove_Download_Signs];
            [self showAlert];
        }
    }];
}

-(void)sort_array_Of_Groups:(NSMutableArray*)array {
    for (int i=0;i<[array count];i++) {
        NSString *group = [[array objectAtIndex:i]objectForKey:@"Lesson"];
        if (!group) {
            group = @"";
        }
        else {
            group = [[group componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]invertedSet]]componentsJoinedByString:@""];
            if (![[NSCharacterSet letterCharacterSet]isSupersetOfSet:
                  [NSCharacterSet characterSetWithCharactersInString:group]]) {
                group = @"";
            }
        }
        if(![group isEqualToString:@""]){
            [arrayOfLessons addObject:[[array objectAtIndex:i]objectForKey:@"Lesson"]];
        }
    }
    array = [NSMutableArray new];
}

-(void)sort_array_Of_Targets:(NSMutableArray*)array {
    for (int i=0;i<[array count];i++) {
        if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Teacher"]) {
            NSString *groupClassName = [[array objectAtIndex:i]objectForKey:@"Group"];
            if (!groupClassName) {
                groupClassName = @"";
            }
            else {
                groupClassName = [[groupClassName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]componentsJoinedByString:@""];
                NSString *changedGroupClassName = [[groupClassName componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]invertedSet]]componentsJoinedByString:@""];
                if (![[NSCharacterSet letterCharacterSet]isSupersetOfSet:
                      [NSCharacterSet characterSetWithCharactersInString:changedGroupClassName]]) {
                    groupClassName = @"";
                }
            }
            if(![groupClassName isEqualToString:@""]){
                NSString *className = [[array objectAtIndex:i]objectForKey:@"Group"];
                [arrayOfTargets addObject:className];
                [arrayOfTargetClasses addObject:[[className componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]componentsJoinedByString:@""]];
            }
        }
        else {
            NSString *teacherClassName = [[array objectAtIndex:i]objectForKey:@"ClassName"];
            NSString *teacherName = [[array objectAtIndex:i]objectForKey:@"Name"];
            NSString *teacherSurname = [[array objectAtIndex:i]objectForKey:@"Surname"];
            NSString *initialTeacherName = teacherName, *initialTeacherSurname = teacherSurname;
            NSString *fullName = @"";
            if (!teacherClassName) {
                teacherClassName = @"";
            }
            else {
                teacherClassName = [[teacherClassName componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]invertedSet]]componentsJoinedByString:@""];
                if (![[NSCharacterSet letterCharacterSet]isSupersetOfSet:
                      [NSCharacterSet characterSetWithCharactersInString:teacherClassName]]) {
                    teacherClassName = @"";
                }
            }
            if (!teacherName) {
                teacherName = @"";
            }
            else {
                
                teacherName = [[teacherName componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]invertedSet]]componentsJoinedByString:@""];
                if (![[NSCharacterSet letterCharacterSet]isSupersetOfSet:
                      [NSCharacterSet characterSetWithCharactersInString:teacherName]]) {
                    teacherName = @"";
                }
            }
            if (!teacherSurname) {
                teacherSurname = @"";
            }
            else {
                teacherSurname = [[teacherSurname componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]invertedSet]]componentsJoinedByString:@""];
                if (![[NSCharacterSet letterCharacterSet]isSupersetOfSet:
                      [NSCharacterSet characterSetWithCharactersInString:teacherSurname]]) {
                    teacherSurname = @"";
                }
            }
            
            if(![teacherClassName isEqualToString:@""]&&(![teacherName isEqualToString:@""]||![teacherSurname isEqualToString:@""])){
                if (![teacherName isEqualToString:@""]&&![teacherSurname isEqualToString:@""]) {
                    fullName = [NSString stringWithFormat:@"%@ %@",initialTeacherSurname,initialTeacherName];
                }
                else if (![teacherName isEqualToString:@""]) {
                    fullName = [NSString stringWithFormat:@"%@",initialTeacherName];
                }
                else if (![teacherSurname isEqualToString:@""]) {
                    fullName = [NSString stringWithFormat:@"%@",initialTeacherSurname];
                }
                [arrayOfTargets addObject:fullName];
                [arrayOfTargetClasses addObject:[[array objectAtIndex:i]objectForKey:@"ClassName"]];
            }
        }
    }
    array = [NSMutableArray new];
}

- (void)done:(id)sender{
    if (Lesson == active_Field) {
        [Lesson resignFirstResponder];
    }
    else if (Teacher == active_Field) {
        [Teacher resignFirstResponder];
    }
    [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:NO];
    if (!targetClassName) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"It seems like that you have improperly set the class name for the teacher that is given in the list, please check it out on the server" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
    }
    else {
        mainQuery = [PFQuery queryWithClassName:targetClassName];
        [mainQuery orderByAscending:@"SubjectNumber"];
        [mainQuery findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                query = [PFQuery queryWithClassName:targetClassName];
                PFObject *parentObject = [list objectAtIndex:[[self.defaults objectForKey:@"indexForParentObject"]integerValue]];
                NSString *parentObjectId = [parentObject objectId];
                [query getObjectInBackgroundWithId:parentObjectId block:^(PFObject *lesson_Full_Name_For_Parent_Class, NSError *error) {
                    if (!error) {
                        query1 = [PFQuery queryWithClassName:[self.defaults objectForKey:@"TargetName"]];
                        [query1 getObjectInBackgroundWithId:[self.defaults objectForKey:@"objectId"] block:^(PFObject *lesson_Full_Name, NSError *error) {
                            if (!error) {
                                ////
                                if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Student"]) {
                                    lesson_Full_Name[[self.defaults objectForKey:@"day"]] = [NSString stringWithFormat:@"%@,%@",
                                                                                             Lesson.text,Teacher.text];
                                    lesson_Full_Name_For_Parent_Class[[self.defaults objectForKey:@"day"]] = [NSString stringWithFormat:@"%@,%@",[self.defaults objectForKey:@"FullTargetName"],Lesson.text];
                                }
                                else {
                                    lesson_Full_Name[[self.defaults objectForKey:@"day"]] = [NSString stringWithFormat:@"%@,%@",Teacher.text,Lesson.text];
                                    lesson_Full_Name_For_Parent_Class[[self.defaults objectForKey:@"day"]] = [NSString stringWithFormat:@"%@,%@",Lesson.text,[self.defaults objectForKey:@"FullTargetName"]];
                                }
                                [lesson_Full_Name saveInBackground];
                                [lesson_Full_Name_For_Parent_Class saveInBackground];
                                [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
                            }
                            else {
                                [self showAlert];
                                [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
                            }
                        }];
                    }
                    else {
                        [self showAlert];
                        [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
                    }
                }];
            }
            else {
                [self showAlert];
                [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
            }
        }];
    }
    
}

- (void)turn_to_next_text_field:(id)sender{
    if (Lesson == active_Field) {
        [Teacher becomeFirstResponder];
    }
    else if (Teacher == active_Field) {
        [Lesson becomeFirstResponder];
    }
}

-(void)viewDidLayoutSubviews {
    [settings_Scroll_View setContentSize:CGSizeMake(self.view.frame.size.height,self.view.frame.size.width)];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    active_Field = textField;

    if (Lesson == textField) {
        if (Teacher.userInteractionEnabled) {
            [next_text_field setTitle:@"Next"];
            [custom_Navigation_Bar.topItem setLeftBarButtonItem:next_text_field];
        }
    }
    else if (Teacher == textField) {
        if (Lesson.userInteractionEnabled) {
            [next_text_field setTitle:@"Again"];
            [custom_Navigation_Bar.topItem setLeftBarButtonItem:next_text_field];
        }
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    active_Field = nil;
    if (custom_Navigation_Bar.topItem.leftBarButtonItem != back) {
        [custom_Navigation_Bar.topItem setLeftBarButtonItem:back];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == lesson_Picker) {
        return [arrayOfLessons objectAtIndex:row];
    }
    else if (pickerView == teacher_Picker) {
        return [arrayOfTargets objectAtIndex:row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (lesson_Picker == pickerView) {
        [Lesson setText:[arrayOfLessons objectAtIndex:row]];
    }
    else if (teacher_Picker == pickerView) {
        targetClassName = [arrayOfTargetClasses objectAtIndex:row];
        [Teacher setText:[arrayOfTargets objectAtIndex:row]];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == lesson_Picker) {
        return [arrayOfLessons count];
    }
    else if (pickerView == teacher_Picker) {
        return [arrayOfTargets count];
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void)create_Download_Signs {
    dimmed_View = [[UIView alloc]init];
    [dimmed_View setBackgroundColor:[UIColor blackColor]];
    [dimmed_View setAlpha:0.5];
    [dimmed_View.layer setMasksToBounds:YES];
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] <= 7) {
        [dimmed_View setFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20))];
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [dimmed_View setFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)];
        }
        else {
            [dimmed_View setFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))];
        }
    }
    activityIndicatorView.center = CGPointMake(dimmed_View.frame.size.width / 2, (dimmed_View.frame.size.height / 2)+activityIndicatorView.frame.size.height/2);
    [self.view addSubview:dimmed_View];
    [self.view addSubview:activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

-(void)remove_Download_Signs {
    [activityIndicatorView removeFromSuperview];
    [dimmed_View removeFromSuperview];
}

-(void)dismissChoice {
    [Lesson resignFirstResponder];
    [Teacher resignFirstResponder];
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
    return UIInterfaceOrientationMaskLandscape;
}

@end
