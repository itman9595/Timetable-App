//
//  EditorModeExtraOptions.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/26/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "EditorModeExtraOptions.h"
#import "EditorModeViewController.h"

@implementation EditorModeExtraOptions
@synthesize prohibitedSymbolsRegEx;
@synthesize objectIndex;
@synthesize addButtonClicked, deleteButtonClicked;
@synthesize reviewApplaused;
@synthesize days_titles;
@synthesize custom_Navigation_Bar;
@synthesize dimmed_View, activityIndicatorView;
@synthesize formattedTitle, nameOfReflectedClass,parallelGroup, tableOfTargetsTitleName;
@synthesize editOptions;
@synthesize backButton, backButtonOfCalledViews, backToEditing, saveButton, dismissDeleteButton, deleteTargetsButton;
@synthesize tableOfTargets;
@synthesize arrayOfAllGroups, array_Of_Targets, array_Of_Groups, array_Of_Students_To_Transform;
@synthesize choiceFromStudentGroup;
@synthesize editor_Mode_For_Students, editor_Mode_For_Teachers, editor_Mode_For_Lessons, editor_Mode_For_Lessons_Duration;
//editor_Mode_For_Teachers
@synthesize teacherNameLabel, teacherSurnameLabel, teacherEmailLabel, teacherClassNameLabel,
fixedClassNameLabel;
@synthesize teacherNameTextField, teacherSurnameTextField, teacherEmailTextField;
@synthesize teacherName, teacherSurname, teacherFullName;
//editor_Mode_For_Lessons
@synthesize lessonNameLabel;
@synthesize lessonNameTextField;
//editor_Mode_For_Lessons_Duration
@synthesize firstLessonDurationLabel,secondLessonDurationLabel,thirdLessonDurationLabel,fourthLessonDurationLabel,fifthLessonDurationLabel,sixthLessonDurationLabel,seventhLessonDurationLabel,eigththLessonDurationLabel,lunchTimeDurationLabel;
@synthesize firstLessonDurationTextField,secondLessonDurationTextField,thirdLessonDurationTextField,fourthLessonDurationTextField,fifthLessonDurationTextField,sixthLessonDurationTextField,seventhLessonDurationTextField,eighthLessonDurationTextField,lunchTimeDurationTextField;
@synthesize ActiveField;
@synthesize lessonBeginningHour, lessonBeginningMinute, lessonFinishingHour, lessonFinishingMinute;
@synthesize lesson_Duration_Picker;
@synthesize hours, minutes;
@synthesize currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes,
previousBeginningHour, previousBeginningMinutes, previousFinishingHour, previousFinishingMinutes;
//editor_Mode_For_Students
@synthesize studentGroupIndex;
@synthesize studentNameLabel, studentSurnameLabel, studentGroupLabel;
@synthesize studentNameTextField, studentSurnameTextField, studentGroupTextField;
@synthesize student_Group_Picker;
@synthesize hiddenTextFieldForStudentsGroup;

-(void)go_Back_To_EditorModeViewController {
    EditorModeViewController *editorModeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditorModeViewController"];
    [self presentViewController:editorModeViewController animated:YES completion:nil];
    [self create_Download_Signs];
}

-(void)groups_Class_Doesnt_Exist {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"It seems like that the class \"Groups\" doesn't exist or there is no Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

-(void)viewDidAppear:(BOOL)animated {
    self.main_Query = [PFQuery queryWithClassName:@"Groups"];
    [self.main_Query orderByAscending:@"createdAt"];
    [self.main_Query findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
        if (!error) {
            if ([list count]!=0) {
                arrayOfAllGroups = [NSMutableArray new];
                for (int i=0;i<[list count];i++) {
                    [arrayOfAllGroups addObject:[[list objectAtIndex:i]objectForKey:@"Group"]];
                }
                [self remove_Download_Signs];
            }
            else {
                [self groups_Class_Doesnt_Exist];
                [self go_Back_To_EditorModeViewController];
            }
        }
        else {
            [self groups_Class_Doesnt_Exist];
            [self go_Back_To_EditorModeViewController];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self remove_Download_Signs];
    [self.main_Query cancel];
    [self.queryToGetClassForDuplication cancel];
    [self.chooseQuery1 cancel];
    [self.chooseQuery2 cancel];
}

-(NSString*)checkCharacter:(NSString*)string {
    reviewApplaused = YES;
    if ([string isEqualToString:@"а"]) {
        string = @"a";
    }
    else if ([string isEqualToString:@"б"]) {
        string = @"b";
    }
    else if ([string isEqualToString:@"в"]) {
        string = @"v";
    }
    else if ([string isEqualToString:@"г"]) {
        string = @"g";
    }
    else if ([string isEqualToString:@"д"]) {
        string = @"d";
    }
    else if ([string isEqualToString:@"е"]||[string isEqualToString:@"э"]) {
        string = @"e";
    }
    else if ([string isEqualToString:@"ж"]) {
        string = @"zh";
    }
    else if ([string isEqualToString:@"з"]) {
        string = @"z";
    }
    else if ([string isEqualToString:@"и"]) {
        string = @"i";
    }
    else if ([string isEqualToString:@"й"]||[string isEqualToString:@"ы"]) {
        string = @"y";
    }
    else if ([string isEqualToString:@"к"]) {
        string = @"k";
    }
    else if ([string isEqualToString:@"л"]) {
        string = @"l";
    }
    else if ([string isEqualToString:@"м"]) {
        string = @"m";
    }
    else if ([string isEqualToString:@"н"]) {
        string = @"n";
    }
    else if ([string isEqualToString:@"о"]) {
        string = @"o";
    }
    else if ([string isEqualToString:@"п"]) {
        string = @"p";
    }
    else if ([string isEqualToString:@"р"]) {
        string = @"r";
    }
    else if ([string isEqualToString:@"с"]) {
        string = @"s";
    }
    else if ([string isEqualToString:@"т"]) {
        string = @"t";
    }
    else if ([string isEqualToString:@"у"]) {
        string = @"u";
    }
    else if ([string isEqualToString:@"ф"]) {
        string = @"f";
    }
    else if ([string isEqualToString:@"х"]) {
        string = @"h";
    }
    else if ([string isEqualToString:@"ц"]) {
        string = @"c";
    }
    else if ([string isEqualToString:@"ч"]) {
        string = @"ch";
    }
    else if ([string isEqualToString:@"ш"]||[string isEqualToString:@"щ"]) {
        string = @"sh";
    }
    else if ([string isEqualToString:@"ю"]) {
        string = @"yu";
    }
    else if ([string isEqualToString:@"я"]) {
        string = @"ya";
    }
    else if ([string isEqualToString:@"ё"]) {
        string = @"yo";
    }
    else if ([string isEqualToString:@"ъ"]||[string isEqualToString:@"ь"]||[string isEqualToString:@"-"]||[string isEqualToString:@" "]) {
        string = @"";
    }
    else {
        reviewApplaused = NO;
        string = @"";
    }
    return string;
}

-(void)checkTextField:(UITextField*)textField {
    for (int i=0;i<[[textField text]length];i++) {
        if (i>0) {
            if (([[[textField text]substringWithRange:NSMakeRange(i-1, 1)]isEqualToString:@"-"]&&[[[textField text]substringWithRange:NSMakeRange(i, 1)]isEqualToString:@"-"])||
                ([[[textField text]substringWithRange:NSMakeRange(i-1, 1)]isEqualToString:@" "]&&[[[textField text]substringWithRange:NSMakeRange(i, 1)]isEqualToString:@" "])) {
                reviewApplaused = NO;
                break;
            }
        }
        if (reviewApplaused) {
            if (textField == teacherNameTextField) {
                teacherName=[teacherName stringByAppendingString:[self checkCharacter:[[[teacherNameTextField text]lowercaseString]substringWithRange:NSMakeRange(i, 1)]]];
            }
            else if (textField == teacherSurnameTextField) {
                teacherSurname=[teacherSurname stringByAppendingString:[self checkCharacter:[[[teacherSurnameTextField text]lowercaseString]substringWithRange:NSMakeRange(i, 1)]]];
            }
            else if (textField == studentNameTextField) {
                teacherName=[teacherName stringByAppendingString:[self checkCharacter:[[[studentNameTextField text]lowercaseString]substringWithRange:NSMakeRange(i, 1)]]];
            }
            else if (textField == studentSurnameTextField) {
                teacherSurname=[teacherSurname stringByAppendingString:[self checkCharacter:[[[studentSurnameTextField text]lowercaseString]substringWithRange:NSMakeRange(i, 1)]]];
            }
        }
        else {
            break;
        }
    }
    if (!reviewApplaused) {
        if (textField == teacherNameTextField) {
            [teacherNameTextField setBackgroundColor:[UIColor redColor]];
        }
        else if (textField == teacherSurnameTextField) {
            [teacherSurnameTextField setBackgroundColor:[UIColor redColor]];
        }
        else if (textField == studentNameTextField) {
            [studentNameTextField setBackgroundColor:[UIColor redColor]];
        }
        else if (textField == studentSurnameTextField) {
            [studentSurnameTextField setBackgroundColor:[UIColor redColor]];
        }
    }
    else {
        if (textField == teacherNameTextField) {
            [teacherNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
        else if (textField == teacherSurnameTextField) {
            [teacherSurnameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
        else if (textField == studentNameTextField) {
            [studentNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
        else if (textField == studentSurnameTextField) {
            [studentSurnameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
    }
}

-(void)checkDurationsTextField:(UITextField*)textField {
    if ([[textField text]isEqualToString:@""]) {
        [textField setBackgroundColor:[UIColor redColor]];
        reviewApplaused = NO;
    }
    else {
        int countOfColons = 0;
        if ([[textField text]characterAtIndex:[[textField text]length]-1]!=':') {
            for (int i=0;i<[[textField text]length];i++) {
                if ([[textField text]characterAtIndex:i]==':') {
                    if (i==0) {
                        break;
                    }
                    else {
                        if ((![[[textField text]substringWithRange:NSMakeRange(i+1, 1)]isEqualToString:@" "])||(countOfColons==1&&![[[textField text]substringWithRange:NSMakeRange(i-1, 1)]isEqualToString:@" "])) {
                            countOfColons++;
                        }
                    }
                }
            }
        }
        if (countOfColons!=2) {
            [textField setBackgroundColor:[UIColor redColor]];
            reviewApplaused = NO;
        }
        else {
            [self checkSequence:textField compareWithAnotherTextField:nil];
            if ((currentBeginningHour>currentFinishingHour)||(currentFinishingHour==currentBeginningHour&&currentBeginningMinutes>currentFinishingMinutes)||(currentFinishingHour==currentBeginningHour&&currentFinishingMinutes==currentBeginningMinutes)) {
                [textField setBackgroundColor:[UIColor redColor]];
                reviewApplaused = NO;
            }
            else {
                [textField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            }
        }
    }
}

-(void)checkSequence:(UITextField*)textField compareWithAnotherTextField:(UITextField*)anotherTextField {
    int counter = 0;
    int lastDecimalIndex = 0;
    for (int i=0;i<[[textField text]length];i++) {
        if (i==[[textField text]length]-1) {
            currentFinishingMinutes = [[[textField text]substringWithRange:NSMakeRange(lastDecimalIndex, [[textField text]length]-lastDecimalIndex)]intValue];
        }
        else if (![[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[textField text]characterAtIndex:i]]) {
            if (counter==1) {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[textField text]characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[textField text]characterAtIndex:i-1]]) {
                    currentBeginningMinutes = [[[textField text]substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]intValue];
                    lastDecimalIndex = i+1;
                    counter++;
                }
            }
            else if (counter==2) {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[textField text]characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[textField text]characterAtIndex:i-1]]) {
                    currentFinishingHour = [[[textField text]substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]intValue];
                    lastDecimalIndex = i+1;
                }
            }
            else {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[textField text]characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[textField text]characterAtIndex:i-1]]) {
                    currentBeginningHour = [[[textField text]substringWithRange:NSMakeRange(0, i)]intValue];
                    lastDecimalIndex = i+1;
                    counter++;
                }
            }
        }
    }
    if (anotherTextField) {
        counter = 0;
        lastDecimalIndex = 0;
        for (int i=0;i<[[anotherTextField text]length];i++) {
            if (i==[[anotherTextField text]length]-1) {
                previousFinishingMinutes = [[[anotherTextField text]substringWithRange:NSMakeRange(lastDecimalIndex, [[anotherTextField text]length]-lastDecimalIndex)]intValue];
            }
            else if (![[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[anotherTextField text]characterAtIndex:i]]) {
                if (counter==1) {
                    if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[anotherTextField text]characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[anotherTextField text]characterAtIndex:i-1]]) {
                        previousBeginningMinutes = [[[anotherTextField text]substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]intValue];
                        lastDecimalIndex = i+1;
                        counter++;
                    }
                }
                else if (counter==2) {
                    if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[anotherTextField text]characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[anotherTextField text]characterAtIndex:i-1]]) {
                        previousFinishingHour = [[[anotherTextField text]substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]intValue];
                        lastDecimalIndex = i+1;
                    }
                }
                else {
                    if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[anotherTextField text]characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[[anotherTextField text]characterAtIndex:i-1]]) {
                        previousBeginningHour = [[[anotherTextField text]substringWithRange:NSMakeRange(0, i)]intValue];
                        lastDecimalIndex = i+1;
                        counter++;
                    }
                }
            }
        }
        if ((currentBeginningHour>previousFinishingHour)||(currentFinishingHour>previousFinishingHour)||(previousFinishingHour==currentBeginningHour&&currentBeginningMinutes>previousFinishingMinutes)
            ||(previousFinishingHour==currentBeginningHour&&currentFinishingMinutes>previousFinishingMinutes)) {
            [textField setBackgroundColor:[UIColor redColor]];
            reviewApplaused = NO;
        }
        else {
            [textField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
    }
}

-(NSString*)formatLessonDuration:(NSString*)text {
    int counter = 0;
    int lastDecimalIndex = 0;
    for (int i=0;i<[text length];i++) {
        if (i==[text length]-1) {
            currentFinishingMinutes = [[text substringWithRange:NSMakeRange(lastDecimalIndex, [text length]-lastDecimalIndex)]intValue];
        }
        else if (![[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i]]) {
            if (counter==1) {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i-1]]) {
                    currentBeginningMinutes = [[text substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]intValue];
                    lastDecimalIndex = i+1;
                    counter++;
                }
            }
            else if (counter==2) {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i-1]]) {
                    currentFinishingHour = [[text substringWithRange:NSMakeRange(lastDecimalIndex, i-lastDecimalIndex)]intValue];
                    lastDecimalIndex = i+1;
                }
            }
            else {
                if ([[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i+1]]&&[[NSCharacterSet decimalDigitCharacterSet]characterIsMember:[text characterAtIndex:i-1]]) {
                    currentBeginningHour = [[text substringWithRange:NSMakeRange(0, i)]intValue];
                    lastDecimalIndex = i+1;
                    counter++;
                }
            }
        }
    }
    NSMutableString *beginningHour = [NSMutableString stringWithFormat:@"%i",currentBeginningHour], *beginningMinutes = [NSMutableString stringWithFormat:@"%i",currentBeginningMinutes], *finishingHour = [NSMutableString stringWithFormat:@"%i",currentFinishingHour], *finishingMinutes = [NSMutableString stringWithFormat:@"%i",currentFinishingMinutes];
    if (currentBeginningHour<10) {
        [beginningHour insertString:@"0" atIndex:0];
    }
    if (currentBeginningMinutes<10) {
        [beginningMinutes insertString:@"0" atIndex:0];
    }
    if (currentFinishingHour<10) {
        [finishingHour insertString:@"0" atIndex:0];
    }
    if (currentFinishingMinutes<10) {
        [finishingMinutes insertString:@"0" atIndex:0];
    }
    text = [NSString stringWithFormat:@"%@:%@ %@:%@",beginningHour,beginningMinutes,finishingHour,finishingMinutes];
    return text;
}

-(void)Save {
    [custom_Navigation_Bar setUserInteractionEnabled:NO];
    reviewApplaused = YES;
    PFObject *updateObject; NSString *objectId;
    if ([tableOfTargetsTitleName isEqualToString:@"Teachers"]) {
        teacherName = @"";teacherSurname = @"";
        if (![teacherNameTextField.text isEqualToString:@""]) {
            [self checkTextField:teacherNameTextField];
        }
        if (![teacherSurnameTextField.text isEqualToString:@""]) {
            [self checkTextField:teacherSurnameTextField];
        }
        
        if ([teacherNameTextField.text isEqualToString:@""]&&[teacherSurnameTextField.text isEqualToString:@""]) {
            [teacherNameTextField setBackgroundColor:[UIColor redColor]];
            reviewApplaused = NO;
        }
        else {
            [teacherNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
        
        if (![teacherEmailTextField.text isEqualToString:@""]) {
            NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
            if (![emailTest evaluateWithObject:teacherEmailTextField.text]){
                [teacherEmailTextField setBackgroundColor:[UIColor redColor]];
                reviewApplaused = NO;
            }
            else {
                [teacherEmailTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            }
        }
        if (reviewApplaused) {
            if (!addButtonClicked) {
                updateObject = [array_Of_Targets objectAtIndex:objectIndex];
                objectId = [updateObject objectId];
                updateObject = [PFObject objectWithoutDataWithClassName:tableOfTargetsTitleName objectId:objectId];
                [updateObject setObject:[[teacherNameTextField text]capitalizedString] forKey:@"Name"];
                [updateObject setObject:[[teacherSurnameTextField text]capitalizedString] forKey:@"Surname"];
                [updateObject setObject:[[teacherEmailTextField text]lowercaseString] forKey:@"Email"];
                [updateObject save];
                [custom_Navigation_Bar setUserInteractionEnabled:YES];
            }
            else {
                [fixedClassNameLabel setText:[NSString stringWithFormat:@"%@%@",[teacherSurname capitalizedString],[teacherName capitalizedString]]];
                for (int i=0;i<9;i++) {
                    updateObject = [PFObject objectWithClassName:[fixedClassNameLabel text]];
                    updateObject[@"SubjectNumber"] = [NSString stringWithFormat:@"%i",i+1];
                    for (NSString *day in days_titles) {
                        updateObject[day] = @"";
                    }
                    [updateObject saveInBackground];
                }
                updateObject = [PFObject objectWithClassName:tableOfTargetsTitleName];
                updateObject[@"Name"] = [[teacherNameTextField text]capitalizedString];
                updateObject[@"Surname"] = [[teacherSurnameTextField text]capitalizedString];
                updateObject[@"Email"] = [[teacherEmailTextField text]lowercaseString];
                updateObject[@"ClassName"] = [fixedClassNameLabel text];
                [updateObject saveInBackground];
                [custom_Navigation_Bar setUserInteractionEnabled:YES];
            }
        }
    }
    else if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
        if (!self.transferAllStudentsToAnotherGroupIsShown) {
            teacherName = @"";teacherSurname = @"";
            if (![studentNameTextField.text isEqualToString:@""]) {
                [self checkTextField:studentNameTextField];
            }
            if (![studentSurnameTextField.text isEqualToString:@""]) {
                [self checkTextField:studentSurnameTextField];
            }
            
            if ([studentNameTextField.text isEqualToString:@""]&&[studentSurnameTextField.text isEqualToString:@""]) {
                [studentNameTextField setBackgroundColor:[UIColor redColor]];
                reviewApplaused = NO;
            }
            else {
                [studentNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            }
            
            if (reviewApplaused) {
                if (!addButtonClicked) {
                    updateObject = [[array_Of_Targets objectAtIndex:studentGroupIndex] objectAtIndex:objectIndex];
                    objectId = [updateObject objectId];
                    updateObject = [PFObject objectWithoutDataWithClassName:tableOfTargetsTitleName objectId:objectId];
                    [updateObject setObject:[[studentNameTextField text]capitalizedString] forKey:@"Name"];
                    [updateObject setObject:[[studentSurnameTextField text]capitalizedString] forKey:@"Surname"];
                    [updateObject setObject:[studentGroupTextField text] forKey:@"Group"];
                    [updateObject save];
                    [custom_Navigation_Bar setUserInteractionEnabled:YES];
                }
                else {
                    updateObject = [PFObject objectWithClassName:tableOfTargetsTitleName];
                    updateObject[@"Name"] = [[studentNameTextField text]capitalizedString];
                    updateObject[@"Surname"] = [[studentSurnameTextField text]capitalizedString];
                    updateObject[@"Group"] = [studentGroupTextField text];
                    [updateObject saveInBackground];
                    [custom_Navigation_Bar setUserInteractionEnabled:YES];
                }
            }
        }
        else {
            for (int i=0;i<[array_Of_Students_To_Transform count]; i++) {
                updateObject = [array_Of_Students_To_Transform objectAtIndex:i];
                objectId = [updateObject objectId];
                updateObject = [PFObject objectWithoutDataWithClassName:tableOfTargetsTitleName objectId:objectId];
                [updateObject setObject:[self tableView:choiceFromStudentGroup titleForHeaderInSection:0] forKey:@"Group"];
                [updateObject save];
            }
            [custom_Navigation_Bar setUserInteractionEnabled:YES];
        }
    }
    else if ([tableOfTargetsTitleName isEqualToString:@"Lessons"]) {
        if ([[lessonNameTextField text]length]>1) {
            for (int i=0;i<[[lessonNameTextField text]length];i++) {
                for (int j=0;j<[prohibitedSymbolsRegEx length];j++) {
                    if ([[prohibitedSymbolsRegEx substringWithRange:NSMakeRange(j,1)]isEqualToString:[[lessonNameTextField text] substringWithRange:NSMakeRange(i,1)]]) {
                        reviewApplaused = NO;i=(int)[[lessonNameTextField text]length];
                        j=(int)[prohibitedSymbolsRegEx length];
                    }
                }
            }
        }
        if (reviewApplaused&&![[lessonNameTextField text]isEqualToString:@""]&&([[lessonNameTextField text] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location == NSNotFound&&[[lessonNameTextField text] rangeOfString:@"Приятного аппетита" options:NSCaseInsensitiveSearch].location == NSNotFound&&[[lessonNameTextField text] rangeOfString:@"Bon appetit" options:NSCaseInsensitiveSearch].location == NSNotFound&&[[lessonNameTextField text] rangeOfString:@"Afiyet Olsun" options:NSCaseInsensitiveSearch].location == NSNotFound)) {
            [lessonNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            if (!addButtonClicked) {
                 updateObject = [array_Of_Targets objectAtIndex:objectIndex];
                objectId = [updateObject objectId];
                updateObject = [PFObject objectWithoutDataWithClassName:tableOfTargetsTitleName objectId:objectId];
                [updateObject setObject:[[lessonNameTextField text]capitalizedString] forKey:@"Lesson"];
                [updateObject save];
            }
            else {
                updateObject = [PFObject objectWithClassName:tableOfTargetsTitleName];
                updateObject[@"Lesson"] = [lessonNameTextField text];
                [updateObject saveInBackground];
            }
            [custom_Navigation_Bar setUserInteractionEnabled:YES];
        }
        else {
            [lessonNameTextField setBackgroundColor:[UIColor redColor]];
            reviewApplaused = NO;
        }
    }
    else if ([tableOfTargetsTitleName isEqualToString:@"Year"]) {
        [self checkDurationsTextField:firstLessonDurationTextField];
    if (reviewApplaused) {
    [self checkDurationsTextField:secondLessonDurationTextField];
    if (reviewApplaused) {
    [self checkSequence:firstLessonDurationTextField compareWithAnotherTextField:
     secondLessonDurationTextField];
    if (reviewApplaused) {
    [self checkDurationsTextField:thirdLessonDurationTextField];
    if (reviewApplaused) {
    [self checkSequence:secondLessonDurationTextField compareWithAnotherTextField:
     thirdLessonDurationTextField];
    if (reviewApplaused) {
    [self checkDurationsTextField:fourthLessonDurationTextField];
    if (reviewApplaused) {
    [self checkSequence:thirdLessonDurationTextField compareWithAnotherTextField:
     fourthLessonDurationTextField];
    if (reviewApplaused) {
    [self checkDurationsTextField:fifthLessonDurationTextField];
    if (reviewApplaused) {
    [self checkSequence:fourthLessonDurationTextField compareWithAnotherTextField:
     fifthLessonDurationTextField];
    if (reviewApplaused) {
    [self checkDurationsTextField:sixthLessonDurationTextField];
    if (reviewApplaused) {
    [self checkSequence:fifthLessonDurationTextField compareWithAnotherTextField:sixthLessonDurationTextField];
    if (reviewApplaused) {
    [self checkDurationsTextField:seventhLessonDurationTextField];
    if (reviewApplaused) {
    [self checkSequence:sixthLessonDurationTextField compareWithAnotherTextField:
     seventhLessonDurationTextField];
    if (reviewApplaused) {
    [self checkDurationsTextField:eighthLessonDurationTextField];
    if (reviewApplaused) {
    [self checkSequence:seventhLessonDurationTextField compareWithAnotherTextField:eighthLessonDurationTextField];
        if (reviewApplaused) {
            [self checkDurationsTextField:lunchTimeDurationTextField];
            if (reviewApplaused) {
                NSString *lunchTimeText = [lunchTimeDurationTextField text];
                if ([lunchTimeText isEqualToString:[firstLessonDurationTextField text]]&&
                    [lunchTimeText isEqualToString:[secondLessonDurationTextField text]]&&
                    [lunchTimeText isEqualToString:[thirdLessonDurationTextField text]]&&
                    [lunchTimeText isEqualToString:[fourthLessonDurationTextField text]]&&
                    [lunchTimeText isEqualToString:[fifthLessonDurationTextField text]]&&
                    [lunchTimeText isEqualToString:[sixthLessonDurationTextField text]]&&
                    [lunchTimeText isEqualToString:[seventhLessonDurationTextField text]]&&
                    [lunchTimeText isEqualToString:[eighthLessonDurationTextField text]]) {
                    [lunchTimeDurationTextField setBackgroundColor:[UIColor redColor]];
                    reviewApplaused = NO;
                }
                else {
                    [lunchTimeDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
                }
            }
        }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
        if (reviewApplaused) {
                updateObject = [array_Of_Targets objectAtIndex:objectIndex];
                objectId = [updateObject objectId];
                updateObject = [PFObject objectWithoutDataWithClassName:@"LessonsDuration" objectId:objectId];
                [updateObject setObject:[self formatLessonDuration:[firstLessonDurationTextField text]] forKey:@"First"];
                [updateObject setObject:[self formatLessonDuration:[secondLessonDurationTextField text]] forKey:@"Second"];
                [updateObject setObject:[self formatLessonDuration:[thirdLessonDurationTextField text]] forKey:@"Third"];
                [updateObject setObject:[self formatLessonDuration:[fourthLessonDurationTextField text]] forKey:@"Fourth"];
                [updateObject setObject:[self formatLessonDuration:[fifthLessonDurationTextField text]] forKey:@"Fifth"];
                [updateObject setObject:[self formatLessonDuration:[sixthLessonDurationTextField text]] forKey:@"Sixth"];
                [updateObject setObject:[self formatLessonDuration:[seventhLessonDurationTextField text]] forKey:@"Seventh"];
                [updateObject setObject:[self formatLessonDuration:[eighthLessonDurationTextField text]] forKey:@"Eighth"];
                [updateObject setObject:[self formatLessonDuration:[lunchTimeDurationTextField text]] forKey:@"Lunch"];
                [updateObject save];
                [custom_Navigation_Bar setUserInteractionEnabled:YES];
        }
    }
    if (!reviewApplaused) {
        [custom_Navigation_Bar setUserInteractionEnabled:YES];
    }
    else {
        [self dismiss_Keyboards];
    }
}

-(void)dismissDelete {
    for (NSIndexPath *indexPath in [tableOfTargets indexPathsForSelectedRows]) {
        [tableOfTargets deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self returnInitialState];
}

-(void)deleteTargets {
    NSString *tableInitialHeader = [self tableView:tableOfTargets titleForHeaderInSection:0];
    NSMutableArray *rows = [NSMutableArray new];
    for (int i=0;i<[[tableOfTargets indexPathsForSelectedRows]count];i++) {
        [rows addObject:[NSNumber numberWithInteger:[[[tableOfTargets indexPathsForSelectedRows]objectAtIndex:i]row]]];
    }
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending:YES];
    NSArray *sortedSelectedRows = [rows sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
    int numberOfDecrements = 0;
    for (int i=0;i<[sortedSelectedRows count];i++) {
        PFObject *deleteObject;
        if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
            deleteObject = [[array_Of_Targets objectAtIndex:studentGroupIndex]objectAtIndex:[[sortedSelectedRows objectAtIndex:i]intValue]-numberOfDecrements];
        }
        else {
            deleteObject = [array_Of_Targets objectAtIndex:[[sortedSelectedRows objectAtIndex:i]intValue]-numberOfDecrements];
        }
        NSString *objectId = [deleteObject objectId];
        deleteObject = [PFObject objectWithoutDataWithClassName:tableOfTargetsTitleName objectId:objectId];
        [deleteObject deleteInBackground];
        if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
            [[array_Of_Targets objectAtIndex:studentGroupIndex]removeObjectAtIndex:[[sortedSelectedRows objectAtIndex:i]intValue]-numberOfDecrements];
        }
        else {
            [array_Of_Targets removeObjectAtIndex:[[sortedSelectedRows objectAtIndex:i]intValue]-numberOfDecrements];
        }
        numberOfDecrements++;
    }
    if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
        if ([[array_Of_Targets objectAtIndex:studentGroupIndex]count]==0) {
            [array_Of_Groups removeObjectAtIndex:studentGroupIndex];
            [array_Of_Targets removeObjectAtIndex:studentGroupIndex];
            for (int i=0;i<[arrayOfAllGroups count];i++) {
                if ([tableInitialHeader isEqualToString:[[[arrayOfAllGroups objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]componentsJoinedByString:@""]]) {
                    studentGroupIndex = i;
                    break;
                }
            }
            [tableOfTargets setAllowsSelection:NO];
            [self checkForExistingGroup:studentGroupIndex];
        }
    }
    else {
        [tableOfTargets beginUpdates];
        [tableOfTargets deleteRowsAtIndexPaths:[tableOfTargets indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableOfTargets endUpdates];
        [tableOfTargets setAllowsMultipleSelection:NO];
    }
    [self returnInitialState];
}

-(void)returnInitialState {
    [custom_Navigation_Bar.topItem setLeftBarButtonItem:backToEditing];
    [custom_Navigation_Bar.topItem setRightBarButtonItem:editOptions];
    addButtonClicked = YES;
    deleteButtonClicked = NO;
}

-(void)editing_Begins:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if ([segment selectedSegmentIndex]==0) {
        addButtonClicked = NO;
        deleteButtonClicked = YES;
        [custom_Navigation_Bar.topItem setLeftBarButtonItem:dismissDeleteButton];
        [custom_Navigation_Bar.topItem setRightBarButtonItem:deleteTargetsButton];
        [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:NO];
        [tableOfTargets setAllowsMultipleSelection:YES];
    }
    else if ([segment selectedSegmentIndex]==1) {
        addButtonClicked = YES;
        deleteButtonClicked = NO;
        [self.custom_Navigation_Bar.topItem setLeftBarButtonItem:backButtonOfCalledViews];
        [self.custom_Navigation_Bar.topItem setRightBarButtonItem:saveButton];
        if ([tableOfTargetsTitleName isEqualToString:@"Lessons"]) {
            [custom_Navigation_Bar.topItem setTitle:@"New Lesson"];
            [editor_Mode_For_Lessons setHidden:NO];
            [lessonNameTextField setText:@""];
        }
        else if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
            self.studentEditorModeIsShown = YES;
            [custom_Navigation_Bar.topItem setTitle:@"New Student"];
            [editor_Mode_For_Students setHidden:NO];
            [editor_Mode_For_Students setContentOffset:CGPointMake(0, 0) animated:NO];
            [studentNameTextField setText:@""];
            [studentSurnameTextField setText:@""];
            [studentGroupTextField setText:[array_Of_Groups objectAtIndex:studentGroupIndex]];
        }
        else if ([tableOfTargetsTitleName isEqualToString:@"Teachers"]) {
            [custom_Navigation_Bar.topItem setTitle:@"New Teacher"];
            [editor_Mode_For_Teachers setHidden:NO];
            [editor_Mode_For_Teachers setContentOffset:CGPointMake(0, 0) animated:NO];
            [teacherNameTextField setText:@""];
            [teacherSurnameTextField setText:@""];
            [teacherEmailTextField setText:@""];
            [fixedClassNameLabel setText:@""];
        }
        if (![tableOfTargetsTitleName isEqualToString:@"Year"]) {
            [backButtonOfCalledViews setTitle:[NSString stringWithFormat:@"Back to %@",tableOfTargetsTitleName]];
        }
    }
    else if ([segment selectedSegmentIndex]==2) {
        [student_Group_Picker reloadAllComponents];
        [tableOfTargets setAllowsSelection:NO];
        [custom_Navigation_Bar.topItem setRightBarButtonItem:self.doneButton];
        self.STUDENT_MODE = YES;
        hiddenTextFieldForStudentsGroup = [[UITextField alloc]init];
        [self.view addSubview:hiddenTextFieldForStudentsGroup];
        [hiddenTextFieldForStudentsGroup setInputView:student_Group_Picker];
        [hiddenTextFieldForStudentsGroup becomeFirstResponder];
    }
    else {
        self.multipleChoiceOfStudentsBegin = YES;
        [tableOfTargets setAllowsMultipleSelection:YES];
        [self.custom_Navigation_Bar.topItem setRightBarButtonItem:self.doneChoice];
        [self.doneChoice setEnabled:NO];
        [self.custom_Navigation_Bar.topItem setLeftBarButtonItem:self.cancelChoice];
    }
    [segment setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

-(void)doneStudentsChoice {
    [self.custom_Navigation_Bar.topItem setLeftBarButtonItem:backToEditing];
    [self.custom_Navigation_Bar.topItem setRightBarButtonItem:nil];
    self.chooseStudentsToTranslate = YES;
    self.transferAllStudentsToAnotherGroupIsShown = YES;
    [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:NO];
    [self makeQuery:tableOfTargetsTitleName];
}

-(void)cancelStudentsChoice {
    for (NSIndexPath *indexPath in [tableOfTargets indexPathsForSelectedRows]) {
        [tableOfTargets deselectRowAtIndexPath:indexPath animated:YES];
    }
    [tableOfTargets setAllowsMultipleSelection:NO];
    self.chooseStudentsToTranslate = NO;
    [self.custom_Navigation_Bar.topItem setLeftBarButtonItem:backToEditing];
    [self.custom_Navigation_Bar.topItem setRightBarButtonItem:editOptions];
    self.multipleChoiceOfStudentsBegin = NO;
}

-(void)back_To_Students {
    [self cancelStudentsChoice];
    [self doneWithStudentGroupChoice];
    [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:NO];
    [self makeQuery:tableOfTargetsTitleName];
}

-(void)doneWithStudentGroupChoice {
    if (self.transferAllStudentsToAnotherGroupIsShown) {
        if (![choiceFromStudentGroup isHidden]) {
            [choiceFromStudentGroup setHidden:YES];
        }
        self.transferAllStudentsToAnotherGroupIsShown = NO;
        [hiddenTextFieldForStudentsGroup removeFromSuperview];
        [array_Of_Students_To_Transform removeAllObjects];
    }
    else {
        if (self.noStudents) {
            [tableOfTargets setAllowsSelection:NO];
            self.noStudents = NO;
            studentGroupIndex = 0;
        }
        else {
            [tableOfTargets setAllowsSelection:YES];
        }
        self.STUDENT_MODE = NO;
        [hiddenTextFieldForStudentsGroup removeFromSuperview];
    }
    if (self.custom_Navigation_Bar.topItem.rightBarButtonItem!=editOptions) {
        [self.custom_Navigation_Bar.topItem setRightBarButtonItem:editOptions];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    prohibitedSymbolsRegEx = @"¡™£¢∞¶•ªº≠`Ω≈√Œ∑´®†¥¨ˆ“‘©˙˚¬…«∫˜≤≥÷,.:;?!@§±#$%^*+=_(){}[]|\\/~";
    backButton = custom_Navigation_Bar.topItem.leftBarButtonItem;
    backToEditing = [[UIBarButtonItem alloc]initWithTitle:@"Back to Edit Options" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissTargetTableView)];
    self.editSegment = [[UISegmentedControl alloc]initWithItems:@[@"-",@"+"]];
    [self.editSegment setFrame:CGRectMake(0, 0, 100, 29)];
    [self.editSegment addTarget:self action:@selector(editing_Begins:) forControlEvents:UIControlEventValueChanged];
    editOptions = [[UIBarButtonItem alloc]initWithCustomView:self.editSegment];
    self.doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithStudentGroupChoice)];
    self.doneChoice = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneStudentsChoice)];
    self.cancelChoice = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelStudentsChoice)];
    self.backToStudents = [[UIBarButtonItem alloc]initWithTitle:@"Back to Students" style:UIBarButtonItemStyleBordered target:self action:@selector(back_To_Students)];
    dismissDeleteButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDelete)];
    deleteTargetsButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteTargets)];
    [deleteTargetsButton setTintColor:[UIColor redColor]];
    backButtonOfCalledViews = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissCalledViews)];
    saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save)];
    days_titles = [[NSArray alloc]initWithObjects:
                   @"Monday", @"Tuesday",  @"Wednesday", @"Thursday", @"Friday", nil];
    self.defaults = [NSUserDefaults standardUserDefaults];
    if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Teacher"]) {
        [self.duplicate_Button setUserInteractionEnabled:NO];
        [self.duplicate_Button setBackgroundColor:[UIColor darkGrayColor]];
        [self.duplicate_Button setTitle:@"Inactive for Teachers" forState:UIControlStateNormal];
    }
    
    nameOfReflectedClass = [self.defaults objectForKey:@"TargetName"];
    [custom_Navigation_Bar.topItem setTitle:[self.defaults objectForKey:@"FullTargetName"]];
    formattedTitle = nameOfReflectedClass;
    if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Student"]) {
        if (formattedTitle&&![formattedTitle isEqualToString:@""]) {
            if ([formattedTitle rangeOfString:@"RU" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                NSRange range = [formattedTitle rangeOfString:@"RU" options:NSCaseInsensitiveSearch];
                if (range.length > 0){
                    formattedTitle = [formattedTitle stringByReplacingOccurrencesOfString:@"RU" withString:@"KZ" options:NSCaseInsensitiveSearch range:range];
                }
            }
            else {
                if ([formattedTitle rangeOfString:@"KZ" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    NSRange range = [formattedTitle rangeOfString:@"KZ" options:NSCaseInsensitiveSearch];
                    if (range.length > 0){
                        formattedTitle = [formattedTitle stringByReplacingOccurrencesOfString:@"KZ" withString:@"RU" options:NSCaseInsensitiveSearch range:range];
                    }
                }
            }
        }
        
        parallelGroup = formattedTitle;
        if ([parallelGroup rangeOfString:@"1"].location != NSNotFound) {
            parallelGroup = [parallelGroup stringByReplacingCharactersInRange:NSMakeRange([parallelGroup rangeOfString:@"1"].location, 1) withString:[NSString stringWithFormat:@" %c ",[parallelGroup characterAtIndex:[parallelGroup rangeOfString:@"1"].location]]];
        }
        if ([parallelGroup rangeOfString:@"2"].location != NSNotFound) {
            parallelGroup = [parallelGroup stringByReplacingCharactersInRange:NSMakeRange([parallelGroup rangeOfString:@"2"].location, 1) withString:[NSString stringWithFormat:@" %c ",[parallelGroup characterAtIndex:[parallelGroup rangeOfString:@"2"].location]]];
        }
        if ([parallelGroup rangeOfString:@"3"].location != NSNotFound) {
            parallelGroup = [parallelGroup stringByReplacingCharactersInRange:NSMakeRange([parallelGroup rangeOfString:@"3"].location, 1) withString:[NSString stringWithFormat:@" %c ",[parallelGroup characterAtIndex:[parallelGroup rangeOfString:@"3"].location]]];
        }
        if ([parallelGroup rangeOfString:@"4"].location != NSNotFound) {
            parallelGroup = [parallelGroup stringByReplacingCharactersInRange:NSMakeRange([parallelGroup rangeOfString:@"4"].location, 1) withString:[NSString stringWithFormat:@" %c ",[parallelGroup characterAtIndex:[parallelGroup rangeOfString:@"4"].location]]];
        }
        if ([parallelGroup rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            parallelGroup = [parallelGroup stringByReplacingCharactersInRange:NSMakeRange([parallelGroup rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].location, [parallelGroup rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].length) withString:@"Translation Studies"];
        }
    }
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    tableOfTargets = [[UITableView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20)) style:UITableViewStylePlain];
    choiceFromStudentGroup = [[UITableView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20)) style:UITableViewStylePlain];
    editor_Mode_For_Students = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20))];
    editor_Mode_For_Teachers = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20))];
    editor_Mode_For_Lessons = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20))];
    editor_Mode_For_Lessons_Duration = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20))];
    if ([[ver objectAtIndex:0] intValue] >= 8) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [tableOfTargets setFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)];
            [choiceFromStudentGroup setFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)];
            editor_Mode_For_Students = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)];
            editor_Mode_For_Teachers = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)];
            editor_Mode_For_Lessons = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)];
            editor_Mode_For_Lessons_Duration = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)];
        }
        else {
            [tableOfTargets setFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))];
            [choiceFromStudentGroup setFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))];
            editor_Mode_For_Students = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))];
            editor_Mode_For_Teachers = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))];
            editor_Mode_For_Lessons = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))];
            editor_Mode_For_Lessons_Duration = [[UIScrollView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))];
        }
    }
    [self.view addSubview:tableOfTargets];
    [tableOfTargets setHidden:YES];
    [tableOfTargets setDelegate:self];
    [tableOfTargets setDataSource:self];
    [self.view addSubview:choiceFromStudentGroup];
    [choiceFromStudentGroup setHidden:YES];
    [choiceFromStudentGroup setDelegate:self];
    [choiceFromStudentGroup setDataSource:self];
    [choiceFromStudentGroup setAllowsSelection:NO];
    [self.view addSubview:editor_Mode_For_Teachers];
    [editor_Mode_For_Teachers setHidden:YES];
    [editor_Mode_For_Teachers setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:editor_Mode_For_Students];
    [editor_Mode_For_Students setHidden:YES];
    [editor_Mode_For_Students setBackgroundColor:[UIColor whiteColor]];
    
    //========= editor_Mode_For_Students =========
    
    studentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, editor_Mode_For_Teachers.frame.size.width, 21)];
    [studentNameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [studentNameLabel setText:@"Student Name"];
    [studentNameLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Students addSubview:studentNameLabel];
    studentNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, studentNameLabel.frame.origin.y+studentNameLabel.frame.size.height+8, editor_Mode_For_Students.frame.size.width-16, 30)];
    [studentNameTextField setPlaceholder:@"Enter the name of the student"];
    [studentNameTextField setTextAlignment:NSTextAlignmentCenter];
    [studentNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [studentNameTextField setDelegate:self];
    [studentNameTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [editor_Mode_For_Students addSubview:studentNameTextField];
    
    studentSurnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, studentNameTextField.frame.origin.y+studentNameTextField.frame.size.height+8, editor_Mode_For_Students.frame.size.width, 21)];
    [studentSurnameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [studentSurnameLabel setText:@"Student Surname"];
    [studentSurnameLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Students addSubview:studentSurnameLabel];
    studentSurnameTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, studentSurnameLabel.frame.origin.y+studentSurnameLabel.frame.size.height+8, editor_Mode_For_Students.frame.size.width-16, 30)];
    [studentSurnameTextField setPlaceholder:@"Enter the surname of the student"];
    [studentSurnameTextField setTextAlignment:NSTextAlignmentCenter];
    [studentSurnameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [studentSurnameTextField setDelegate:self];
    [studentSurnameTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [editor_Mode_For_Students addSubview:studentSurnameTextField];
    
    studentGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, studentSurnameTextField.frame.origin.y+studentSurnameTextField.frame.size.height+8, editor_Mode_For_Students.frame.size.width, 21)];
    [studentGroupLabel setBackgroundColor:[UIColor lightGrayColor]];
    [studentGroupLabel setText:@"Student Group"];
    [studentGroupLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Students addSubview:studentGroupLabel];
    studentGroupTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, studentGroupLabel.frame.origin.y+studentGroupLabel.frame.size.height+8, editor_Mode_For_Students.frame.size.width-16, 30)];
    [studentGroupTextField setPlaceholder:@"Enter the group of the student"];
    [studentGroupTextField setTextAlignment:NSTextAlignmentCenter];
    [studentGroupTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [studentGroupTextField setDelegate:self];
    
    student_Group_Picker = [[UIPickerView alloc]init];
    [student_Group_Picker setDataSource:self];
    [student_Group_Picker setDelegate:self];
    [student_Group_Picker showsSelectionIndicator];
    [studentGroupTextField setInputView:student_Group_Picker];
    
    [studentGroupTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [editor_Mode_For_Students addSubview:studentGroupTextField];
    [editor_Mode_For_Students setContentSize:CGSizeMake(0,self.view.frame.size.height)];
    
    //========= editor_Mode_For_Teachers =========
    
    teacherNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, editor_Mode_For_Teachers.frame.size.width, 21)];
    [teacherNameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [teacherNameLabel setText:@"Name"];
    [teacherNameLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Teachers addSubview:teacherNameLabel];
    teacherNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, teacherNameLabel.frame.origin.y+teacherNameLabel.frame.size.height+8, editor_Mode_For_Teachers.frame.size.width-16, 30)];
    [teacherNameTextField setPlaceholder:@"Enter the name of the teacher"];
    [teacherNameTextField setTextAlignment:NSTextAlignmentCenter];
    [teacherNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [teacherNameTextField setDelegate:self];
    [teacherNameTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [editor_Mode_For_Teachers addSubview:teacherNameTextField];
    
    teacherSurnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, teacherNameTextField.frame.origin.y+teacherNameTextField.frame.size.height+8, editor_Mode_For_Teachers.frame.size.width, 21)];
    [teacherSurnameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [teacherSurnameLabel setText:@"Surname"];
    [teacherSurnameLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Teachers addSubview:teacherSurnameLabel];
    teacherSurnameTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, teacherSurnameLabel.frame.origin.y+teacherSurnameLabel.frame.size.height+8, editor_Mode_For_Teachers.frame.size.width-16, 30)];
    [teacherSurnameTextField setPlaceholder:@"Enter the surname of the teacher"];
    [teacherSurnameTextField setTextAlignment:NSTextAlignmentCenter];
    [teacherSurnameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [teacherSurnameTextField setDelegate:self];
    [teacherSurnameTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [editor_Mode_For_Teachers addSubview:teacherSurnameTextField];
    
    teacherEmailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, teacherSurnameTextField.frame.origin.y+teacherSurnameTextField.frame.size.height+8, editor_Mode_For_Teachers.frame.size.width, 21)];
    [teacherEmailLabel setBackgroundColor:[UIColor lightGrayColor]];
    [teacherEmailLabel setText:@"Email"];
    [teacherEmailLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Teachers addSubview:teacherEmailLabel];
    teacherEmailTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, teacherEmailLabel.frame.origin.y+teacherEmailLabel.frame.size.height+8, editor_Mode_For_Teachers.frame.size.width-16, 30)];
    [teacherEmailTextField setPlaceholder:@"Enter the email of the teacher"];
    [teacherEmailTextField setTextAlignment:NSTextAlignmentCenter];
    [teacherEmailTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [teacherEmailTextField setDelegate:self];
    [teacherEmailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [editor_Mode_For_Teachers addSubview:teacherEmailTextField];
    
    teacherClassNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, teacherEmailTextField.frame.origin.y+teacherEmailTextField.frame.size.height+8, editor_Mode_For_Teachers.frame.size.width, 21)];
    [teacherClassNameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [teacherClassNameLabel setText:@"Class Name"];
    [teacherClassNameLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Teachers addSubview:teacherClassNameLabel];
    fixedClassNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, teacherClassNameLabel.frame.origin.y+teacherClassNameLabel.frame.size.height+8, editor_Mode_For_Teachers.frame.size.width, 21)];
    [fixedClassNameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [fixedClassNameLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Teachers addSubview:fixedClassNameLabel];
    [editor_Mode_For_Teachers setContentSize:CGSizeMake(0,self.view.frame.size.height)];
    
    //========= editor_Mode_For_Lessons =========
    
    lessonNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, editor_Mode_For_Lessons.frame.size.width, 21)];
    [lessonNameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [lessonNameLabel setText:@"Lesson"];
    [lessonNameLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons addSubview:lessonNameLabel];
    lessonNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, lessonNameLabel.frame.origin.y+lessonNameLabel.frame.size.height+8, editor_Mode_For_Lessons.frame.size.width-16, 30)];
    [lessonNameTextField setPlaceholder:@"Enter the lesson name"];
    [lessonNameTextField setTextAlignment:NSTextAlignmentCenter];
    [lessonNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [lessonNameTextField setDelegate:self];
    [lessonNameTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [editor_Mode_For_Lessons addSubview:lessonNameTextField];
    
    //========= editor_Mode_For_Lessons_Duration =========
    
    lesson_Duration_Picker = [[UIPickerView alloc]init];
    [lesson_Duration_Picker setDataSource:self];
    [lesson_Duration_Picker setDelegate:self];
    [lesson_Duration_Picker showsSelectionIndicator];
    
    hours = [NSMutableArray new];
    minutes= [NSMutableArray new];
    for (int i=0;i<24;i++) {
        [hours addObject:[NSString stringWithFormat:@"%i",i]];
    }
    for (int j=0;j<60;j++) {
        [minutes addObject:[NSString stringWithFormat:@"%i",j]];
    }
    
    firstLessonDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [firstLessonDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [firstLessonDurationLabel setText:@"First Lesson"];
    [firstLessonDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:firstLessonDurationLabel];
    firstLessonDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, firstLessonDurationLabel.frame.origin.y+firstLessonDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [firstLessonDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [firstLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [firstLessonDurationTextField setDelegate:self];
    [firstLessonDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:firstLessonDurationTextField];
    
    secondLessonDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, firstLessonDurationTextField.frame.origin.y+firstLessonDurationTextField.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [secondLessonDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [secondLessonDurationLabel setText:@"Second Lesson"];
    [secondLessonDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:secondLessonDurationLabel];
    secondLessonDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, secondLessonDurationLabel.frame.origin.y+secondLessonDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [secondLessonDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [secondLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [secondLessonDurationTextField setDelegate:self];
    [secondLessonDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:secondLessonDurationTextField];
    
    thirdLessonDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, secondLessonDurationTextField.frame.origin.y+secondLessonDurationTextField.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [thirdLessonDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [thirdLessonDurationLabel setText:@"Third Lesson"];
    [thirdLessonDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:thirdLessonDurationLabel];
    thirdLessonDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, thirdLessonDurationLabel.frame.origin.y+thirdLessonDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [thirdLessonDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [thirdLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [thirdLessonDurationTextField setDelegate:self];
    [thirdLessonDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:thirdLessonDurationTextField];
    
    fourthLessonDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, thirdLessonDurationTextField.frame.origin.y+thirdLessonDurationTextField.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [fourthLessonDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [fourthLessonDurationLabel setText:@"Fourth Lesson"];
    [fourthLessonDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:fourthLessonDurationLabel];
    fourthLessonDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, fourthLessonDurationLabel.frame.origin.y+fourthLessonDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [fourthLessonDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [fourthLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [fourthLessonDurationTextField setDelegate:self];
    [fourthLessonDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:fourthLessonDurationTextField];
    
    fifthLessonDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, fourthLessonDurationTextField.frame.origin.y+fourthLessonDurationTextField.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [fifthLessonDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [fifthLessonDurationLabel setText:@"Fifth Lesson"];
    [fifthLessonDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:fifthLessonDurationLabel];
    fifthLessonDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, fifthLessonDurationLabel.frame.origin.y+fifthLessonDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [fifthLessonDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [fifthLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [fifthLessonDurationTextField setDelegate:self];
    [fifthLessonDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:fifthLessonDurationTextField];
    
    sixthLessonDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, fifthLessonDurationTextField.frame.origin.y+fifthLessonDurationTextField.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [sixthLessonDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [sixthLessonDurationLabel setText:@"Sixth Lesson"];
    [sixthLessonDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:sixthLessonDurationLabel];
    sixthLessonDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, sixthLessonDurationLabel.frame.origin.y+sixthLessonDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [sixthLessonDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [sixthLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [sixthLessonDurationTextField setDelegate:self];
    [sixthLessonDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:sixthLessonDurationTextField];
    
    seventhLessonDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, sixthLessonDurationTextField.frame.origin.y+sixthLessonDurationTextField.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [seventhLessonDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [seventhLessonDurationLabel setText:@"Seventh Lesson"];
    [seventhLessonDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:seventhLessonDurationLabel];
    seventhLessonDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, seventhLessonDurationLabel.frame.origin.y+seventhLessonDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [seventhLessonDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [seventhLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [seventhLessonDurationTextField setDelegate:self];
    [seventhLessonDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:seventhLessonDurationTextField];
    
    eigththLessonDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, seventhLessonDurationTextField.frame.origin.y+seventhLessonDurationTextField.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [eigththLessonDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [eigththLessonDurationLabel setText:@"Eighth Lesson"];
    [eigththLessonDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:eigththLessonDurationLabel];
    eighthLessonDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, eigththLessonDurationLabel.frame.origin.y+eigththLessonDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [eighthLessonDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [eighthLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [eighthLessonDurationTextField setDelegate:self];
    [eighthLessonDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:eighthLessonDurationTextField];
    
    lunchTimeDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, eighthLessonDurationTextField.frame.origin.y+eighthLessonDurationTextField.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width, 21)];
    [lunchTimeDurationLabel setBackgroundColor:[UIColor lightGrayColor]];
    [lunchTimeDurationLabel setText:@"Lunch Time"];
    [lunchTimeDurationLabel setTextAlignment:NSTextAlignmentCenter];
    [editor_Mode_For_Lessons_Duration addSubview:lunchTimeDurationLabel];
    lunchTimeDurationTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, lunchTimeDurationLabel.frame.origin.y+lunchTimeDurationLabel.frame.size.height+8, editor_Mode_For_Lessons_Duration.frame.size.width-16, 30)];
    [lunchTimeDurationTextField setTextAlignment:NSTextAlignmentCenter];
    [lunchTimeDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [lunchTimeDurationTextField setDelegate:self];
    [lunchTimeDurationTextField setInputView:lesson_Duration_Picker];
    [editor_Mode_For_Lessons_Duration addSubview:lunchTimeDurationTextField];
    [editor_Mode_For_Lessons_Duration setContentSize:CGSizeMake(0, self.view.frame.size.height+400)];
    
    lessonBeginningHour = @"";
    lessonBeginningMinute = @"";
    lessonFinishingHour = @"";
    lessonFinishingMinute  = @"";
    
    [self.view addSubview:editor_Mode_For_Lessons];
    [editor_Mode_For_Lessons setHidden:YES];
    [editor_Mode_For_Lessons setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:editor_Mode_For_Lessons_Duration];
    [editor_Mode_For_Lessons_Duration setHidden:YES];
    [editor_Mode_For_Lessons_Duration setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *dismissKeyboards1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss_Keyboards)];
    UITapGestureRecognizer *dismissKeyboards2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss_Keyboards)];
    UITapGestureRecognizer *dismissKeyboards3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss_Keyboards)];
    UITapGestureRecognizer *dismissKeyboards4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss_Keyboards)];
    [editor_Mode_For_Teachers addGestureRecognizer:dismissKeyboards1];
    [editor_Mode_For_Lessons_Duration addGestureRecognizer:dismissKeyboards2];
    [editor_Mode_For_Lessons addGestureRecognizer:dismissKeyboards3];
    [editor_Mode_For_Students addGestureRecognizer:dismissKeyboards4];
}

-(void)dismiss_Keyboards {
    [teacherEmailTextField resignFirstResponder];
    [lessonNameTextField resignFirstResponder];
    [ActiveField resignFirstResponder];
}

-(void)create_Download_Signs {
    dimmed_View = [[UIView alloc]init];
    [dimmed_View setBackgroundColor:[UIColor blackColor]];
    [dimmed_View setAlpha:0.5];
    [dimmed_View.layer setMasksToBounds:YES];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
    [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
}

#pragma Picker View

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == student_Group_Picker) {
        if (self.transferAllStudentsToAnotherGroupIsShown) {
            return [array_Of_Groups objectAtIndex:row];
        }
        return [arrayOfAllGroups objectAtIndex:row];
    }
    if (component == 0) {
        return [hours objectAtIndex:row];
    }
    if (component == 1) {
        return [minutes objectAtIndex:row];
    }
    else if (component == 2) {
        return [hours objectAtIndex:row];
    }
    else if (component == 3) {
        return [minutes objectAtIndex:row];
    }
    return nil;
}

-(void)checkForExistingGroup:(NSInteger)row {
    for (int i=0;i<[array_Of_Groups count];i++) {
        if ([[array_Of_Groups objectAtIndex:i]isEqualToString:[[[arrayOfAllGroups objectAtIndex:row] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]componentsJoinedByString:@""]]) {
            studentGroupIndex = i;
            self.noStudents = NO;
            [tableOfTargets reloadData];
            [self.editSegment setEnabled:YES forSegmentAtIndex:0];
            [self.editSegment setEnabled:YES forSegmentAtIndex:3];
            break;
        }
        else {
            studentGroupIndex = (int)row;
            self.noStudents = YES;
            [self.editSegment setEnabled:NO forSegmentAtIndex:0];
            [self.editSegment setEnabled:NO forSegmentAtIndex:3];
            [tableOfTargets reloadData];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == student_Group_Picker) {
        if ([[tableOfTargets indexPathsForSelectedRows]count]!=0) {
            for (NSIndexPath *indexPath in [tableOfTargets indexPathsForSelectedRows]) {
                [tableOfTargets deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
        if (self.transferAllStudentsToAnotherGroupIsShown) {
            self.changingStudentGroupIndex = (int)row;
            [choiceFromStudentGroup reloadData];
        }
        else {
            if (self.studentEditorModeIsShown) {
                [studentGroupTextField setText:[[[arrayOfAllGroups objectAtIndex:row] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]componentsJoinedByString:@""]];
            }
            else {
                [self checkForExistingGroup:row];
            }
        }
    }
    else {
        if (component==0) {
            lessonBeginningHour = [hours objectAtIndex:row];
        }
        else if (component==1) {
            lessonBeginningMinute = [minutes objectAtIndex:row];
        }
        else if (component==2) {
            lessonFinishingHour = [hours objectAtIndex:row];
        }
        else if (component==3) {
            lessonFinishingMinute = [minutes objectAtIndex:row];
        }
        [ActiveField setText:[NSString stringWithFormat:@"%@:%@ %@:%@",lessonBeginningHour,lessonBeginningMinute,lessonFinishingHour,lessonFinishingMinute]];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == student_Group_Picker) {
        if (self.transferAllStudentsToAnotherGroupIsShown) {
            return [array_Of_Groups count];
        }
        return [arrayOfAllGroups count];
    }
    if (component == 0) {
        return [hours count];
    }
    if (component == 1) {
        return [minutes count];
    }
    else if (component == 2) {
        return [hours count];
    }
    else {
        return [minutes count];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == student_Group_Picker) {
        return 1;
    }
    return 4;
}

#pragma Text Field

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![[UITextInputMode currentInputMode].primaryLanguage isEqualToString:@"ru-RU"]) {
        if (textField == teacherNameTextField) {
            return NO;
        }
        else if (textField == teacherSurnameTextField) {
            return NO;
        }
        else if (textField == studentNameTextField) {
            return NO;
        }
        else if (textField == studentSurnameTextField) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController&&ActiveField) {
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    if (textField==teacherNameTextField||textField==teacherSurnameTextField) {
        [editor_Mode_For_Teachers setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
        ActiveField = textField;
    }
    else if (textField==teacherEmailTextField) {
        [editor_Mode_For_Teachers setContentOffset:CGPointMake(0, teacherEmailTextField.frame.origin.y) animated:YES];
    }
    else if (textField==firstLessonDurationTextField||textField==secondLessonDurationTextField||textField==thirdLessonDurationTextField||textField==fourthLessonDurationTextField||textField==fifthLessonDurationTextField||textField==sixthLessonDurationTextField||textField==seventhLessonDurationTextField||textField==eighthLessonDurationTextField||textField==lunchTimeDurationTextField) {
        ActiveField = textField;
    }
    else if (textField==studentNameTextField||textField==studentSurnameTextField||textField==studentGroupTextField||textField==studentGroupTextField) {
        [editor_Mode_For_Students setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
        ActiveField = textField;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField==firstLessonDurationTextField||textField==secondLessonDurationTextField||textField==thirdLessonDurationTextField||textField==fourthLessonDurationTextField||textField==fifthLessonDurationTextField||textField==sixthLessonDurationTextField||textField==seventhLessonDurationTextField||textField==eighthLessonDurationTextField||textField==lunchTimeDurationTextField) {
        ActiveField = nil;
        lessonBeginningHour = @"";
        lessonBeginningMinute = @"";
        lessonFinishingHour = @"";
        lessonFinishingMinute  = @"";
    }
    else if (textField==teacherNameTextField||textField==teacherSurnameTextField||textField==studentNameTextField||textField==studentSurnameTextField||textField==studentGroupTextField||textField==studentGroupTextField) {
        ActiveField = nil;
    }
}

#pragma Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
        if (self.noStudents) {
            return 1;
        }
        else {
            if (tableOfTargets==tableView) {
                return [[array_Of_Targets objectAtIndex:studentGroupIndex]count];
            }
            else {
                return [array_Of_Students_To_Transform count];
            }
        }
    }
    return [array_Of_Targets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Targets"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Targets"];
    }
    
    if (self.noStudents) {
        [cell.textLabel setText:@"No Students"];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        return cell;
    }
    
    NSString *teacher_Name = @"", *teacher_Surname = @"", *teacher_Full_Name = @"",
    *title_Target_Name = @"";
    if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
        if (!self.chooseStudentsToTranslate) {
            if ([[[array_Of_Targets objectAtIndex:studentGroupIndex]objectAtIndex:indexPath.row]objectForKey:@"Surname"]&&
                ![[[[array_Of_Targets objectAtIndex:studentGroupIndex] objectAtIndex:indexPath.row]objectForKey:@"Surname"]isEqualToString:@""]) {
                teacher_Surname = [[[[array_Of_Targets objectAtIndex:studentGroupIndex] objectAtIndex:indexPath.row]objectForKey:@"Surname"]capitalizedString];
            }
            if ([[[array_Of_Targets objectAtIndex:studentGroupIndex] objectAtIndex:indexPath.row]objectForKey:@"Name"]&&![[[[array_Of_Targets objectAtIndex:studentGroupIndex] objectAtIndex:indexPath.row]objectForKey:@"Name"]isEqualToString:@""]) {
                teacher_Name = [[[[array_Of_Targets objectAtIndex:studentGroupIndex] objectAtIndex:indexPath.row]objectForKey:@"Name"]capitalizedString];
            }
        } else {
            if ([[array_Of_Students_To_Transform objectAtIndex:indexPath.row]objectForKey:@"Surname"]&&
                ![[[array_Of_Students_To_Transform objectAtIndex:indexPath.row]objectForKey:@"Surname"]isEqualToString:@""]) {
                teacher_Surname = [[[array_Of_Students_To_Transform objectAtIndex:indexPath.row]objectForKey:@"Surname"]capitalizedString];
            }
            if ([[array_Of_Students_To_Transform objectAtIndex:indexPath.row]objectForKey:@"Name"]&&![[[array_Of_Students_To_Transform objectAtIndex:indexPath.row]objectForKey:@"Name"]isEqualToString:@""]) {
                teacher_Name = [[[array_Of_Students_To_Transform objectAtIndex:indexPath.row]objectForKey:@"Name"]capitalizedString];
            }
        }
    }
    else {
        if ([[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Surname"]&&
            ![[[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Surname"]isEqualToString:@""]) {
            teacher_Surname = [[[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Surname"]capitalizedString];
        }
        if ([[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Name"]&&
            ![[[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Name"]isEqualToString:@""]) {
            teacher_Name = [[[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Name"]capitalizedString];
        }
    }
    
    if (![teacher_Name isEqualToString:@""]&&![teacher_Surname isEqualToString:@""]) {
        teacher_Full_Name = [NSString stringWithFormat:@"%@ %@",teacher_Surname,teacher_Name];
    }
    else if (![teacher_Name isEqualToString:@""]&&[teacher_Surname isEqualToString:@""]) {
        teacher_Full_Name = teacher_Name;
    }
    else if ([teacher_Name isEqualToString:@""]&&![teacher_Surname isEqualToString:@""]) {
        teacher_Full_Name = teacher_Surname;
    }
    
    if (![teacher_Full_Name isEqualToString:@""]) {
        title_Target_Name = teacher_Full_Name;
    }
    
    if ([tableOfTargetsTitleName isEqualToString:@"Year"]) {
        [cell.textLabel setText:[[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:tableOfTargetsTitleName]];
    }
    else if ([tableOfTargetsTitleName isEqualToString:@"Lessons"]) {
        [cell.textLabel setText:[[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Lesson"]];
    }
    else {
        [cell.textLabel setText:title_Target_Name];
    }
    if (!self.transferAllStudentsToAnotherGroupIsShown) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
        if (tableView==choiceFromStudentGroup) {
            return [array_Of_Groups objectAtIndex:self.changingStudentGroupIndex];
        }
        if (!self.noStudents) {
            return [array_Of_Groups objectAtIndex:studentGroupIndex];
        }
        else {
            return [arrayOfAllGroups objectAtIndex:studentGroupIndex];
        }
    }
        return tableOfTargetsTitleName;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (deleteButtonClicked||self.multipleChoiceOfStudentsBegin) {
        if (tableView==tableOfTargets) {
            if ([[tableOfTargets indexPathsForSelectedRows]count]==0) {
                [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:NO];
            }
            else {
                [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
            }
        }
    }
}

-(NSString*)formatLessonDurationBeforeUpdate:(NSString*)text {
    int counter = 0;
    int lastDecimalIndex = 0;
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
    text = [NSString stringWithFormat:@"%i:%i %i:%i",currentBeginningHour,currentBeginningMinutes,currentFinishingHour,currentFinishingMinutes];
    return text;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (deleteButtonClicked||self.multipleChoiceOfStudentsBegin) {
            if (tableView==tableOfTargets) {
                if ([[tableOfTargets indexPathsForSelectedRows]count]==0) {
                    [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:NO];
                }
                else {
                    [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
                }
            }
        }
        else if (!deleteButtonClicked&&!self.STUDENT_MODE&&!self.noStudents) {
            [tableOfTargets deselectRowAtIndexPath:indexPath animated:YES];
            addButtonClicked = NO;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            objectIndex = indexPath.row;
            [self.custom_Navigation_Bar.topItem setLeftBarButtonItem:backButtonOfCalledViews];
            [self.custom_Navigation_Bar.topItem setRightBarButtonItem:saveButton];
            if ([tableOfTargetsTitleName isEqualToString:@"Year"]) {
                [editor_Mode_For_Lessons_Duration setContentOffset:CGPointMake(0, 0) animated:NO];
                [editor_Mode_For_Lessons_Duration setHidden:NO];
                [backButtonOfCalledViews setTitle:@"Back to Lessons Durations"];
                [custom_Navigation_Bar.topItem setTitle:[NSString stringWithFormat:@"%@ %@",[cell.textLabel text],tableOfTargetsTitleName]];
                
                NSString *firstLesson = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"First"],
                *secondLesson = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"Second"],
                *thirdLesson = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"Third"],
                *fourthLesson = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"Fourth"],
                *fifthLesson = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"Fifth"],
                *sixthLesson = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"Sixth"],
                *seventhLesson = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"Seventh"],
                *eighthLesson = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"Eighth"],
                *lunch = [[array_Of_Targets objectAtIndex:objectIndex]objectForKey:@"Lunch"];
                if (firstLesson) {
                    if (![firstLesson isEqualToString:@""]) {
                        firstLesson=[self formatLessonDurationBeforeUpdate:firstLesson];
                    }
                    [firstLessonDurationTextField setText:firstLesson];
                }
                else {
                    [firstLessonDurationTextField setText:@""];
                }
                if (secondLesson) {
                    if (![secondLesson isEqualToString:@""]) {
                        secondLesson=[self formatLessonDurationBeforeUpdate:secondLesson];
                    }
                    [secondLessonDurationTextField setText:secondLesson];
                }
                else {
                    [secondLessonDurationTextField setText:@""];
                }
                if (thirdLesson) {
                    if (![thirdLesson isEqualToString:@""]) {
                        thirdLesson=[self formatLessonDurationBeforeUpdate:thirdLesson];
                    }
                    [thirdLessonDurationTextField setText:thirdLesson];
                }
                else {
                    [thirdLessonDurationTextField setText:@""];
                }
                if (fourthLesson) {
                    if (![fourthLesson isEqualToString:@""]) {
                        fourthLesson=[self formatLessonDurationBeforeUpdate:fourthLesson];
                    }
                    [fourthLessonDurationTextField setText:fourthLesson];
                }
                else {
                    [fourthLessonDurationTextField setText:@""];
                }
                if (fifthLesson) {
                    if (![fifthLesson isEqualToString:@""]) {
                        fifthLesson=[self formatLessonDurationBeforeUpdate:fifthLesson];
                    }
                    [fifthLessonDurationTextField setText:fifthLesson];
                }
                else {
                    [fifthLessonDurationTextField setText:@""];
                }
                if (sixthLesson) {
                    if (![sixthLesson isEqualToString:@""]) {
                        sixthLesson=[self formatLessonDurationBeforeUpdate:sixthLesson];
                    }
                    [sixthLessonDurationTextField setText:sixthLesson];
                }
                else {
                    [sixthLessonDurationTextField setText:@""];
                }
                if (seventhLesson) {
                    if (![seventhLesson isEqualToString:@""]) {
                        seventhLesson=[self formatLessonDurationBeforeUpdate:seventhLesson];
                    }
                    [seventhLessonDurationTextField setText:seventhLesson];
                }
                else {
                    [seventhLessonDurationTextField setText:@""];
                }
                if (eighthLesson) {
                    if (![eighthLesson isEqualToString:@""]) {
                        eighthLesson=[self formatLessonDurationBeforeUpdate:eighthLesson];
                    }
                    [eighthLessonDurationTextField setText:eighthLesson];
                }
                else {
                    [eighthLessonDurationTextField setText:@""];
                }
                if (lunch) {
                    if (![lunch isEqualToString:@""]) {
                        lunch=[self formatLessonDurationBeforeUpdate:lunch];
                    }
                    [lunchTimeDurationTextField setText:lunch];
                }
                else {
                    [lunchTimeDurationTextField setText:@""];
                }
            }
            else if ([tableOfTargetsTitleName isEqualToString:@"Lessons"]) {
                [editor_Mode_For_Lessons setHidden:NO];
                NSString *lessonNameFromKey = [[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Lesson"];
                if (lessonNameFromKey) {
                    [lessonNameTextField setText:lessonNameFromKey];
                }
                else {
                    [lessonNameTextField setText:@""];
                }
            }
            else if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
                self.studentEditorModeIsShown = YES;
                [custom_Navigation_Bar.topItem setTitle:[[[array_Of_Targets objectAtIndex:studentGroupIndex]objectAtIndex:objectIndex]objectForKey:tableOfTargetsTitleName]];
                [editor_Mode_For_Students setContentOffset:CGPointMake(0, 0) animated:NO];
                [editor_Mode_For_Students setHidden:NO];
                NSString *studentNameFromKey = [[[array_Of_Targets objectAtIndex:studentGroupIndex] objectAtIndex:objectIndex]objectForKey:@"Name"], *studentSurnameFromKey = [[[array_Of_Targets objectAtIndex:studentGroupIndex]objectAtIndex:objectIndex]objectForKey:@"Surname"], *studentGroupFromKey = [array_Of_Groups objectAtIndex:studentGroupIndex];
                if (studentNameFromKey) {
                    [studentNameTextField setText:studentNameFromKey];
                }
                else {
                    [studentNameTextField setText:@""];
                }
                if (studentSurnameFromKey) {
                    [studentSurnameTextField setText:studentSurnameFromKey];
                }
                else {
                    [studentSurnameTextField setText:@""];
                }
                if (studentGroupFromKey) {
                    [studentGroupTextField setText:studentGroupFromKey];
                }
            }
            else if ([tableOfTargetsTitleName isEqualToString:@"Teachers"]) {
                [editor_Mode_For_Teachers setContentOffset:CGPointMake(0, 0) animated:NO];
                [editor_Mode_For_Teachers setHidden:NO];
                NSString *teacherNameFromKey = [[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Name"], *teacherSurnameFromKey = [[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Surname"],*teacherClassNameFromKey = [[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"ClassName"],*teacherEmailFromKey = [[array_Of_Targets objectAtIndex:indexPath.row]objectForKey:@"Email"];
                if (teacherNameFromKey) {
                    [teacherNameTextField setText:teacherNameFromKey];
                }
                else {
                    [teacherNameTextField setText:@""];
                }
                if (teacherSurnameFromKey) {
                    [teacherSurnameTextField setText:teacherSurnameFromKey];
                }
                else {
                    [teacherSurnameTextField setText:@""];
                }
                if (teacherEmailFromKey) {
                    [teacherEmailTextField setText:teacherEmailFromKey];
                }
                else {
                    [teacherEmailTextField setText:@""];
                }
                if (teacherClassNameFromKey) {
                    [fixedClassNameLabel setText:teacherClassNameFromKey];
                }
                else {
                    [fixedClassNameLabel setText:@""];
                }
            }
            if (![tableOfTargetsTitleName isEqualToString:@"Year"]) {
                [backButtonOfCalledViews setTitle:[NSString stringWithFormat:@"Back to %@",tableOfTargetsTitleName]];
                [custom_Navigation_Bar.topItem setTitle:[cell.textLabel text]];
            }
        }
}

-(void)dismissTargetTableView {
    if (self.transferAllStudentsToAnotherGroupIsShown) {
        self.transferAllStudentsToAnotherGroupIsShown = NO;
        [hiddenTextFieldForStudentsGroup removeFromSuperview];
    }
    if (self.STUDENT_MODE) {
        [self doneWithStudentGroupChoice];
    }
    if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
        [self.editSegment setFrame:CGRectMake(0, 0, 100, 29)];
    }
    [self.custom_Navigation_Bar.topItem setRightBarButtonItem:nil];
    [self.custom_Navigation_Bar.topItem setLeftBarButtonItem:backButton];
    [tableOfTargets setHidden:YES];
    [self.chooseQuery1 cancel];
    [self.chooseQuery2 cancel];
    [self.main_Query cancel];
    [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
    [self remove_Download_Signs];
}
                  
-(void)dismissCalledViews {
    [self.main_Query cancel];
    [self dismiss_Keyboards];
    [custom_Navigation_Bar.topItem setTitle:[self.defaults objectForKey:@"FullTargetName"]];
    [custom_Navigation_Bar.topItem setRightBarButtonItem:editOptions];
    [self.custom_Navigation_Bar.topItem setLeftBarButtonItem:backToEditing];
    if ([tableOfTargetsTitleName isEqualToString:@"Year"]) {
        [firstLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [secondLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [thirdLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [fourthLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [fifthLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [sixthLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [seventhLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [eighthLessonDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [lunchTimeDurationTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.custom_Navigation_Bar.topItem setRightBarButtonItem:nil];
        addButtonClicked = NO;
        [editor_Mode_For_Lessons_Duration setHidden:YES];
        [self makeQuery:@"LessonsDuration"];
    }
    else if ([tableOfTargetsTitleName isEqualToString:@"Lessons"]) {
        [lessonNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        addButtonClicked = YES;
        [editor_Mode_For_Lessons setHidden:YES];
        [self makeQuery:tableOfTargetsTitleName];
    }
    else if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
        self.studentEditorModeIsShown = NO;
        addButtonClicked = YES;
        [editor_Mode_For_Students setHidden:YES];
        [self makeQuery:tableOfTargetsTitleName];
    }
    else if ([tableOfTargetsTitleName isEqualToString:@"Teachers"]) {
        addButtonClicked = YES;
        [teacherNameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [teacherSurnameTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [teacherEmailTextField setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [editor_Mode_For_Teachers setHidden:YES];
        [self makeQuery:tableOfTargetsTitleName];
    }
    [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:NO];
}

-(void) makeQuery:(NSString*)query {
    [self create_Download_Signs];
    self.main_Query = [PFQuery queryWithClassName:query];
    if ([tableOfTargetsTitleName isEqualToString:@"Year"]) {
        [self.main_Query orderByAscending:@"Year"];
    }
    else {
        self.main_Query.limit = 5000;
        [self.main_Query orderByDescending:@"createdAt"];
    }
    [self.main_Query findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
        if (!error) {
            array_Of_Targets = [NSMutableArray arrayWithArray:list];
            if (self.transferAllStudentsToAnotherGroupIsShown) {
                [custom_Navigation_Bar.topItem.rightBarButtonItem setEnabled:YES];
                [custom_Navigation_Bar.topItem setRightBarButtonItem:saveButton];
                [custom_Navigation_Bar.topItem setLeftBarButtonItem:self.backToStudents];
                if (![tableOfTargets isHidden]) {
                    [tableOfTargets setHidden:YES];
                }
                [choiceFromStudentGroup setHidden:NO];
                if ([list count]!=0) {
                    array_Of_Targets = [self sortArrayOfStudents:array_Of_Targets];
                }
                
                array_Of_Students_To_Transform = [NSMutableArray new];
                
                for (NSIndexPath *indexPath in [tableOfTargets indexPathsForSelectedRows]) {
                    [array_Of_Students_To_Transform addObject:[[array_Of_Targets objectAtIndex:studentGroupIndex]objectAtIndex:indexPath.row]];
                }
                
                [student_Group_Picker reloadAllComponents];
                hiddenTextFieldForStudentsGroup = [[UITextField alloc]init];
                [self.view addSubview:hiddenTextFieldForStudentsGroup];
                [hiddenTextFieldForStudentsGroup setInputView:student_Group_Picker];
                [hiddenTextFieldForStudentsGroup becomeFirstResponder];
            }
            else {
                if (![choiceFromStudentGroup isHidden]) {
                    [choiceFromStudentGroup setHidden:YES];
                }
                [self.custom_Navigation_Bar.topItem setLeftBarButtonItem:backToEditing];
                [tableOfTargets setHidden:NO];
                if ([tableOfTargetsTitleName isEqualToString:@"Lessons"]) {
                    for (int i=0;i<[array_Of_Targets count];i++) {
                        NSString *object = [[array_Of_Targets objectAtIndex:i]objectForKey:@"Lesson"];
                        if ([object rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location!= NSNotFound) {
                            [array_Of_Targets removeObjectAtIndex:i];
                            i--;
                        }
                    }
                }
                if (addButtonClicked) {
                    [custom_Navigation_Bar.topItem setRightBarButtonItem:editOptions];
                    if ([tableOfTargetsTitleName isEqualToString:@"Students"]) {
                        array_Of_Groups = [NSMutableArray new];
                        if ([self.editSegment numberOfSegments]==2) {
                            [self.editSegment insertSegmentWithImage:[UIImage imageNamed:@"Groups.png"] atIndex:2 animated:NO];
                            [self.editSegment insertSegmentWithImage:[UIImage imageNamed:@"EditorModeSettings.png"] atIndex:3 animated:NO];
                        }
                        if ([list count]!=0) {
                            array_Of_Targets = [self sortArrayOfStudents:array_Of_Targets];
                            [self.editSegment setEnabled:YES forSegmentAtIndex:0];
                            [self.editSegment setEnabled:YES forSegmentAtIndex:3];
                        }
                        else {
                            [self.editSegment setEnabled:NO forSegmentAtIndex:0];
                            [self.editSegment setEnabled:NO forSegmentAtIndex:3];
                        }
                    }
                    else {
                        
                        if ([self.editSegment numberOfSegments]==4) {
                            [self.editSegment removeSegmentAtIndex:3 animated:NO];
                            [self.editSegment removeSegmentAtIndex:2 animated:NO];
                        }
                    }
                    if ([list count]==0) {
                        [self.editSegment setEnabled:NO forSegmentAtIndex:0];
                    }
                }
                else {
                    [tableOfTargets setHidden:NO];
                    [custom_Navigation_Bar.topItem setRightBarButtonItem:nil];
                }
            }
            if (self.transferAllStudentsToAnotherGroupIsShown) {
                [choiceFromStudentGroup reloadData];
            }
            else {
                [tableOfTargets reloadData];
            }
            [self remove_Download_Signs];
        }
        else {
            [self show_Alert];
            [self dismissTargetTableView];
        }
    }];
}

-(NSMutableArray*)sortArrayOfStudents:(NSMutableArray*)array {
    for (int i=0;i<[array count];i++) {
        [array_Of_Groups addObject:[[array objectAtIndex:i]objectForKey:@"Group"]];
    }
    NSSet *unique_set = [[NSSet alloc]initWithArray:array_Of_Groups];
    array_Of_Groups = [[unique_set allObjects]mutableCopy];
    NSMutableArray *arrayOfUnsortedStudents = [NSMutableArray new];
    NSMutableArray *arrayOfUnsortedStudentsInOneGroup = [NSMutableArray new];
    for (int j=0;j<[array_Of_Groups count];j++) {
        for (int i=0;i<[array_Of_Targets count];i++) {
            if ([[[array_Of_Targets objectAtIndex:i]objectForKey:@"Group"]isEqualToString:[array_Of_Groups objectAtIndex:j]]) {
                [arrayOfUnsortedStudentsInOneGroup addObject:[array_Of_Targets objectAtIndex:i]];
            }
        }
        [arrayOfUnsortedStudents addObject:arrayOfUnsortedStudentsInOneGroup];
        arrayOfUnsortedStudentsInOneGroup = [NSMutableArray new];
    }
    array = [NSMutableArray arrayWithArray:arrayOfUnsortedStudents];
    arrayOfUnsortedStudents = [NSMutableArray new];
    if (!self.transferAllStudentsToAnotherGroupIsShown) {
        studentGroupIndex = 0;
    }
    return array;
}

- (IBAction)EditStudentsList:(id)sender {
    [self.editSegment setFrame:CGRectMake(0, 0, 200, 29)];
    tableOfTargetsTitleName = @"Students";
    addButtonClicked = YES;
    [self makeQuery:tableOfTargetsTitleName];
}

- (IBAction)EditTeachersList:(id)sender {
    tableOfTargetsTitleName = @"Teachers";
    addButtonClicked = YES;
    [self makeQuery:tableOfTargetsTitleName];
}

- (IBAction)EditLessonsList:(id)sender {
    tableOfTargetsTitleName = @"Lessons";
    addButtonClicked = YES;
    [self makeQuery:tableOfTargetsTitleName];
}

- (IBAction)EditLessonsDuration:(id)sender {
    tableOfTargetsTitleName = @"Year";
    addButtonClicked = NO;
    [self makeQuery:@"LessonsDuration"];
}

- (IBAction)Duplicate:(id)sender {
    [self showWarning:[NSString stringWithFormat:@"Are you sure you want to replace values of %@ with %@?",
                       parallelGroup,[custom_Navigation_Bar.topItem title]]];
    self.typeDuplication = YES;
}

- (IBAction)Delete:(id)sender {
    [self showWarning:[NSString stringWithFormat:@"Are you sure you want to delete all lessons of %@?",
                       [custom_Navigation_Bar.topItem title]]];
    self.typeDuplication = NO;
}

-(void)showWarning:(NSString*)string {
    self.warningAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:string delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [self.warningAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.warningAlert==alertView) {
        if (buttonIndex == 1) {
            [self create_Download_Signs];
            self.main_Query = [PFQuery queryWithClassName:nameOfReflectedClass];
            [self.main_Query orderByAscending:@"SubjectNumber"];
            [self.main_Query findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
                if (!error) {
                    if (self.typeDuplication) {
                        self.queryToGetClassForDuplication = [PFQuery queryWithClassName:formattedTitle];
                        [self.queryToGetClassForDuplication orderByAscending:@"SubjectNumber"];
                        [self.queryToGetClassForDuplication findObjectsInBackgroundWithBlock:^(NSArray *list1, NSError *error) {
                            if (!error) {
                                for (int i=0;i<[list count];i++) {
                                    for (NSString *day in days_titles) {
                                        PFObject *myObject = [list1 objectAtIndex:i];
                                        NSString *objectId = [myObject objectId];
                                        PFObject *updateObject = [PFObject objectWithoutDataWithClassName:formattedTitle objectId:objectId];
                                        NSString *object = [[list objectAtIndex:i]objectForKey:day];
                                        if (!object) {
                                            object = @"";
                                            PFObject *myInitialObject = [list objectAtIndex:i];
                                            NSString *initialObjectId = [myInitialObject objectId];
                                            PFObject *initialUpdateObject = [PFObject objectWithoutDataWithClassName:nameOfReflectedClass objectId:initialObjectId];
                                            [initialUpdateObject setObject:object forKey:day];
                                            [initialUpdateObject save];
                                        }
                                        [updateObject setObject:object forKey:day];
                                        [updateObject save];
                                    }
                                }
                                [self remove_Download_Signs];
                            }
                            else {
                                [self show_Alert];
                                [self remove_Download_Signs];
                            }
                        }];
                    }
                    else {
                        for (int i=0;i<[list count];i++) {
                            for (NSString *day in days_titles) {
                                PFObject *myObject = [list objectAtIndex:i];
                                NSString *objectId = [myObject objectId];
                                PFObject *updateObject = [PFObject objectWithoutDataWithClassName:nameOfReflectedClass objectId:objectId];
                                [updateObject setObject:@"" forKey:day];
                                [updateObject save];
                            }
                        }
                        [self remove_Download_Signs];
                    }
                }
                else {
                    [self show_Alert];
                    [self remove_Download_Signs];
                }
            }];
        }
    }
}

-(void)show_Alert {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"It seems like that there is no Internet Connection or you have improperly set the name for the class of a requested query, or smth wrong occured on the server, please check it out" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
@end
