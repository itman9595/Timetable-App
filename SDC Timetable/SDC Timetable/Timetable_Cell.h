//
//  Timetable_Cell.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/12/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Timetable_Cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lesson, *lesson_duration, *number_of_lesson;
@end
