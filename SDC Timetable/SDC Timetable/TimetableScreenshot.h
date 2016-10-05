//
//  TimetableScreenshot.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/27/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
@interface TimetableScreenshot : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *Target;
@property (weak, nonatomic) IBOutlet UILabel *CreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *FirstLessonNumber, *FirstLessonDuration, *FirstLesson,
*SecondLessonNumber, *SecondLessonDuration, *SecondLesson, *ThirdLessonNumber, *ThirdLessonDuration, *ThirdLesson, *FourthLessonNumber, *FourthLessonDuration, *FourthLesson, *FifthLessonNumber, *FifthLessonDuration,*FifthLesson,*SixthLessonNumber,*SixthLessonDuration,*SixthLesson,*SeventhLessonNumber,*SeventhLessonDuration,*SeventhLesson,*EighthLessonNumber,*EighthLessonDuration,*EighthLesson;
@end
