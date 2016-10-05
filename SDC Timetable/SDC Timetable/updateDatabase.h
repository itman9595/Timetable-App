//
//  updateDatabase.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/27/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <sqlite3.h>
@interface updateDatabase : NSObject  {
    BOOL elements_exist, mainDatabasesHaveBeenUpdated, Database1WasChecked, allowToUpdateOldValues1, allowToUpdateOldValues2, allowToUpdateOldValues3, allowToUpdateOldValues4, unexpectedError;
    int endingRowOfDatabase;
}
@property (strong, nonatomic) PFQuery *query;
@property (strong, nonatomic) NSString *nameForTheDatabase;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *timetable;
@property (strong, nonatomic) NSMutableArray *days, *lessons_duration;
@property int currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes;
@property int lunchTimeIndex, lessonIndex, year;
@property (strong, nonatomic) NSArray *arrayOfLessonsDurations;
-(void)initializeElementsForUpdate;
-(void)performUpdate:(NSString*)databaseName speciality_Text_Field_Text:(NSString*)speciality_Text_Field_Text year_Text_Field_Text:(NSString*)year_Text_Field_Text course_language_Text_Field:(NSString*)course_language_Text_Field options:(NSString*)option;
@end
