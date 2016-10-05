//
//  Teachers_Settings.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/6/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "Teachers_Settings.h"
#import "Teacher_Cell.h"

@implementation Teachers_Settings
@synthesize teachers, teachersClass, teachersEmails;
@synthesize dimmed_View, activityIndicatorView;
@synthesize updateIt;
@synthesize defaults;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enableScrollForTeachersSettings" object:nil];
    [self.query cancel];
    [updateIt.query cancel];
}

-(void)didRotate:(NSNotification *)notification
{
    [self set_Scroll_View_Content_Size_According_To_Orientation:self.clickedX];
}

-(void)set_Scroll_View_Content_Size_According_To_Orientation:(CGFloat)clickedX{
    [dimmed_View setFrame:CGRectMake(0, clickedX, self.view.frame.size.width, self.view.frame.size.height)];
    activityIndicatorView.center = CGPointMake(dimmed_View.frame.size.width / 2, clickedX+dimmed_View.frame.size.height / 2);
}

-(void)create_Download_Signs {
    dimmed_View = [[UIView alloc]init];
    [dimmed_View setBackgroundColor:[UIColor blackColor]];
    [dimmed_View setAlpha:0.5];
    [dimmed_View.layer setMasksToBounds:YES];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self set_Scroll_View_Content_Size_According_To_Orientation:self.clickedX];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (![[self.defaults objectForKey:@"FirstWarning"]isEqualToString:@"PoppedUp"]) {
        if (buttonIndex == 0) {
            [[[UIAlertView alloc]initWithTitle:nil message:@"Note for teachers: We are very sorry, that if you find several teachers those are missing on this list, we hope that you will be able to access timetables of all insufficient teachers very soon." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
            [self.defaults setObject:@"PoppedUp" forKey:@"FirstWarning"];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setRowHeight:44];
    
    updateIt = [[updateDatabase alloc]init];
    [updateIt initializeElementsForUpdate];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults setObject:nil forKey:@"swipedCellIndex"];
    
    teachers = [[NSMutableArray alloc]init];
    teachersClass = [[NSMutableArray alloc]init];
    teachersEmails = [[NSMutableArray alloc]init];
    self.clickedX = 0;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (![[self.defaults objectForKey:@"FirstWarning"]isEqualToString:@"PoppedUp"]&&[MFMessageComposeViewController canSendText]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"Welcome to the timetable section that is assigned for our teachers! Note for students: Never bother teachers by sending them improper messages! Keep in mind, that you will be responsible for your own acts!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    }
    
    [self create_Download_Signs];
    
    self.query = [PFQuery queryWithClassName:@"Teachers"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *teachers_list, NSError *error) {
        if (!error) {
            if ([teachers_list count]!=0) {
                
                for (PFObject *teacher in teachers_list) {
                    NSString *className = [teacher objectForKey:@"ClassName"];
                    //SHOULD BE GIVEN ON PARSE EXACTLY AS THE CLASS NAME CREATED FOR SPECIFIED TEACHER
                    NSString *name = [teacher objectForKey:@"Name"];
                    NSString *surname = [teacher objectForKey:@"Surname"];
                    NSString *telephone = [teacher objectForKey:@"Telephone"];
                    NSString *email = [teacher objectForKey:@"Email"];
                    
                    if (!className) {
                        className = @"";
                    }
                    
                    if (!telephone) {
                        telephone = @"";
                    }
                    
                    if (!email) {
                        email = @"";
                    }
                    
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
                        if (![name isEqualToString:@""]&&![surname isEqualToString:@""]) {
                            [teachers addObject:[NSString stringWithFormat:@"%@ %@",[surname capitalizedString],
                                                 [name capitalizedString]]];
                            [teachersClass addObject:className];
                            [teachersEmails addObject:email];
                        }
                        else if (![surname isEqualToString:@""]) {
                            [teachers addObject:[surname capitalizedString]];
                            [teachersClass addObject:className];
                            [teachersEmails addObject:email];
                        }
                        else if (![name isEqualToString:@""]) {
                            [teachers addObject:[name capitalizedString]];
                            [teachersClass addObject:className];
                            [teachersEmails addObject:email];
                        }
                    }
                }
                
                [self.tableView reloadData];
                [self remove_Download_Signs];
                
            }
            else if ([teachers_list count]==0) {
                [self error:@"The list of teachers is currently unavailable. Check it out again later."];
                [self remove_Download_Signs];
            }
        }
        else{
            [self error:@"No Internet Connection"];
            [self remove_Download_Signs];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"submit_Choice" object:nil];
        }
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.clickedX = scrollView.contentOffset.y;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableScroll) name:@"enableScrollForTeachersSettings" object:nil];
    [self create_Download_Signs];
    NSString *teacherName = [teachersClass objectAtIndex:indexPath.row];
    [updateIt performUpdate:teacherName speciality_Text_Field_Text:[teachers objectAtIndex:indexPath.row] year_Text_Field_Text:@"" course_language_Text_Field:@"" options:@"Teacher_Settings"];
}

-(void)enableScroll {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enableScrollForTeachersSettings" object:nil];
    [self.tableView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
}

-(NSString*)remove_characters:(NSString*)string {
    return [[string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"¡™£¢∞¶•ªº≠`Ω≈√Œ∑´®†¥¨ˆ“‘©˙˚¬…«∫˜≤≥÷,.:;?!@§±#$%^*+=_(){}[]|\\/~"]]componentsJoinedByString:@""];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [teachers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Teacher";
    Teacher_Cell *cell = (Teacher_Cell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (![[self.defaults objectForKey:@"swipedCellIndex"]isEqual:[NSNumber numberWithInteger:indexPath.row]]) {
        [cell resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
    }
    else {
        [cell setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
    }
    cell.swipedCellIndex = indexPath.row;
    [cell.myTextLabel setText:[teachers objectAtIndex:indexPath.row]];
    cell.email = [teachersEmails objectAtIndex:indexPath.row];
    return cell;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)error:(NSString*)message{
    [[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

@end
