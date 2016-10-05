//
//  Search_View_Controller.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/20/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "Search_View_Controller.h"
#import "Reachability.h"
#import "Timetable_View_Controller.h"
@implementation Search_View_Controller
@synthesize scrollview;
@synthesize searchBar;
@synthesize studentsResultsTableViewController, teachersResultsTableViewController;
@synthesize existing_students, students_existing_names, students_existing_surnames, students_full_Name, students_names, students_surnames, existing_teachers, teachers_existing_names, teachers_existing_surnames, teachers_existing_class_names;
@synthesize filtered_existing_students,filtered_teachers_existing_class_names,filtered_students_groups,filtered_existing_teachers;
@synthesize students_Group_Titles;
@synthesize partOfFilteredExistingPeople;
@synthesize search_text_with_Letters_Only;
@synthesize timer;
@synthesize dimmed_View, activityIndicatorView;
@synthesize updateIt;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDatabase" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showTimetable" object:nil];
    [timer invalidate];
    [self.query cancel];
    [updateIt.query cancel];
}

-(void)didRotate:(NSNotification *)notification
{
    [self set_Scroll_View_Content_According_To_Orientation];
}

-(void)set_Scroll_View_Content_According_To_Orientation {
    [dimmed_View setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    activityIndicatorView.center = CGPointMake(dimmed_View.frame.size.width / 2, dimmed_View.frame.size.height / 2);
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    CGFloat currentOffsetX = scrollview.contentOffset.x;
    if (currentOffsetX > 0) {
        currentOffsetX = self.view.frame.size.width;
    }
    else {
        currentOffsetX = 0;
    }
    
    CGRect frame = studentsResultsTableViewController.frame;
    frame.size.width = self.view.frame.size.width;
    
    frame.size.height = self.view.frame.size.height-(searchBar.frame.origin.y+searchBar.frame.size.height);
    
    if (newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight)
    {
        frame.origin.y = -searchBar.frame.origin.y;
        [scrollview setContentOffset:CGPointMake(currentOffsetX, -searchBar.frame.origin.y)];
    }
    else if (newOrientation == UIInterfaceOrientationPortrait || newOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        frame.origin.y = -([UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height);
    }
    
    [studentsResultsTableViewController setFrame:frame];
    frame = studentsResultsTableViewController.frame;
    frame.origin.x = self.view.frame.size.width;
    [teachersResultsTableViewController setFrame:frame];
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width*2, 0);
}

-(void)redownload_Data_Again {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
    }
    else {
        if (!students_List_Has_Been_Processed) {
            students_List_Has_Been_Processed = YES;
            [self showList:@"Students"];
        }
        if (!teachers_List_Has_Been_Processed) {
            teachers_List_Has_Been_Processed = YES;
            [self showList:@"Teachers"];
        }
    }
}

-(void)launchTimer {
    if (!students_Are_Ready_To_Be_Displayed) {
        students_List_Has_Been_Processed = NO;
    }
    if (!teachers_Are_Ready_To_Be_Displayed) {
        teachers_List_Has_Been_Processed = NO;
    }
    if (!timer_Has_Been_Launched) {
        [self error:@"No Internet Connection"];
        timer_Has_Been_Launched = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(redownload_Data_Again) userInfo:nil repeats:YES];
    }
}

-(void)showList:(NSString*)list_name {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self launchTimer];
    }
    else {
        
        self.query = [PFQuery queryWithClassName:list_name];
        self.query.limit = 5000;
        [self.query findObjectsInBackgroundWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                if ([list count]!=0) {
                    if ([list_name isEqualToString:@"Students"]) {
                        existing_students = [[NSMutableArray alloc]init];
                        students_existing_names = [[NSMutableArray alloc]init];
                        students_existing_surnames = [[NSMutableArray alloc]init];
                        students_full_Name = [[NSMutableArray alloc]init];
                        students_names = [[NSMutableArray alloc]init];
                        students_surnames = [[NSMutableArray alloc]init];
                        filtered_existing_students = [[NSMutableArray alloc]init];
                        filtered_students_groups = [[NSMutableArray alloc]init];
                        students_Group_Titles = [[NSMutableArray alloc]init];
                    }
                    else {
                        existing_teachers = [[NSMutableArray alloc]init];
                        teachers_existing_names = [[NSMutableArray alloc]init];
                        teachers_existing_surnames = [[NSMutableArray alloc]init];
                        filtered_existing_teachers = [[NSMutableArray alloc]init];
                        teachers_existing_class_names = [[NSMutableArray alloc]init];
                        filtered_teachers_existing_class_names = [[NSMutableArray alloc]init];
                    }
                    
                    NSMutableArray *groups = [[NSMutableArray alloc]init];
                    for (PFObject *person in list) {
                        
                        NSString *group;
                        
                        if ([list_name isEqualToString:@"Students"]) {
                            group = [person objectForKey:@"Group"];
                        }
                        
                        if (group && [list_name isEqualToString:@"Students"]) {
                            if ([[NSCharacterSet decimalDigitCharacterSet]isSupersetOfSet:
                                 [NSCharacterSet characterSetWithCharactersInString:group]]||
                                [[NSCharacterSet punctuationCharacterSet]isSupersetOfSet:
                                 [NSCharacterSet characterSetWithCharactersInString:group]]||
                                [[NSCharacterSet symbolCharacterSet]isSupersetOfSet:
                                 [NSCharacterSet characterSetWithCharactersInString:group]]) {
                                    group = @"";
                                }
                        }
                        else {
                            group = @"";
                        }
                        
                        if ((![group isEqualToString:@""] && [list_name isEqualToString:@"Students"])||
                            [list_name isEqualToString:@"Teachers"]) {
                            NSString *className = [person objectForKey:@"ClassName"];
                            //SHOULD BE GIVEN ON PARSE EXACTLY AS THE CLASS NAME CREATED FOR SPECIFIED TEACHER
                            NSString *name = [person objectForKey:@"Name"];
                            NSString *surname = [person objectForKey:@"Surname"];
                            
                            if (!className) {
                                className = @"";
                            }
                            else {
                                className = [[className componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]invertedSet]]componentsJoinedByString:@""];
                                if (![[NSCharacterSet letterCharacterSet]isSupersetOfSet:
                                      [NSCharacterSet characterSetWithCharactersInString:className]]) {
                                    className = @"";
                                }
                            }
                            
                            if ([list_name isEqualToString:@"Students"]||(![className isEqualToString:@""]&&[list_name isEqualToString:@"Teachers"])) {
                                
                                if (name) {
                                    name = [self remove_characters:name];
                                }
                                else {
                                    name = @"";
                                }
                                
                                if (surname) {
                                    surname = [self remove_characters:surname];
                                }
                                else {
                                    surname = @"";
                                }
                                
                                if (![name isEqualToString:@""]||![surname isEqualToString:@""]) {
                                    if ([list_name isEqualToString:@"Teachers"]) {
                                        className = [person objectForKey:@"ClassName"];
                                    }
                                    if (![name isEqualToString:@""]&&![surname isEqualToString:@""]) {
                                        if ([list_name isEqualToString:@"Students"]) {
                                            [students_full_Name addObject:[NSString stringWithFormat:@"%@ %@",[surname capitalizedString],
                                                                           [name capitalizedString]]];
                                            [students_names addObject:name];
                                            [students_surnames addObject:surname];
                                        }
                                        else {
                                            [existing_teachers addObject:[NSString stringWithFormat:@"%@ %@",[surname capitalizedString],
                                                                          [name capitalizedString]]];
                                            [teachers_existing_names addObject:name];
                                            [teachers_existing_surnames addObject:surname];
                                            [teachers_existing_class_names addObject:className];
                                        }
                                    }
                                    else if (![surname isEqualToString:@""]) {
                                        if ([list_name isEqualToString:@"Students"]) {
                                            [students_full_Name addObject:[surname capitalizedString]];
                                            [students_names addObject:@""];
                                            [students_surnames addObject:surname];
                                        }
                                        else {
                                            [existing_teachers addObject:[surname capitalizedString]];
                                            [teachers_existing_names addObject:@""];
                                            [teachers_existing_surnames addObject:surname];
                                            [teachers_existing_class_names addObject:className];
                                        }
                                    }
                                    else if (![name isEqualToString:@""]) {
                                        if ([list_name isEqualToString:@"Students"]) {
                                            [students_full_Name addObject:[name capitalizedString]];
                                            [students_names addObject:name];
                                            [students_surnames addObject:@""];
                                        }
                                        else {
                                            [existing_teachers addObject:[name capitalizedString]];
                                            [teachers_existing_names addObject:name];
                                            [teachers_existing_surnames addObject:@""];
                                            [teachers_existing_class_names addObject:className];
                                        }
                                    }
                                    [groups addObject:group];
                                }
                            }
                        }
                        
                    }
                    
                    if ([list_name isEqualToString:@"Students"]) {
                        NSSet *unique_set = [[NSSet alloc]initWithArray:groups];
                        students_Group_Titles = [[unique_set allObjects] mutableCopy];
                        if (![groups isEqualToArray:students_Group_Titles]) {
                            [self sort:groups];
                        }
                        groups = [NSMutableArray new];
                    }
                    
                    if ([existing_teachers count]==0) {
                        [self error:@"The list of teachers is currently unavailable. Check it out again later."];
                    }
                    else if ([existing_teachers count]==1 && [[existing_teachers objectAtIndex:0]isEqualToString:@""]) {
                    }
                    else {
                        teachers_Are_Ready_To_Be_Displayed = YES;
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        if (![[defaults objectForKey:@"swipeLeft"]isEqualToString:@"HintIsShown"]) {
                            [self error:@"Swipe to the left in order to access the timetable of the teacher that you need"];
                            [defaults setObject:@"HintIsShown" forKey:@"swipeLeft"];
                        }
                    }
                    
                    if ([existing_students count]==0) {
                        [self error:@"The list of students is currently unavailable. Check it out again later."];
                    }
                    else if ([existing_students count]==1 && [[existing_students objectAtIndex:0]isEqualToString:@""]) {
                    }
                    else {
                        students_Are_Ready_To_Be_Displayed = YES;
                        CGFloat currentOffsetX = scrollview.contentOffset.x;
                        if (currentOffsetX == 0) {
                            [searchBar setUserInteractionEnabled:YES];
                        }
                    }
                    
                    if ([list_name isEqualToString:@"Students"]) {
                        [studentsResultsTableViewController reloadData];
                    }
                    else {
                        [teachersResultsTableViewController reloadData];
                    }
                }
            }
            else{
                [self launchTimer];
            }
        }];
        
    }
}

-(void)sort:(NSMutableArray*)unsorted_array{
    NSMutableArray *student = [[NSMutableArray alloc]init];
    NSMutableArray *name = [[NSMutableArray alloc]init];
    NSMutableArray *surname = [[NSMutableArray alloc]init];
    
    for (int i=0;i<[students_Group_Titles count];i++) {
        for (int j=0;j<[unsorted_array count];j++) {
            if ([[unsorted_array objectAtIndex:j]isEqualToString:[students_Group_Titles objectAtIndex:i]]) {
                [name addObject:[students_names objectAtIndex:j]];
                [surname addObject:[students_surnames objectAtIndex:j]];
                [student addObject:[students_full_Name objectAtIndex:j]];
                [students_full_Name removeObjectAtIndex:j];
                [students_names removeObjectAtIndex:j];
                [students_surnames removeObjectAtIndex:j];
                [unsorted_array removeObjectAtIndex:j];
                j--;
            }
        }
        [existing_students addObject:student];
        [students_existing_names addObject:name];
        [students_existing_surnames addObject:surname];
        student = [NSMutableArray new];
        name = [NSMutableArray new];
        surname = [NSMutableArray new];
    }
}

-(void)viewDidLayoutSubviews {
    [self set_Scroll_View_Content_According_To_Orientation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    updateIt = [[updateDatabase alloc]init];
    [updateIt initializeElementsForUpdate];
    
    if ([self.navigationController respondsToSelector:
         @selector(interactivePopGestureRecognizer)]) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    }
    
    [searchBar setUserInteractionEnabled:NO];
    
    existing_students = [[NSMutableArray alloc]initWithObjects:@"", nil];
    existing_teachers = [[NSMutableArray alloc]initWithObjects:@"", nil];
    [scrollview setDelegate:self];
    
    studentsResultsTableViewController = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [studentsResultsTableViewController setDelegate:self];
    [studentsResultsTableViewController setDataSource:self];
    [scrollview addSubview:studentsResultsTableViewController];
    
    teachersResultsTableViewController = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [teachersResultsTableViewController setDelegate:self];
    [teachersResultsTableViewController setDataSource:self];
    [scrollview addSubview:teachersResultsTableViewController];

    [self set_Scroll_View_Content_According_To_Orientation];
    
    [self showList:@"Students"];
    [self showList:@"Teachers"];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat currentOffsetX = scrollview.contentOffset.x;
    if (currentOffsetX > 0) {
        if (teachers_Are_Ready_To_Be_Displayed) {
            [searchBar setUserInteractionEnabled:YES];
        }
        else {
            [searchBar setUserInteractionEnabled:NO];
        }
    }
    else {
        if (students_Are_Ready_To_Be_Displayed) {
            [searchBar setUserInteractionEnabled:YES];
        }
        else {
            [searchBar setUserInteractionEnabled:NO];
        }
    }
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText {
    [filtered_existing_students removeAllObjects];
    [filtered_students_groups removeAllObjects];
    [filtered_existing_teachers removeAllObjects];
    [filtered_teachers_existing_class_names removeAllObjects];
    
    search_text_with_Letters_Only = [[searchText componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]invertedSet]]componentsJoinedByString:@""];
    if ([search_text_with_Letters_Only length]!=0) {
        partOfFilteredExistingPeople = [[NSMutableArray alloc]init];
        NSString *typeOfPeople;
        CGFloat currentOffsetX = scrollview.contentOffset.x;
        if (currentOffsetX > 0) {
            typeOfPeople = @"Teachers";
            [self startFiltering:typeOfPeople peopleWhichExist:existing_teachers namesOfPeopleWhichExist:teachers_existing_names surnamesOfPeopleWhichExist:teachers_existing_surnames];
        }
        else {
            typeOfPeople = @"Students";
            [self startFiltering:typeOfPeople peopleWhichExist:existing_students namesOfPeopleWhichExist:students_existing_names surnamesOfPeopleWhichExist:students_existing_surnames];
        }
    }
}

-(void)startFiltering:(NSString*)typeOfPeople peopleWhichExist:(NSMutableArray*)existingPeople namesOfPeopleWhichExist:(NSMutableArray*)peopleExistingNames surnamesOfPeopleWhichExist:(NSMutableArray*)peopleExistingSurnames{
    if ([existingPeople count] != 0) {
        for (int i=0;i<[existingPeople count];i++) {
            if ([typeOfPeople isEqualToString:@"Students"]) {
                if ([[existingPeople objectAtIndex:i]count] != 0) {
                    
                    for (int j=0;j<[[existingPeople objectAtIndex:i]count];j++) {
                        
                        //FIRST ADD NAME
                        name_Added_To_List = NO;
                        NSString *textToCompare = [[[peopleExistingNames objectAtIndex:i]objectAtIndex:j]lowercaseString];
                        textToCompare = [self remove_dash:textToCompare];
                        [self filterList:typeOfPeople givenText:
                         textToCompare indexOfTheGroup:i indexOfTheElement:j];
                        
                        //IF NAME WASN'T ADDED, THEN ADD SURNAME
                        
                        if (!name_Added_To_List) {
                            textToCompare = [[[peopleExistingSurnames objectAtIndex:i]objectAtIndex:j]lowercaseString];
                            textToCompare = [self remove_dash:textToCompare];
                            [self filterList:typeOfPeople givenText:
                             textToCompare indexOfTheGroup:i indexOfTheElement:j];
                        }
                        
                    }
                    if ([partOfFilteredExistingPeople count]!=0) {
                            [filtered_existing_students addObject:partOfFilteredExistingPeople];
                            partOfFilteredExistingPeople = [NSMutableArray new];
                            [filtered_students_groups addObject:
                             [students_Group_Titles objectAtIndex:i]];
                    }
                    
                }
            }
            else {
                    //FIRST ADD NAME
                    name_Added_To_List = NO;
                    NSString *textToCompare = [[peopleExistingNames objectAtIndex:i]lowercaseString];
                    textToCompare = [self remove_dash:textToCompare];
                    [self filterList:typeOfPeople givenText:
                     textToCompare indexOfTheGroup:i indexOfTheElement:0];
                    
                    //IF NAME WASN'T ADDED, THEN ADD SURNAME
                    
                    if (!name_Added_To_List) {
                        textToCompare = [[peopleExistingSurnames objectAtIndex:i]lowercaseString];
                        textToCompare = [self remove_dash:textToCompare];
                        [self filterList:typeOfPeople givenText:
                         textToCompare indexOfTheGroup:i indexOfTheElement:0];
                    }
            }
        }
        if ([typeOfPeople isEqualToString:@"Teachers"]) {
            filtered_existing_teachers = partOfFilteredExistingPeople;
            partOfFilteredExistingPeople = [NSMutableArray new];
        }
    }
}

-(void)filterList:(NSString*)typeOfPeople givenText:(NSString*)textToCompare indexOfTheGroup:(int)i indexOfTheElement:(int)j {
    if ([search_text_with_Letters_Only length]<=[textToCompare length]) {
        int countOfEqualCharacters = 0;
        for (int a=(int)[search_text_with_Letters_Only length]-1;a>=0;a--) {
            if ([textToCompare characterAtIndex:a]==[search_text_with_Letters_Only characterAtIndex:a]) {
                countOfEqualCharacters++;
            }
            if (countOfEqualCharacters != [search_text_with_Letters_Only length]-a) {
                break;
            }
        }
        
        if (countOfEqualCharacters == [search_text_with_Letters_Only length]) {
            if ([typeOfPeople isEqualToString:@"Students"]) {
                [partOfFilteredExistingPeople addObject:[[existing_students objectAtIndex:i]objectAtIndex:j]];
            }
            else {
                [partOfFilteredExistingPeople addObject:[existing_teachers
                                                         objectAtIndex:i]];
                [filtered_teachers_existing_class_names addObject:[teachers_existing_class_names objectAtIndex:i]];
            }
            name_Added_To_List = YES;
        }
    }
}

#pragma mark - UISearchBarDelegate Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:[searchText lowercaseString]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == studentsResultsTableViewController) {
        if ([students_Group_Titles count] != 0) {
            return [students_Group_Titles count];
        }
        return 1;
    } else if (tableView != teachersResultsTableViewController) {
        CGFloat currentOffsetX = scrollview.contentOffset.x;
        if (currentOffsetX > 0) {
            return 1;
        }
        else {
            return [filtered_students_groups count];
        }
    }
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *formattedTitle;
    if (tableView == studentsResultsTableViewController) {
        formattedTitle = [students_Group_Titles objectAtIndex:section];
        if ([formattedTitle rangeOfString:@"1"].location != NSNotFound) {
            formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"1"].location, 1) withString:[NSString stringWithFormat:@" %c ",[formattedTitle characterAtIndex:[formattedTitle rangeOfString:@"1"].location]]];
        }
        if ([formattedTitle rangeOfString:@"2"].location != NSNotFound) {
            formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"2"].location, 1) withString:[NSString stringWithFormat:@" %c ",[formattedTitle characterAtIndex:[formattedTitle rangeOfString:@"2"].location]]];
        }
        if ([formattedTitle rangeOfString:@"3"].location != NSNotFound) {
            formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"3"].location, 1) withString:[NSString stringWithFormat:@" %c ",[formattedTitle characterAtIndex:[formattedTitle rangeOfString:@"3"].location]]];
        }
        if ([formattedTitle rangeOfString:@"4"].location != NSNotFound) {
            formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"4"].location, 1) withString:[NSString stringWithFormat:@" %c ",[formattedTitle characterAtIndex:[formattedTitle rangeOfString:@"4"].location]]];
        }
        if ([formattedTitle rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].location, [formattedTitle rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].length) withString:@"Translation Studies"];
        }
        return formattedTitle;
    } else if (tableView != teachersResultsTableViewController) {
        CGFloat currentOffsetX = scrollview.contentOffset.x;
        if (currentOffsetX > 0) {
            return nil;
        }
        else {
            formattedTitle = [filtered_students_groups objectAtIndex:section];
            if ([formattedTitle rangeOfString:@"1"].location != NSNotFound) {
                formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"1"].location, 1) withString:[NSString stringWithFormat:@" %c ",[formattedTitle characterAtIndex:[formattedTitle rangeOfString:@"1"].location]]];
            }
            if ([formattedTitle rangeOfString:@"2"].location != NSNotFound) {
                formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"2"].location, 1) withString:[NSString stringWithFormat:@" %c ",[formattedTitle characterAtIndex:[formattedTitle rangeOfString:@"2"].location]]];
            }
            if ([formattedTitle rangeOfString:@"3"].location != NSNotFound) {
                formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"3"].location, 1) withString:[NSString stringWithFormat:@" %c ",[formattedTitle characterAtIndex:[formattedTitle rangeOfString:@"3"].location]]];
            }
            if ([formattedTitle rangeOfString:@"4"].location != NSNotFound) {
                formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"4"].location, 1) withString:[NSString stringWithFormat:@" %c ",[formattedTitle characterAtIndex:[formattedTitle rangeOfString:@"4"].location]]];
            }
            if ([formattedTitle rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                formattedTitle = [formattedTitle stringByReplacingCharactersInRange:NSMakeRange([formattedTitle rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].location, [formattedTitle rangeOfString:@"TranslationStudies" options:NSCaseInsensitiveSearch].length) withString:@"Translation Studies"];
            }
            return formattedTitle;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == studentsResultsTableViewController) {
        if ([existing_students count] > 1) {
            return [[existing_students objectAtIndex:section]count];
        }
        else {
            return [existing_students count];
        }
    }
    else if (tableView == teachersResultsTableViewController) {
        return [existing_teachers count];
    }
    else {
        CGFloat currentOffsetX = scrollview.contentOffset.x;
        if (currentOffsetX > 0) {
            return [filtered_existing_teachers count];
        }
        else {
            return [[filtered_existing_students objectAtIndex:section]count];
        }
    }
    
    return 0;
}

#pragma Cell dequeue

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!students_Are_Ready_To_Be_Displayed && tableView == studentsResultsTableViewController) {
        return [self returnCell:tableView];
    }
    else if (!teachers_Are_Ready_To_Be_Displayed && tableView == teachersResultsTableViewController) {
        return [self returnCell:tableView];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Person"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Person"];
    }
    
    NSInteger row = indexPath.row;
    
    if (tableView == studentsResultsTableViewController) {
        [cell.textLabel setText:[[existing_students objectAtIndex:indexPath.section]objectAtIndex:row]];
    }
    else if (tableView == teachersResultsTableViewController) {
        [cell.textLabel setText:[existing_teachers objectAtIndex:row]];
    }
    else {
        CGFloat currentOffsetX = scrollview.contentOffset.x;
        if (currentOffsetX > 0) {
            [cell.textLabel setText:[filtered_existing_teachers objectAtIndex:row]];
        }
        else {
            [cell.textLabel setText:[[filtered_existing_students objectAtIndex:indexPath.section]objectAtIndex:row]];
        }
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

-(UITableViewCell*)returnCell:(UITableView*)tableView {
    UITableViewCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:@"Loading"];
    if (loadingCell == nil) {
        loadingCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Loading"];
    }
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect loadingIndicatorFrame = loadingIndicator.frame;
    loadingIndicatorFrame.origin.x = 10;
    loadingIndicatorFrame.size.width = loadingCell.frame.size.height;
    loadingIndicatorFrame.size.height = loadingCell.frame.size.height;
    [loadingIndicator setFrame:loadingIndicatorFrame];
    [loadingCell.contentView addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    return loadingCell;
}

-(void)create_Download_Signs {
    dimmed_View = [[UIView alloc]init];
    [dimmed_View setBackgroundColor:[UIColor blackColor]];
    [dimmed_View setAlpha:0.5];
    [dimmed_View.layer setMasksToBounds:YES];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self set_Scroll_View_Content_According_To_Orientation];
    [self.view addSubview:dimmed_View];
    [self.view addSubview:activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remove_Download_Signs) name:@"updateDatabase" object:nil];
}

-(void)remove_Download_Signs {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDatabase" object:nil];
    [activityIndicatorView removeFromSuperview];
    [dimmed_View removeFromSuperview];
}

-(void)go_To_Timetable:(NSNotification*)note {
    Timetable_View_Controller *timetable_View_Controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"Timetable_View_Controller"];
    if ([[[note userInfo]objectForKey:@"Person"]isEqualToString:@"Student"]) {
        [timetable_View_Controller setTheSuperview:@"Student"];
    }
    else if ([[[note userInfo]objectForKey:@"Person"]isEqualToString:@"Teacher"]) {
        [timetable_View_Controller setTheSuperview:@"Teacher"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showTimetable" object:nil];
    [self.navigationController pushViewController:timetable_View_Controller animated:YES];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!students_Are_Ready_To_Be_Displayed && tableView == studentsResultsTableViewController) {
        [studentsResultsTableViewController deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if (!teachers_Are_Ready_To_Be_Displayed && tableView == teachersResultsTableViewController) {
        [teachersResultsTableViewController deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        [self create_Download_Signs];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(go_To_Timetable:) name:@"showTimetable" object:nil];
        
        NSString *databaseName;
        if (tableView == studentsResultsTableViewController) {
            databaseName = [students_Group_Titles objectAtIndex:indexPath.section];
            NSString *headerTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
            [updateIt performUpdate:databaseName speciality_Text_Field_Text:headerTitle year_Text_Field_Text:@"" course_language_Text_Field:@"" options:@"StudentSearching"];
        }
        else if (tableView == teachersResultsTableViewController) {
            databaseName = [teachers_existing_class_names objectAtIndex:indexPath.row];
            [updateIt performUpdate:databaseName speciality_Text_Field_Text:[existing_teachers objectAtIndex:indexPath.row] year_Text_Field_Text:@"" course_language_Text_Field:@"" options:@"TeacherSearching"];
        }
        else {
            CGFloat currentOffsetX = scrollview.contentOffset.x;
            if (currentOffsetX > 0) {
                databaseName = [filtered_teachers_existing_class_names objectAtIndex:indexPath.row];
                [updateIt performUpdate:databaseName speciality_Text_Field_Text:[filtered_existing_teachers objectAtIndex:indexPath.row] year_Text_Field_Text:@"" course_language_Text_Field:@"" options:@"TeacherSearching"];
            }
            else {
                databaseName = [filtered_students_groups objectAtIndex:indexPath.section];
                NSString *headerTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
                [updateIt performUpdate:databaseName speciality_Text_Field_Text:headerTitle year_Text_Field_Text:@"" course_language_Text_Field:@"" options:@"StudentSearching"];
            }
        }
    }
}

-(NSString*)remove_characters:(NSString*)string {
 return [[string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"¡™£¢∞¶•ªº≠`Ω≈√Œ∑´®†¥¨ˆ“‘©˙˚¬…«∫˜≤≥÷,.:;?!@§±#$%^*+=_(){}[]|\\/~"]]componentsJoinedByString:@""];
}

-(NSString*)remove_dash:(NSString*)string {
    return [[string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]]componentsJoinedByString:@""];
}
 
-(void)error:(NSString*)message {
    [[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
