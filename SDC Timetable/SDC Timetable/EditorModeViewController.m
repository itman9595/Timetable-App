//
//  EditorModeViewController.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/21/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "EditorModeViewController.h"
#import "EditorModeLogin.h"

@implementation EditorModeViewController
@synthesize custom_Navigation_Bar;
@synthesize editorModeScrollView;
@synthesize lessons, lessons_duration, array_Of_Targets;
@synthesize days_titles;
@synthesize cellEditorMode;
@synthesize editorTools;
@synthesize monday_Table_View,tuesday_Table_View,wednesday_Table_View,thursday_Table_View,friday_Table_View, table_Of_Targets;
@synthesize dimmed_View, activityIndicatorView;
@synthesize saveButton, cancelButton, backButton;
@synthesize lessons_Are_Ready_To_Update;
@synthesize selectedCells, selectedCellsIndexPaths, selectedCellsDays, selectedCellsObjectIds, indexesForParentObjectIds;
@synthesize cellToUpdate;
@synthesize targetName, fullTargetName, title_Target_Name;
@synthesize currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes;
@synthesize lunchTimeIndex, lessonIndex, year;
@synthesize arrayOfLessonsDurations;

-(void)viewWillDisappear:(BOOL)animated {
    [self.query cancel];
    [self.queryToUpdate cancel];
    [self.chooseQuery1 cancel];
    [self.chooseQuery2 cancel];
    [self.queryForTeachers cancel];
}

- (void)viewDidLayoutSubviews {
    [editorModeScrollView setContentSize:CGSizeMake(monday_Table_View.frame.size.width+tuesday_Table_View.frame.size.width+wednesday_Table_View.frame.size.width+thursday_Table_View.frame.size.width+friday_Table_View.frame.size.width,monday_Table_View.frame.size.height)];
}

-(void)viewDidAppear:(BOOL)animated {
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] <= 7) {
        table_Of_Targets = [[UITableView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.height, self.view.frame.size.width-(custom_Navigation_Bar.frame.size.height+20))style:UITableViewStylePlain];
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            table_Of_Targets = [[UITableView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-custom_Navigation_Bar.frame.size.height)style:UITableViewStylePlain];
        }
        else {
            table_Of_Targets = [[UITableView alloc]initWithFrame:CGRectMake(0, custom_Navigation_Bar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(custom_Navigation_Bar.frame.size.height+20))style:UITableViewStylePlain];
        }
    }
    [table_Of_Targets setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:table_Of_Targets];
    [table_Of_Targets setDelegate:self];
    [table_Of_Targets setDataSource:self];
    [table_Of_Targets setHidden:YES];
    [editorTools setEnabled:NO forSegmentAtIndex:2];
    [self showTargets];
}

-(void)valuesAreUpdated {
    [cellToUpdate setSelected:NO];
    [cellToUpdate setBackgroundColor:[UIColor whiteColor]];
    cellToUpdate = nil;
    for (EditorModeTableViewCell *cell in selectedCells) {
        [cell setSelected:NO];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    [custom_Navigation_Bar setUserInteractionEnabled:YES];
    [self cancelSave];
}

-(void)returnColorToCells {
    if (cellToUpdate&&[selectedCells count]!=0) {
        [self create_Download_Signs];
        [custom_Navigation_Bar setUserInteractionEnabled:NO];
        __block NSString *cellText = [cellToUpdate.lesson text], *teacherName = [cellToUpdate.lesson text];
        int commasCount = 0;
        int indexOfLastComma = 0;
        for (int i=0;i<[teacherName length];i++) {
            if ([teacherName characterAtIndex:i]==',') {
                commasCount++;
                if (commasCount == 1) {
                    self.copied_Lesson_Name = [teacherName substringWithRange:NSMakeRange(0, i)];
                    indexOfLastComma = i+1;
                }
                else {
                    teacherName = [teacherName substringWithRange:NSMakeRange(indexOfLastComma, i-indexOfLastComma)];
                    break;
                }
            }
            else if(commasCount==1&&[teacherName length]-1==i) {
                teacherName =[teacherName substringWithRange:NSMakeRange(indexOfLastComma, i-indexOfLastComma+1)];
                break;
            }
        }
        
        if (teacherName&&![teacherName isEqualToString:@""]) {
            if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Teacher"]) {
                NSString *lesson = teacherName;
                teacherName = self.copied_Lesson_Name;
                self.copied_Lesson_Name = lesson;
                teacherName = [[teacherName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]componentsJoinedByString:@""];
                [self multipleSaveBegins:teacherName cellText:cellText];
            }
            else {
                self.queryForTeachers = [PFQuery queryWithClassName:@"Teachers"];
                [self.queryForTeachers orderByAscending:@"updatedAt"];
                [self.queryForTeachers findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
                    if (!error) {
                        for (int i=0;i<[list count];i++) {
                            if ([[[NSString stringWithFormat:@"%@ %@",[[list objectAtIndex:i]objectForKey:@"Surname"],[[list objectAtIndex:i]objectForKey:@"Name"]]capitalizedString]isEqualToString:[teacherName capitalizedString]]) {
                                NSString *groupClassName = [[list objectAtIndex:i]objectForKey:@"ClassName"];
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
                                if (![groupClassName isEqualToString:@""]) {
                                    teacherName = [[list objectAtIndex:i]objectForKey:@"ClassName"];
                                    [self multipleSaveBegins:teacherName cellText:cellText];
                                }
                                else {
                                    [self showAlert];
                                    [self valuesAreUpdated];
                                }
                                break;
                            }
                        }
                    }
                    else {
                        [self showAlert];
                        [self valuesAreUpdated];
                    }
                }];
            }
        }
        else {
            [self showAlert];
            [self valuesAreUpdated];
        }
    }
}

-(void)multipleSaveBegins:(NSString*)mainQuery cellText:(NSString*)cellText{
    self.queryToUpdate = [PFQuery queryWithClassName:mainQuery];
    [self.queryToUpdate orderByAscending:@"SubjectNumber"];
    [self.queryToUpdate findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
        if (!error) {
            int index = 0;
            for (EditorModeTableViewCell *cell in selectedCells) {
                PFObject *updateObject = [PFObject objectWithoutDataWithClassName:targetName objectId:[selectedCellsObjectIds objectAtIndex:index]];
                PFObject *updateParentObject = [list objectAtIndex:[[indexesForParentObjectIds objectAtIndex:index]integerValue]];
                NSString *parentObjectId = [updateParentObject objectId];
                updateParentObject = [PFObject objectWithoutDataWithClassName:mainQuery
                                                                          objectId:parentObjectId];
                [updateObject setObject:cellText forKey:[selectedCellsDays objectAtIndex:index]];
                if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Student"]) {
                    [updateParentObject setObject:[NSString stringWithFormat:@"%@,%@",fullTargetName,self.copied_Lesson_Name] forKey:[selectedCellsDays objectAtIndex:index]];
                }
                else {
                    [updateParentObject setObject:[NSString stringWithFormat:@"%@,%@",self.copied_Lesson_Name,fullTargetName] forKey:[selectedCellsDays objectAtIndex:index]];
                }
                [updateObject save];
                [updateParentObject save];
                [cell.lesson setText:cellText];
                [cell setSelected:NO];
                [cell setBackgroundColor:[UIColor whiteColor]];
                index++;
            }
            
            PFObject *originalCell = [PFObject objectWithoutDataWithClassName:targetName objectId:self.cellToUpdateObjectId];
            PFObject *originalCellParent = [list objectAtIndex:self.cellToUpdateIndex];
            NSString *parentObjectId = [originalCellParent objectId];
            originalCellParent = [PFObject objectWithoutDataWithClassName:mainQuery
                                                                 objectId:parentObjectId];
            [originalCell setObject:cellText forKey:self.cellToUpdateTableViewDay];
            if ([[self.defaults objectForKey:@"UpdateType"]isEqualToString:@"Student"]) {
                [originalCellParent setObject:[NSString stringWithFormat:@"%@,%@",fullTargetName,self.copied_Lesson_Name] forKey:self.cellToUpdateTableViewDay];
            }
            else {
                [originalCellParent setObject:[NSString stringWithFormat:@"%@,%@",self.copied_Lesson_Name,fullTargetName] forKey:self.cellToUpdateTableViewDay];
            }
            [originalCell save];
            [originalCellParent save];
            [self valuesAreUpdated];
        }
        else {
            [self showAlert];
            [self valuesAreUpdated];
        }
    }];
}

-(void)multipleSave {
    [self returnColorToCells];
}

-(void)cancelSave {
    for (EditorModeTableViewCell *cell in selectedCells) {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    [selectedCells removeAllObjects];
    [selectedCellsIndexPaths removeAllObjects];
    [selectedCellsDays removeAllObjects];
    [selectedCellsObjectIds removeAllObjects];
    [indexesForParentObjectIds removeAllObjects];
    [cellToUpdate setBackgroundColor:[UIColor whiteColor]];
    cellToUpdate = nil;
    [custom_Navigation_Bar.topItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:editorTools]];
    [custom_Navigation_Bar.topItem setLeftBarButtonItem:backButton];
    self.chooseLesson = NO;
    lessons_Are_Ready_To_Update = NO;
    [custom_Navigation_Bar.topItem setTitle:fullTargetName];
    [self remove_Download_Signs];
}

-(void)goBackToLogin {
    EditorModeLogin *editor_Mode_Login =
    [self.storyboard instantiateViewControllerWithIdentifier:
     @"EditorModeLogin"];
    [self presentViewController:editor_Mode_Login animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(multipleSave)];
    cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSave)];
    editorTools = [[UISegmentedControl alloc]initWithItems:@[[UIImage imageNamed:@"ChooseTarget.png"],[UIImage imageNamed:@"SaveToCloud.png"],[UIImage imageNamed:@"EditorModeSettings.png"]]];
    [editorTools setTintColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
    [editorTools addTarget:self action:@selector(editorToolsClick:) forControlEvents:UIControlEventValueChanged];
    backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBackToLogin)];
    [backButton setTintColor:[UIColor redColor]];
    [custom_Navigation_Bar.topItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:editorTools]];
    [custom_Navigation_Bar.topItem setLeftBarButtonItem:backButton];
    cellEditorMode = [self.storyboard instantiateViewControllerWithIdentifier:
     @"CellEditorMode"];
    self.defaults = [NSUserDefaults standardUserDefaults];
    days_titles = [[NSArray alloc]initWithObjects:
                   @"MONDAY",@"TUESDAY",@"WEDNESDAY",@"THURSDAY",@"FRIDAY", nil];
    lessons_duration = [NSMutableArray new];
    for (int i=0;i<9;i++) {
        [lessons_duration addObject:@"00:00\n00:00"];
    }
    [monday_Table_View setDelegate:self];
    [monday_Table_View setDataSource:self];
    [tuesday_Table_View setDelegate:self];
    [tuesday_Table_View setDataSource:self];
    [wednesday_Table_View setDelegate:self];
    [wednesday_Table_View setDataSource:self];
    [thursday_Table_View setDelegate:self];
    [thursday_Table_View setDataSource:self];
    [friday_Table_View setDelegate:self];
    [friday_Table_View setDataSource:self];
}

-(void)create_Download_Signs {
    [editorModeScrollView setUserInteractionEnabled:NO];
    [editorTools setUserInteractionEnabled:NO];
    dimmed_View = [[UIView alloc]init];
    [dimmed_View setBackgroundColor:[UIColor blackColor]];
    [dimmed_View setAlpha:0.5];
    [dimmed_View.layer setMasksToBounds:YES];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [dimmed_View setFrame:[table_Of_Targets frame]];
    activityIndicatorView.center = CGPointMake(dimmed_View.frame.size.width / 2, (dimmed_View.frame.size.height / 2)+activityIndicatorView.frame.size.height);
    [self.view addSubview:dimmed_View];
    [self.view addSubview:activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

-(void)remove_Download_Signs {
    [editorModeScrollView setUserInteractionEnabled:YES];
    [editorTools setUserInteractionEnabled:YES];
    [activityIndicatorView removeFromSuperview];
    [dimmed_View removeFromSuperview];
}

-(void)control_Custom_Navigation_Bar:(BOOL)custom_Navigation_Bar_User_Interaction editorTools:(BOOL)editor_Tools_User_Interaction {
    [custom_Navigation_Bar setUserInteractionEnabled:custom_Navigation_Bar_User_Interaction];
    [editorTools setUserInteractionEnabled:editor_Tools_User_Interaction];
}

-(void)sort_array_Of_Targets {
    for (int i=0;i<[array_Of_Targets count];i++) {
        for (int j=0;j<[[array_Of_Targets objectAtIndex:i]count];j++) {
            if (self.teachers_Are_Shown) {
                int index = 0;
                if (self.groups_Are_Shown) {
                    index = 1;
                }
                if (index == i) {
                    NSString *teacherClassName = [[[array_Of_Targets objectAtIndex:index]objectAtIndex:j]objectForKey:@"ClassName"];
                    NSString *teacherName = [[[array_Of_Targets objectAtIndex:index]objectAtIndex:j]objectForKey:@"Name"];
                    NSString *teacherSurname = [[[array_Of_Targets objectAtIndex:index]objectAtIndex:j]objectForKey:@"Surname"];
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
                    
                    if([teacherClassName isEqualToString:@""]||(([teacherName isEqualToString:@""])&&([teacherSurname isEqualToString:@""]))){
                        [[array_Of_Targets objectAtIndex:index]removeObjectAtIndex:j];
                        j--;
                    }
                }
                else {
                    break;
                }
            }
        }
    }
}

-(void)showTeachers {
    self.chooseQuery2 = [PFQuery queryWithClassName:@"Teachers"];
    [self.chooseQuery2 orderByDescending:@"updatedAt"];
    [self.chooseQuery2 findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
        NSString *target = @"";
        if (!error) {
            [array_Of_Targets addObject:list];
            [self control_Custom_Navigation_Bar:YES editorTools:YES];
            [self remove_Download_Signs];
            [self sort_array_Of_Targets];
            target = [self.defaults objectForKey:@"TargetName"];
            if (target&&![target isEqualToString:@""]) {
                [self hideTableAndLoadData:target];
            }
            else {
                [editorTools setEnabled:YES forSegmentAtIndex:0];
                [editorTools setEnabled:NO forSegmentAtIndex:1];
                [editorModeScrollView setUserInteractionEnabled:NO];
                [table_Of_Targets setHidden:NO];
                self.table_Of_Targets_Is_Shown = YES;
                [table_Of_Targets reloadData];
            }
        }
        else {
            if (!self.teachers_Are_Shown) {
                [self showAlert];
                self.table_Of_Targets_Is_Shown = NO;
            }
            else {
                [self sort_array_Of_Targets];
                target = [self.defaults objectForKey:@"TargetName"];
                if (target&&![target isEqualToString:@""]) {
                    [self hideTableAndLoadData:target];
                }
                else {
                    [editorTools setEnabled:YES forSegmentAtIndex:0];
                    [editorTools setEnabled:NO forSegmentAtIndex:1];
                    [editorModeScrollView setUserInteractionEnabled:NO];
                    [table_Of_Targets setHidden:NO];
                    self.table_Of_Targets_Is_Shown = YES;
                    [table_Of_Targets reloadData];
                }
            }
            [self control_Custom_Navigation_Bar:YES editorTools:YES];
            [self remove_Download_Signs];
        }
    }];
}

-(void)dismissTargetTableView {
    if (![[custom_Navigation_Bar.topItem title]isEqualToString:@"Empty Timetable"]) {
        [editorTools setEnabled:YES forSegmentAtIndex:1];
        [editorTools setEnabled:YES forSegmentAtIndex:2];
        [editorModeScrollView setUserInteractionEnabled:YES];
    }
    [editorTools setEnabled:YES forSegmentAtIndex:0];
    [table_Of_Targets setHidden:YES];
    self.teachers_Are_Shown = NO;
    self.groups_Are_Shown = NO;
    self.table_Of_Targets_Is_Shown = NO;
    [self.chooseQuery1 cancel];
    [self.chooseQuery2 cancel];
}

-(void)showTargets {
    [editorTools setEnabled:NO forSegmentAtIndex:0];
    [editorTools setEnabled:NO forSegmentAtIndex:1];
    [editorTools setEnabled:NO forSegmentAtIndex:2];
    [editorModeScrollView setUserInteractionEnabled:NO];
    if (!self.table_Of_Targets_Is_Shown) {
        [self create_Download_Signs];
        array_Of_Targets = [NSMutableArray new];
        [self control_Custom_Navigation_Bar:NO editorTools:NO];
        self.chooseQuery1 = [PFQuery queryWithClassName:@"Groups"];
        [self.chooseQuery1 findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                self.teachers_Are_Shown = YES;
                [array_Of_Targets addObject:list];
                self.groups_Are_Shown = YES;
                [self showTeachers];
            }
            else {
                self.teachers_Are_Shown = NO;
                self.groups_Are_Shown = NO;
                [self showTeachers];
            }
        }];
    }
    else {
        [self dismissTargetTableView];
    }
}

- (IBAction)editorToolsClick:(id)sender {
    UISegmentedControl *usedEditorToolButtons = (UISegmentedControl*)sender;
    if ([usedEditorToolButtons selectedSegmentIndex]==0) {
        [self.defaults setObject:nil forKey:@"TargetName"];
        [self showTargets];
    }
    else if ([usedEditorToolButtons selectedSegmentIndex]==1) {
        selectedCells = [NSMutableArray new];
        selectedCellsIndexPaths = [NSMutableArray new];
        selectedCellsDays = [NSMutableArray new];
        selectedCellsObjectIds = [NSMutableArray new];
        indexesForParentObjectIds = [NSMutableArray new];
        [custom_Navigation_Bar.topItem setTitle:@"Choose the lesson"];
        self.chooseLesson = YES;
        [custom_Navigation_Bar.topItem setRightBarButtonItem:nil];
        [custom_Navigation_Bar.topItem setLeftBarButtonItem:cancelButton];
    }
    else {
        EditorModeExtraOptions *extraOptions = [self.storyboard instantiateViewControllerWithIdentifier:@"EditorModeExtraOptions"];
        [self.defaults setObject:[self.custom_Navigation_Bar.topItem title] forKey:@"FullTargetName"];
        [self.defaults setObject:targetName forKey:@"TargetName"];
        [self presentViewController:extraOptions animated:YES completion:nil];
    }
    [usedEditorToolButtons setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == table_Of_Targets) {
        return [array_Of_Targets count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == table_Of_Targets) {
        return [[array_Of_Targets objectAtIndex:section]count];
    }
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == table_Of_Targets) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Targets"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Targets"];
        }
        
        NSString *teacher_Name = @"", *teacher_Surname = @"", *teacher_Full_Name = @"", *group_Name = @"";title_Target_Name = @"";
        if ([[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Surname"]&&
            ![[[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Surname"]isEqualToString:@""]) {
            teacher_Surname = [[[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Surname"]capitalizedString];
        }
        if ([[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Name"]&&
            ![[[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Name"]isEqualToString:@""]) {
            teacher_Name = [[[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Name"]capitalizedString];
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
        if ([[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Group"]&&
            ![[[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Group"]isEqualToString:@""]) {
            group_Name = [[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Group"];
        }
        
        if (self.teachers_Are_Shown) {
            if ([array_Of_Targets count]==1) {
                if (indexPath.section == 0) {
                    if (![teacher_Full_Name isEqualToString:@""]) {
                        title_Target_Name = teacher_Full_Name;
                    }
                }
            }
            else {
                if (indexPath.section == 0) {
                    if (![group_Name isEqualToString:@""]) {
                        title_Target_Name = group_Name;
                    }
                }
                else if (indexPath.section == 1) {
                    if (![teacher_Full_Name isEqualToString:@""]) {
                        title_Target_Name = teacher_Full_Name;
                    }
                }
            }
        }
        else {
            if ([array_Of_Targets count]==1) {
                if (indexPath.section == 0) {
                    if (![group_Name isEqualToString:@""]) {
                        title_Target_Name = group_Name;
                    }
                }
            }
        }
        [cell.textLabel setText:title_Target_Name];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    }
    EditorModeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Lesson"];
    NSUInteger row = indexPath.row;
    NSString *tableDate = [[days_titles objectAtIndex:0]capitalizedString];
    if (tableView == tuesday_Table_View) {
        tableDate = [[days_titles objectAtIndex:1]capitalizedString];
    }
    else if (tableView == wednesday_Table_View) {
        tableDate = [[days_titles objectAtIndex:2]capitalizedString];
    }
    else if (tableView == thursday_Table_View) {
        tableDate = [[days_titles objectAtIndex:3]capitalizedString];
    }
    else if (tableView == friday_Table_View) {
        tableDate = [[days_titles objectAtIndex:4]capitalizedString];
    }
    NSString *Given_lesson = @"";
    if (row+1<=[lessons count]) {
        if ([[lessons objectAtIndex:row]objectForKey:tableDate]) {
            Given_lesson = [[lessons objectAtIndex:row]objectForKey:tableDate];
        }
    }
    [cell.lesson setText:Given_lesson];
    [cell.number_of_lesson setText:[NSString stringWithFormat:@"%li",(long)(row+1)]];
    [cell.lesson_duration setText:[lessons_duration objectAtIndex:row]];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == monday_Table_View) {
        return [[days_titles objectAtIndex:0]capitalizedString];
    }
    if (tableView == tuesday_Table_View) {
        return [[days_titles objectAtIndex:1]capitalizedString];
    }
    if (tableView == wednesday_Table_View) {
        return [[days_titles objectAtIndex:2]capitalizedString];
    }
    if (tableView == thursday_Table_View) {
        return [[days_titles objectAtIndex:3]capitalizedString];
    }
    if (tableView == friday_Table_View) {
        return [[days_titles objectAtIndex:4]capitalizedString];
    }
    if (tableView == table_Of_Targets) {
        if (self.teachers_Are_Shown) {
            if ([array_Of_Targets count]==1) {
                if (section == 0) {
                    return @"Teachers";
                }
            }
            else {
                if (section == 0) {
                    return @"Groups";
                }
                else if (section == 1) {
                    return @"Teachers";
                }
            }
        }
        else {
            if ([array_Of_Targets count]==1) {
                if (section == 0) {
                    return @"Groups";
                }
            }
        }
    }
    return nil;
}

-(void)hideTableAndLoadData:(NSString*)target_Name {
    [self create_Download_Signs];
    self.query = [PFQuery queryWithClassName:target_Name];
    [self.query orderByAscending:@"SubjectNumber"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
        if (!error) {
            fullTargetName = [self.defaults objectForKey:@"FullTargetName"];
            if ([list count]==9) {
                self.query = [PFQuery queryWithClassName:@"LessonsDuration"];
                [self.query orderByAscending:@"Year"];
                [self.query findObjectsInBackgroundWithBlock:^(NSArray *listOfLessonsDurations, NSError *error) {
                    if (!error) {
                        if ([listOfLessonsDurations count]>=4) {
                            self.previous_full_Target_Name = fullTargetName;
                            targetName = target_Name;
                            self.previous_target_Name = targetName;
                            [custom_Navigation_Bar.topItem setTitle:fullTargetName];
                            lessons = [NSMutableArray arrayWithArray:list];
                            
                            year = 4;
                            if ([fullTargetName rangeOfString:@"1" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                year = 0;
                            }
                            else if ([fullTargetName rangeOfString:@"2" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                year = 1;
                            }
                            else if ([fullTargetName rangeOfString:@"3" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                year = 2;
                            }
                            else if ([fullTargetName rangeOfString:@"4" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                year = 3;
                            }
                            else {
                                lessons_duration = [NSMutableArray new];
                                for (int i=0;i<9;i++) {
                                    [lessons_duration addObject:@"00:00\n00:00"];
                                }
                            }
                            
                            if (year<4) {
                                
                                lunchTimeIndex = 0;
                                for (int i=0;i<[lessons count];i++) {
                                    if ([[[lessons objectAtIndex:i]objectForKey:@"Monday"] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location != NSNotFound||[[[lessons objectAtIndex:i]objectForKey:@"Monday"] rangeOfString:@"Bon appetit" options:NSCaseInsensitiveSearch].location != NSNotFound||[[[lessons objectAtIndex:i]objectForKey:@"Monday"] rangeOfString:@"Приятного аппетита" options:NSCaseInsensitiveSearch].location != NSNotFound||[[[lessons objectAtIndex:i]objectForKey:@"Monday"] rangeOfString:@"Afiyet olsun" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                        lunchTimeIndex = i;
                                        break;
                                    }
                                }
                                
                                arrayOfLessonsDurations = listOfLessonsDurations;
                                
                                NSString *lunch = [[arrayOfLessonsDurations objectAtIndex:year]
                                                          objectForKey:@"Lunch"];
                                if (lunch&&![lunch isEqualToString:@""]) {
                                    lunch = [self formatLessonDurationBeforeUpdate:lunch];
                                    [lessons_duration replaceObjectAtIndex:lunchTimeIndex withObject:lunch];
                                }
                                
                                lessonIndex = 0;
                                [self setLessonDuration:@"First"];
                                [self setLessonDuration:@"Second"];
                                [self setLessonDuration:@"Third"];
                                [self setLessonDuration:@"Fourth"];
                                [self setLessonDuration:@"Fifth"];
                                [self setLessonDuration:@"Sixth"];
                                [self setLessonDuration:@"Seventh"];
                                [self setLessonDuration:@"Eighth"];
                            }
                            
                            [monday_Table_View reloadData];
                            [tuesday_Table_View reloadData];
                            [wednesday_Table_View reloadData];
                            [thursday_Table_View reloadData];
                            [friday_Table_View reloadData];
                            [self dismissTargetTableView];
                            [self remove_Download_Signs];
                            [editorTools setEnabled:YES forSegmentAtIndex:2];
                            [editorModeScrollView setUserInteractionEnabled:YES];
                        }
                        else {
                            targetName = self.previous_target_Name;
                            [self.defaults setObject:self.previous_full_Target_Name forKey:@"FullTargetName"];
                            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Class named \"Lessons Duration\" contains less than 4 Years, go to Parse and increase the number of Years to 4" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                            [self remove_Download_Signs];
                        }
                    }
                    else {
                        targetName = self.previous_target_Name;
                        [self.defaults setObject:self.previous_full_Target_Name forKey:@"FullTargetName"];
                        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Sorry, but it seems like that there is no the Internet Connection or class named \"LessonsDuration\" doesn't exist on Parse" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                        [self remove_Download_Signs];
                    }
                }];
            }
            else {
                if ([list count]==0) {
                    [[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"Sorry, but timetable of the target, named \"%@\" either doesn't have 9 lessons or it doesn't exist yet, please go to the server and make lessons count to 9",fullTargetName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                }
                else {
                    [[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"Sorry, but the timetable of the target, named \"%@\" should have 9 lessons, please go to the server and make lessons count to 9",fullTargetName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                }
                targetName = self.previous_target_Name;
                [self.defaults setObject:self.previous_full_Target_Name forKey:@"FullTargetName"];
                [self remove_Download_Signs];
            }
        }
        else {
            targetName = self.previous_target_Name;
            [self.defaults setObject:self.previous_full_Target_Name forKey:@"FullTargetName"];
            [self showAlert];
            [self remove_Download_Signs];
        }
    }];
}

-(void)setLessonDuration:(NSString*)key {
    if (lessonIndex == lunchTimeIndex) {
        lessonIndex++;
    }
    if (lessonIndex<9) {
        NSString* lessonNumber = [[arrayOfLessonsDurations objectAtIndex:year]
                                  objectForKey:key];
        if (lessonNumber&&![lessonNumber isEqualToString:@""]) {
            lessonNumber = [self formatLessonDurationBeforeUpdate:lessonNumber];
            [lessons_duration replaceObjectAtIndex:lessonIndex withObject:lessonNumber];
        }
        lessonIndex++;
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
    text = [NSString stringWithFormat:@"%@:%@\n%@:%@",beginningHour,beginningMinutes,finishingHour,finishingMinutes];
    return text;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditorModeTableViewCell *cell = (EditorModeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (tableView == table_Of_Targets) {
        targetName = @"";fullTargetName = @"";
        if ([array_Of_Targets count]==2) {
            if (indexPath.section == 0) {
                fullTargetName = [[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"Group"];
                targetName = [[fullTargetName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]componentsJoinedByString:@""];
                [self.defaults setObject:@"Student" forKey:@"UpdateType"];
            }
            else {
                fullTargetName = [cell.textLabel text];
                targetName = [[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
                              objectForKey:@"ClassName"];
                [self.defaults setObject:@"Teacher" forKey:@"UpdateType"];
            }
        }
        else if (self.teachers_Are_Shown) {
            fullTargetName = [cell.textLabel text];
            targetName = [[[array_Of_Targets objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
                          objectForKey:@"ClassName"];
            [self.defaults setObject:@"Teacher" forKey:@"UpdateType"];
        }
        [self.defaults setObject:fullTargetName forKey:@"FullTargetName"];
        [self hideTableAndLoadData:targetName];
    }
    else {
        if (![[custom_Navigation_Bar.topItem title]isEqualToString:@"Empty Timetable"]) {
            PFObject *myObject = [lessons objectAtIndex:indexPath.row];
            NSString *objectId = [myObject objectId];
            if (self.chooseLesson) {
                if (!lessons_Are_Ready_To_Update) {
                    [cell setBackgroundColor:[UIColor colorWithRed:0.268627 green:0.639216 blue:0.829412 alpha:1]];
                    [custom_Navigation_Bar.topItem setTitle:@"Choose lessons to update"];
                    lessons_Are_Ready_To_Update = YES;
                    cellToUpdate = cell;
                    self.cellToUpdateObjectId = objectId;
                    self.cellToUpdateTableViewDay = [self tableView:tableView titleForHeaderInSection:0];
                    self.cellToUpdateIndex = indexPath.row;
                }
                else {
                    if (cell!=cellToUpdate) {
                        [cell setBackgroundColor:[UIColor redColor]];
                        [custom_Navigation_Bar.topItem setRightBarButtonItem:saveButton];
                        PFObject *myObject = [lessons objectAtIndex:indexPath.row];
                        NSString *objectId = [myObject objectId];
                        [selectedCellsObjectIds addObject:objectId];
                        [indexesForParentObjectIds addObject:[NSNumber numberWithInteger:indexPath.row]];
                        [selectedCells addObject:cell];
                        [selectedCellsIndexPaths addObject:indexPath];
                        [selectedCellsDays addObject:[self tableView:tableView titleForHeaderInSection:0]];
                    }
                }
            }
            else {
                [self.defaults setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"indexForParentObject"];
                [self.defaults setObject:cell.lesson.text forKey:@"FullLesson"];
                [self.defaults setObject:targetName forKey:@"TargetName"];
                [self.defaults setObject:objectId forKey:@"objectId"];
                [self.defaults setObject:[self tableView:tableView titleForHeaderInSection:0] forKey:@"day"];
                [self presentViewController:cellEditorMode animated:YES completion:nil];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[custom_Navigation_Bar.topItem title]isEqualToString:@"Empty Timetable"]) {
        EditorModeTableViewCell *cell = (EditorModeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell!=cellToUpdate) {
            NSUInteger index = [selectedCells indexOfObject:cell];
            if (index != NSNotFound) {
                [selectedCells removeObjectAtIndex:index];
                [selectedCellsIndexPaths removeObjectAtIndex:index];
                [selectedCellsDays removeObjectAtIndex:index];
                [selectedCellsObjectIds removeObjectAtIndex:index];
                [cell setBackgroundColor:[UIColor whiteColor]];
                if ([selectedCells count]==0) {
                    [custom_Navigation_Bar.topItem setRightBarButtonItem:nil];
                }
            }
        }
        else {
            if ([selectedCells count]==0) {
                [cellToUpdate setBackgroundColor:[UIColor whiteColor]];
                cellToUpdate = nil;
                [custom_Navigation_Bar.topItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:editorTools]];
                [custom_Navigation_Bar.topItem setLeftBarButtonItem:backButton];
                self.chooseLesson = NO;
                lessons_Are_Ready_To_Update = NO;
            }
        }
    }
}

-(void)showAlert {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"It seems like that there is no Internet Connection or you have improperly set the name for the class of the teacher, or smth wrong occured on the server, please check it out" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
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
