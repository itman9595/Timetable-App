//
//  Timetable.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/12/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "Timetable.h"
#import "Timetable_Cell.h"
@implementation Timetable
@synthesize lessons, lessons_duration;
@synthesize exact_Lessons, exact_Lessons_Durations, exact_Lessons_Number;
@synthesize day_title;

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"prepareToMakeTimetablePhoto" object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    exact_Lessons = [[NSMutableArray alloc]init];
    exact_Lessons_Durations = [[NSMutableArray alloc]init];
    exact_Lessons_Number = [[NSMutableArray alloc]init];
    
    int countOfLunchTimes = 0;
    for (int i=0;i<[lessons count];i++) {
        if ([lessons objectAtIndex:i]&&![[lessons objectAtIndex:i]isEqualToString:@""]&&[[lessons objectAtIndex:i] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location == NSNotFound) {
            [exact_Lessons addObject:[lessons objectAtIndex:i]];
            [exact_Lessons_Durations addObject:[lessons_duration objectAtIndex:i]];
            [exact_Lessons_Number addObject:[NSString stringWithFormat:@"%i",i+1-countOfLunchTimes]];
        }
        else if([[lessons objectAtIndex:i] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location != NSNotFound){
            countOfLunchTimes++;
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"prepareToMakeTimetablePhoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareToMakeTimetablePhoto) name:@"prepareToMakeTimetablePhoto" object:nil];
}

-(void)prepareToMakeTimetablePhoto {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"prepareToMakeTimetablePhoto" object:nil];
    if ([exact_Lessons count]!=0) {
        TimetableScreenshot *timetableScreenshot = [[TimetableScreenshot alloc]initWithNibName:@"TimetableScreenshot" bundle:nil];
        [self.view addSubview:timetableScreenshot.view];
        [timetableScreenshot.Target setText:[self.navigationController.navigationBar.topItem title]];
        NSDate *date = [NSDate date];
        NSDateFormatter *createdDateFormat = [[NSDateFormatter alloc] init];
        [createdDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Almaty"]];
        [createdDateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"kk_KZ"]];
        [createdDateFormat setDateFormat:@"dd/MM/yyyy"];
        NSString *first = [createdDateFormat stringFromDate:date];
        [createdDateFormat setDateFormat:@"HH:mm:ss"];
        NSString *second = [createdDateFormat stringFromDate:date];
        NSString *fullTime = [NSString stringWithFormat:@"Captured: %@ at %@ for %@",first,second,[self tableView:self.tableView titleForHeaderInSection:0]];
        [timetableScreenshot.CreatedDate setText:fullTime];
        for (int i=0;i<[exact_Lessons count];i++) {
            if (i==0) {
                [self insertValues:[exact_Lessons objectAtIndex:i] duration:[exact_Lessons_Durations objectAtIndex:i] number:[exact_Lessons_Number objectAtIndex:i] forLesson:timetableScreenshot.FirstLesson forDuration:timetableScreenshot.FirstLessonDuration forNumber:timetableScreenshot.FirstLessonNumber];
            }
            else if (i==1) {
                [self insertValues:[exact_Lessons objectAtIndex:i] duration:[exact_Lessons_Durations objectAtIndex:i] number:[exact_Lessons_Number objectAtIndex:i] forLesson:timetableScreenshot.SecondLesson forDuration:timetableScreenshot.SecondLessonDuration forNumber:timetableScreenshot.SecondLessonNumber];
            }
            else if (i==2) {
                [self insertValues:[exact_Lessons objectAtIndex:i] duration:[exact_Lessons_Durations objectAtIndex:i] number:[exact_Lessons_Number objectAtIndex:i] forLesson:timetableScreenshot.ThirdLesson forDuration:timetableScreenshot.ThirdLessonDuration forNumber:timetableScreenshot.ThirdLessonNumber];
            }
            else if (i==3) {
                [self insertValues:[exact_Lessons objectAtIndex:i] duration:[exact_Lessons_Durations objectAtIndex:i] number:[exact_Lessons_Number objectAtIndex:i] forLesson:timetableScreenshot.FourthLesson forDuration:timetableScreenshot.FourthLessonDuration forNumber:timetableScreenshot.FourthLessonNumber];
            }
            else if (i==4) {
                [self insertValues:[exact_Lessons objectAtIndex:i] duration:[exact_Lessons_Durations objectAtIndex:i] number:[exact_Lessons_Number objectAtIndex:i] forLesson:timetableScreenshot.FifthLesson forDuration:timetableScreenshot.FifthLessonDuration forNumber:timetableScreenshot.FifthLessonNumber];
            }
            else if (i==5) {
                [self insertValues:[exact_Lessons objectAtIndex:i] duration:[exact_Lessons_Durations objectAtIndex:i] number:[exact_Lessons_Number objectAtIndex:i] forLesson:timetableScreenshot.SixthLesson forDuration:timetableScreenshot.SixthLessonDuration forNumber:timetableScreenshot.SixthLessonNumber];
            }
            else if (i==6) {
                [self insertValues:[exact_Lessons objectAtIndex:i] duration:[exact_Lessons_Durations objectAtIndex:i] number:[exact_Lessons_Number objectAtIndex:i] forLesson:timetableScreenshot.SeventhLesson forDuration:timetableScreenshot.SeventhLessonDuration forNumber:timetableScreenshot.SeventhLessonNumber];
            }
            else if (i==7) {
                [self insertValues:[exact_Lessons objectAtIndex:i] duration:[exact_Lessons_Durations objectAtIndex:i] number:[exact_Lessons_Number objectAtIndex:i] forLesson:timetableScreenshot.EighthLesson forDuration:timetableScreenshot.EighthLessonDuration forNumber:timetableScreenshot.EighthLessonNumber];
            }
        }
        [timetableScreenshot.view removeFromSuperview];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"takeScreenshot" object:nil];
    }
    else {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Couldn't capture a photo of the empty timetable" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareToMakeTimetablePhoto) name:@"prepareToMakeTimetablePhoto" object:nil];
}

-(void)insertValues:(NSString*)Lesson duration:(NSString*)Duration number:(NSString*)number forLesson:(UILabel*)lessonLabel forDuration:(UILabel*)durationLabel forNumber:(UILabel*)numberLabel {
    [lessonLabel setText:Lesson];
    [durationLabel setText:Duration];
    [numberLabel setText:number];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return day_title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lessons count];
}

#pragma Cell dequeue

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Timetable_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Lesson"];
    NSUInteger row = indexPath.row;
    [cell.lesson setText:[lessons objectAtIndex:row]];
    
    if (indexPath.row%2!=0) {
        [cell.lesson setBackgroundColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412 alpha:1]];
        [cell.lesson setTextColor:[UIColor whiteColor]];
    }
    else{
        [cell.lesson setBackgroundColor:[UIColor whiteColor]];
        [cell.lesson setTextColor:[UIColor colorWithRed:0.168627 green:0.239216 blue:0.329412
                                                  alpha:1]];
    }
    
    [cell.number_of_lesson setText:[NSString stringWithFormat:@"%li",(long)(row+1)]];
    
    [cell.number_of_lesson setBackgroundColor:[cell.lesson textColor]];
    [cell.number_of_lesson setTextColor:[cell.lesson backgroundColor]];
    [cell.lesson_duration setBackgroundColor:[cell.lesson textColor]];
    [cell.lesson_duration setTextColor:[cell.lesson backgroundColor]];
    
    [cell.lesson_duration setText:[lessons_duration objectAtIndex:row]];
    return cell;
}
@end
