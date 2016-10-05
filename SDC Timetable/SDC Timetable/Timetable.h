//
//  Timetable.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/12/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TimetableScreenshot.h"
@interface Timetable : UITableViewController
@property (strong, nonatomic) NSString *day_title;
@property (strong, nonatomic) NSMutableArray *lessons, *lessons_duration,*exact_Lessons, *exact_Lessons_Durations, *exact_Lessons_Number;
@property NSInteger day;
@end
