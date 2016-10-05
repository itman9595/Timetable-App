//
//  updateDatabase.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/27/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "updateDatabase.h"
#import "Settings.h"
@implementation updateDatabase
@synthesize days,lessons_duration;
@synthesize currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes;
@synthesize lunchTimeIndex, lessonIndex, year;
@synthesize arrayOfLessonsDurations;
@synthesize timetable, databasePath;
@synthesize nameForTheDatabase;

-(void)initializeElementsForUpdate {
    days = [[NSMutableArray alloc]initWithObjects:@"Monday", @"Tuesday",  @"Wednesday", @"Thursday", @"Friday", nil];
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"timetable.db"]];
}

-(void)performUpdate:(NSString*)databaseName speciality_Text_Field_Text:(NSString*)speciality_Text_Field_Text year_Text_Field_Text:(NSString*)year_Text_Field_Text course_language_Text_Field:(NSString*)course_language_Text_Field options:(NSString*)option {
    self.query = [PFQuery queryWithClassName:databaseName];
    [self.query orderByAscending:@"SubjectNumber"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *lessons, NSError *error) {
        if (!error) {
            if ([lessons count]!=0) {
                
                int maximum_rows;
                
                if ([lessons count]<9) {
                    maximum_rows = (int)[lessons count]-1;
                }
                else {
                    
#pragma mark - THE MAXIMUM ROW SIZE IS 9, BECAUSE ONLY MAXIMUM 9 LESSONS AVAILABLE PER DAY
                    
                    maximum_rows = 8;
                }
                
                elements_exist = NO;
                endingRowOfDatabase = 0;

                for (int i=maximum_rows;i>=0;i--) {
                    PFObject *lesson = [lessons objectAtIndex:i];
                    for (NSString *day in days) {
                        
                        NSString *lesson_On_That_Day = lesson[day];
                        if (!lesson_On_That_Day) {
                            lesson_On_That_Day = @"";
                            
                        }
                        else {
                            if ([[NSCharacterSet decimalDigitCharacterSet]isSupersetOfSet:
                                 [NSCharacterSet characterSetWithCharactersInString:lesson_On_That_Day]]||
                                [[NSCharacterSet symbolCharacterSet]isSupersetOfSet:
                                 [NSCharacterSet characterSetWithCharactersInString:lesson_On_That_Day]]||
                                [[NSCharacterSet punctuationCharacterSet]isSupersetOfSet:
                                 [NSCharacterSet characterSetWithCharactersInString:lesson_On_That_Day]]) {
                                    lesson_On_That_Day = @"";
                                }
                        }
                        
                        if (![lesson_On_That_Day isEqualToString:@""]) {
                            endingRowOfDatabase = i;
                            elements_exist = YES;
                            i=-1;
                            break;
                        }
                    }
                }
                
                if (elements_exist) {
                    mainDatabasesHaveBeenUpdated = NO;
                    allowToUpdateOldValues1 = NO;
                    allowToUpdateOldValues2 = NO;
                    allowToUpdateOldValues3 = NO;
                    allowToUpdateOldValues4 = NO;
                    Database1WasChecked = NO;
                    const char *dbpath = [databasePath UTF8String];
                    
                    for (int i=1;i<=4;i++) {
                        if (i==2 && !allowToUpdateOldValues1) {
                            break;
                        }
                        else if (i==3 && !allowToUpdateOldValues2) {
                            break;
                        }
                        if (i==4 && !allowToUpdateOldValues3) {
                            break;
                        }
                        for (int j=0;j<=endingRowOfDatabase;j++) {
                            PFObject *lesson = [lessons objectAtIndex:j];
                            for (NSString *day in days) {
                                NSString *lesson_on_that_day = [self object:lesson day:day];
                                [self compareDatabaseAtIndex:i elementAtIndex:j+1 day:day lesson_on_that_day:lesson_on_that_day dbpath:dbpath];
                            }
                        }
                    }
                    
                    if (allowToUpdateOldValues1) {
                        for (int i=3;i>=1;i--) {
                            if (i == 1) {
                                if (allowToUpdateOldValues2) {
                                    for (int j=0;j<=8;j++) {
                                        for (NSString *day in days) {
                                            if (!unexpectedError) {
                                                [self replaceDatabaseAtIndex:i elementAtIndex:j+1 day:day dbpath:dbpath];
                                            }
                                        }
                                    }
                                }
                                for (int j=0;j<=endingRowOfDatabase;j++) {
                                    PFObject *lesson = [lessons objectAtIndex:j];
                                    for (NSString *day in days) {
                                        if (!unexpectedError) {
                                            NSString *lesson_on_that_day = [self object:lesson day:day];
                                            [self updateDatabaseAtIndex:i elementAtIndex:j+1 day:day lesson_on_that_day:lesson_on_that_day dbpath:dbpath];
                                        }
                                    }
                                }
                            }
                            else if (i == 2 && allowToUpdateOldValues3) {
                                for (int j=0;j<=8;j++) {
                                    for (NSString *day in days) {
                                        if (!unexpectedError) {
                                            [self replaceDatabaseAtIndex:i elementAtIndex:j+1 day:day dbpath:dbpath];
                                        }
                                    }
                                }
                            }
                            else if (i == 3 && allowToUpdateOldValues4) {
                                for (int j=0;j<=8;j++) {
                                    for (NSString *day in days) {
                                        if (!unexpectedError) {
                                            [self replaceDatabaseAtIndex:i elementAtIndex:j+1 day:day dbpath:dbpath];
                                        }
                                    }
                                }
                            }
                        }
                        
if (!unexpectedError) {
if ([option isEqualToString:@"Student_Settings"]) {
    nameForTheDatabase = [NSString stringWithFormat:@"%@ %@ %@", speciality_Text_Field_Text, year_Text_Field_Text, course_language_Text_Field];
}
else if ([option isEqualToString:@"Teacher_Settings"]){
    nameForTheDatabase = speciality_Text_Field_Text;
}
else if ([option isEqualToString:@"StudentSearching"]){
    nameForTheDatabase = speciality_Text_Field_Text;
}
else if ([option isEqualToString:@"TeacherSearching"]){
    nameForTheDatabase = speciality_Text_Field_Text;
}
    
    mainDatabasesHaveBeenUpdated = YES;
    for (int i=3;i>=1;i--) {
        if (i == 1) {
            if (allowToUpdateOldValues2) {
                [self replaceDatabaseAtIndex:i elementAtIndex:0 day:@"" dbpath:dbpath];
            }
            [self updateDatabaseAtIndex:i elementAtIndex:0 day:@"" lesson_on_that_day:nameForTheDatabase dbpath:dbpath];
        }
        else if (i == 2 && allowToUpdateOldValues3) {
            [self replaceDatabaseAtIndex:i elementAtIndex:0 day:@"" dbpath:dbpath];
        }
        else if (i == 3 && allowToUpdateOldValues4) {
            [self replaceDatabaseAtIndex:i elementAtIndex:0 day:@"" dbpath:dbpath];
        }
    }
    
self.query = [PFQuery queryWithClassName:@"LessonsDuration"];
[self.query orderByAscending:@"Year"];
[self.query findObjectsInBackgroundWithBlock:^(NSArray *listOfLessonsDurations, NSError *error) {

    if ([listOfLessonsDurations count]>=4) {
        
        lessons_duration = [NSMutableArray new];
        for (int i=0;i<9;i++) {
            [lessons_duration addObject:@"00:00\n00:00"];
        }
        year = 4;
        if ([databaseName rangeOfString:@"1" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            year = 0;
        }
        else if ([databaseName rangeOfString:@"2" options:NSCaseInsensitiveSearch].location != NSNotFound||
                 [option rangeOfString:@"Teacher" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            year = 1;
        }
        else if ([databaseName rangeOfString:@"3" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            year = 2;
        }
        else if ([databaseName rangeOfString:@"4" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            year = 3;
        }
        
        NSString *lunch = [lessons_duration objectAtIndex:0];
        NSString *firstLesson = lunch;
        NSString *secondLesson = lunch;
        NSString *thirdLesson = lunch;
        NSString *fourthLesson = lunch;
        NSString *fifthLesson = lunch;
        NSString *sixthLesson = lunch;
        NSString *seventhLesson = lunch;
        NSString *eighthLesson = lunch;
        
        if (year<4) {
            
            lunchTimeIndex = 0;
            
            for (int j=0;j<=endingRowOfDatabase;j++) {
                PFObject *lesson = [lessons objectAtIndex:j];
                NSString *lesson_on_that_day = [self object:lesson day:@"Monday"];
                if ([lesson_on_that_day rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location != NSNotFound||[lesson_on_that_day rangeOfString:@"Bon appetit" options:NSCaseInsensitiveSearch].location != NSNotFound||[lesson_on_that_day rangeOfString:@"Приятного аппетита" options:NSCaseInsensitiveSearch].location != NSNotFound||[lesson_on_that_day rangeOfString:@"Afiyet olsun" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    lunchTimeIndex = j;
                    break;
                }
            }
            
            arrayOfLessonsDurations = listOfLessonsDurations;
            lunch = [[arrayOfLessonsDurations objectAtIndex:year]
                     objectForKey:@"Lunch"];
            if (lunch&&![lunch isEqualToString:@""]) {
                lunch = [self formatLessonDurationBeforeUpdate:lunch];
                [lessons_duration replaceObjectAtIndex:lunchTimeIndex withObject:lunch];
            }
            else {
                lunch = @"00:00\n00:00";
            }
            
            lessonIndex = 0;
            firstLesson = [self setLessonDuration:@"First"];
            secondLesson = [self setLessonDuration:@"Second"];
            thirdLesson = [self setLessonDuration:@"Third"];
            fourthLesson = [self setLessonDuration:@"Fourth"];
            fifthLesson = [self setLessonDuration:@"Fifth"];
            sixthLesson = [self setLessonDuration:@"Sixth"];
            seventhLesson = [self setLessonDuration:@"Seventh"];
            eighthLesson = [self setLessonDuration:@"Eighth"];
            
        }
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
            NSString *updateQuerySQL;
            sqlite3_stmt *update_query_statement;
            
            updateQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASENAMES SET FIRST=\"%@\",SECOND=\"%@\",THIRD=\"%@\",FOURTH=\"%@\",FIFTH=\"%@\",SIXTH=\"%@\",SEVENTH=\"%@\",EIGHTH=\"%@\",LUNCH=\"%@\" WHERE id=\"%d\"",firstLesson,secondLesson,thirdLesson,fourthLesson,fifthLesson,sixthLesson,seventhLesson,eighthLesson,lunch,1];
            
            const char *update_query_stmt = [updateQuerySQL UTF8String];
            sqlite3_prepare_v2(timetable, update_query_stmt, -1, &update_query_statement, NULL);
            if (sqlite3_step(update_query_statement) == SQLITE_DONE) {}
            sqlite3_finalize(update_query_statement);
        }
        sqlite3_close(timetable);
        
    }
    
    [self terminateUdpate:option];
    
}];
}
else {
[self error:@"Unexpected error has been occurred. It seems like that the application stops working properly, please try to update the timetable again or reinstall the application or update it to the newer version, to dispose an encountered issue."];
                            unexpectedError = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScrollForTeachersSettings" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDatabase" object:nil];
}
}
else {
    if ([option isEqualToString:@"Student_Settings"]||[option isEqualToString:@"StudentSearching"]) {
        [self error:@"You Have Already Updated Timetable For The Group!"];
    }
    else if ([option isEqualToString:@"Teacher_Settings"]||[option isEqualToString:@"TeacherSearching"]){
        [self error:@"You Have Already Updated Timetable For The Teacher!"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScrollForTeachersSettings" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDatabase" object:nil];
}
                }
                else {
                    if ([option isEqualToString:@"Student_Settings"]) {
                        [self error:@"The group you have chosen either doesn't exist, or the timetable is still being updating and has to be ready very soon. Please, check it out again later."];
                    }
                    else if ([option isEqualToString:@"Teacher_Settings"]||[option isEqualToString:@"StudentSearching"]||[option isEqualToString:@"TeacherSearching"]){
                        [self error:@"The timetable either doesn't exist, or it is still being updating and has to be ready very soon. Please, check it out again later."];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDatabase" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScrollForTeachersSettings" object:nil];
                }
            }
            else if ([lessons count]==0) {
                if ([option isEqualToString:@"Student_Settings"]) {
                    [self error:@"The timetable of the group you have chosen doesn't exist yet. Check it out again later."];
                }
                else if ([option isEqualToString:@"Teacher_Settings"]||[option isEqualToString:@"StudentSearching"]||[option isEqualToString:@"TeacherSearching"]){
                    [self error:@"The timetable doesn't exist yet. Check it out again later."];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDatabase" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScrollForTeachersSettings" object:nil];
            }
        }
        else {
            [self error:@"Failed to update the timetable"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDatabase" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScrollForTeachersSettings" object:nil];
        }
    }];
}

-(void)terminateUdpate:(NSString*)option {
    if ([option isEqualToString:@"Student_Settings"]) {
        [self error:[NSString stringWithFormat:@"The Timetable For\n%@\n Has Been Successfully Updated", nameForTheDatabase]];
    }
    else if ([option isEqualToString:@"Teacher_Settings"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"submit_Choice" object:nil];
    }
    else if ([option isEqualToString:@"StudentSearching"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTimetable" object:nil userInfo:@{@"Person":@"Student"}];
    }
    else if ([option isEqualToString:@"TeacherSearching"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTimetable" object:nil userInfo:@{@"Person":@"Teacher"}];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScrollForTeachersSettings" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDatabase" object:nil];
}

-(NSString*)setLessonDuration:(NSString*)key {
    NSString *lessonNumber;
    if (lessonIndex == lunchTimeIndex) {
        lessonIndex++;
    }
    if (lessonIndex<9) {
        lessonNumber = [[arrayOfLessonsDurations objectAtIndex:year]
                                  objectForKey:key];
        if (lessonNumber&&![lessonNumber isEqualToString:@""]) {
            lessonNumber = [self formatLessonDurationBeforeUpdate:lessonNumber];
            [lessons_duration replaceObjectAtIndex:lessonIndex withObject:lessonNumber];
        }
        else {
             lessonNumber = @"00:00\n00:00";
        }
        lessonIndex++;
    }
    return lessonNumber;
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

-(void)compareDatabaseAtIndex:(int)i elementAtIndex:(int)j day:(NSString*)day lesson_on_that_day:(NSString*)
lesson_on_that_day dbpath:(const char*)dbpath {
    if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
        if (Database1WasChecked) {
            i--;
        }
        
        sqlite3_stmt *select_statement;
        NSString *selectQuerySQL = [NSString stringWithFormat:@"SELECT %@ FROM DATABASE%i WHERE id=%d",
                                    [day uppercaseString],i,j];
        
        const char *select_query_stmt = [selectQuerySQL UTF8String];
        if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(select_statement) == SQLITE_ROW) {
                NSString *object = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                if (!Database1WasChecked) {
                    if (![object isEqualToString:lesson_on_that_day]) {
                        allowToUpdateOldValues1 = YES;
                    }
                    if (j==endingRowOfDatabase+1 && [day isEqualToString:@"Friday"]) {
                        
                        if (!allowToUpdateOldValues1) {
                            sqlite3_stmt *select_statement;
                            NSString *selectQuerySQL = [NSString stringWithFormat:@"SELECT LASTROW FROM DATABASENAMES WHERE id=%d",i];
                            const char *select_query_stmt = [selectQuerySQL UTF8String];
                            if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
                                if (sqlite3_step(select_statement) == SQLITE_ROW) {
                                    int lastrow = sqlite3_column_int(select_statement, 0);
                                    if (lastrow!=endingRowOfDatabase+1) {
                                        allowToUpdateOldValues1 = YES;
                                    }
                                }
                            }
                            sqlite3_finalize(select_statement);
                        }
                        Database1WasChecked = YES;
                    }
                    
                }
                else {
                    
                    sqlite3_stmt *another_select_statement;
                    NSString *anotherSelectQuerySQL = [NSString stringWithFormat:@"SELECT %@ FROM DATABASE%i WHERE id=%d",
                                                       [day uppercaseString],i+1,j];
                    
                    const char *another_select_query_stmt = [anotherSelectQuerySQL UTF8String];
                    if (sqlite3_prepare_v2(timetable, another_select_query_stmt, -1, &another_select_statement, NULL) == SQLITE_OK) {
                        if (sqlite3_step(another_select_statement) == SQLITE_ROW) {
                            NSString *another_object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(another_select_statement, 0)];
                            if (![object isEqualToString:another_object]) {
                                if (i == 1) {
                                    allowToUpdateOldValues2 = YES;
                                }
                                else if (i == 2) {
                                    allowToUpdateOldValues3 = YES;
                                }
                                else {
                                    allowToUpdateOldValues4 = YES;
                                }
                            }
                        }
                    }
                    sqlite3_finalize(another_select_statement);
                }
            }
        }
        sqlite3_finalize(select_statement);
    }
    sqlite3_close(timetable);
}

-(void)updateDatabaseAtIndex:(int)i elementAtIndex:(int)j day:(NSString*)day lesson_on_that_day:(NSString*)
lesson_on_that_day dbpath:(const char*)dbpath {
    if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
        NSString *updateQuerySQL;
        sqlite3_stmt *update_query_statement;
        if (!mainDatabasesHaveBeenUpdated) {
            updateQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASE%i SET %@=\"%@\" WHERE id=\"%d\"", i, [day uppercaseString], lesson_on_that_day, j];
        }
        else {
            updateQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASENAMES SET DATABASENAME=\"%@\", LASTROW=%i WHERE id=\"%d\"", nameForTheDatabase, endingRowOfDatabase+1, i];
        }
        
        const char *update_query_stmt = [updateQuerySQL UTF8String];
        sqlite3_prepare_v2(timetable, update_query_stmt, -1, &update_query_statement, NULL);
        if (sqlite3_step(update_query_statement) == SQLITE_DONE) {}
        else {
            unexpectedError = YES;
        }
        sqlite3_finalize(update_query_statement);
    }
    sqlite3_close(timetable);
}

-(void)replaceDatabaseAtIndex:(int)i elementAtIndex:(int)j day:(NSString*)day dbpath:(const char*)dbpath {
    if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
        sqlite3_stmt *select_statement;
        NSString *selectQuerySQL;
        if (!mainDatabasesHaveBeenUpdated) {
            selectQuerySQL  = [NSString stringWithFormat:@"SELECT %@ FROM DATABASE%i WHERE id=%d",
                               [day uppercaseString],i,j];
        }
        else {
            selectQuerySQL = [NSString stringWithFormat:@"SELECT DATABASENAME, LASTROW, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, LUNCH FROM DATABASENAMES WHERE id=%d",i];
        }
        
        const char *select_query_stmt = [selectQuerySQL UTF8String];
        if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(select_statement) == SQLITE_ROW) {
                NSString *nameForDatabase, *first, *second, *third, *fourth, *fifth, *sixth, *seventh, *eighth, *lunch, *object; int lastrow = 1;
                if (!mainDatabasesHaveBeenUpdated) {
                    object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                }
                else {
                    nameForDatabase = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                    lastrow = sqlite3_column_int(select_statement, 1);
                    first = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 2)];
                    second = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 3)];
                    third = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 4)];
                    fourth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 5)];
                    fifth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 6)];
                    sixth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 7)];
                    seventh = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 8)];
                    eighth = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 9)];
                    lunch = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 10)];
                }
                
                sqlite3_stmt *replace_query_statement;
                NSString *replaceQuerySQL;
                if (!mainDatabasesHaveBeenUpdated) {
                    replaceQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASE%i SET %@=\"%@\" WHERE id=\"%d\"", i+1, [day uppercaseString], object, j];
                }
                else {
                    replaceQuerySQL = [NSString stringWithFormat:@"UPDATE DATABASENAMES SET DATABASENAME=\"%@\", LASTROW=%i, FIRST=\"%@\",SECOND=\"%@\",THIRD=\"%@\",FOURTH=\"%@\",FIFTH=\"%@\",SIXTH=\"%@\",SEVENTH=\"%@\",EIGHTH=\"%@\",LUNCH=\"%@\" WHERE id=\"%d\"", nameForDatabase, lastrow, first, second, third, fourth, fifth, sixth, seventh, eighth, lunch, i+1];
                }
                const char *replace_query_stmt = [replaceQuerySQL UTF8String];
                sqlite3_prepare_v2(timetable, replace_query_stmt, -1, &replace_query_statement, NULL);
                if (sqlite3_step(replace_query_statement) == SQLITE_DONE) {}
                else {
                    unexpectedError = YES;
                }
                sqlite3_finalize(replace_query_statement);
            }
            else {
                unexpectedError = YES;
            }
        }
        sqlite3_finalize(select_statement);
    }
    sqlite3_close(timetable);
}

-(NSString*)object:(PFObject*)lesson day:(NSString*)day_title{
    if (!lesson[day_title]) {
        return @"";
    }
    
    NSString *refine = lesson[day_title];
    refine = [[refine componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet]invertedSet]]componentsJoinedByString:@""];
    if ([refine length]!=0) {
        refine = lesson[day_title];
        for (int j=(int)[refine length]-1;j>=0;j--) {
            if ([[NSCharacterSet letterCharacterSet]characterIsMember:[refine characterAtIndex:j]]) {
                refine = [refine stringByReplacingCharactersInRange:NSMakeRange(j+1, ([refine length])-(j+1)) withString:@""];
                refine = [self remove_characters:refine];
                j=-1;
            }
        }
        for (int i=0;i<[refine length]-1;i++) {
            if ([refine characterAtIndex:i]==',') {
                i++;
                while ([refine characterAtIndex:i]==' ') {
                    refine = [refine stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
                    i++;
                }
            }
        }
        refine = [[refine componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]]componentsJoinedByString:@"\n"];
    }
    else {
        refine = @"";
    }
    return refine;
}

-(NSString*)remove_characters:(NSString*)string {
    return [[string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"¡™£¢∞¶•ªº≠`Ω≈√Œ∑´®†¥¨ˆ“‘©˙˚¬…«∫˜≤≥÷.:;?!@§±#$%^*+=_(){}[]|\\/~"]]componentsJoinedByString:@""];
}

-(void)error:(NSString*)message{
    [[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

@end
