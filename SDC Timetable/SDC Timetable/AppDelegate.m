//
//  AppDelegate.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/12/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
@implementation AppDelegate
@synthesize databasePath, timetable;
@synthesize timer;
@synthesize preactivateNotifications;
@synthesize lesson_name, notification_for_type, today;
@synthesize currentTime;
@synthesize lessonNotification;
@synthesize currentDayLessons, lessons_duration, formatted_lessons_duration;
@synthesize currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes, countOfMissingLessons, hour, minute;

-(void)create_database_tables:(int)index{
    char *errMsg;
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS DATABASE%i (ID INTEGER PRIMARY KEY AUTOINCREMENT, MONDAY TEXT, TUESDAY TEXT, WEDNESDAY TEXT, THURSDAY TEXT, FRIDAY TEXT)",index];
    const char *sql_stmt = [createSQL UTF8String];
    if (sqlite3_exec(timetable, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK) {
        for (int i=0;i<9;i++) {
            sqlite3_stmt *statement;
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO DATABASE%i (MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY) VALUES (\"\",\"\",\"\",\"\",\"\")",index];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(timetable, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {}
            sqlite3_finalize(statement);
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"63z2OEqJmBppBii6OrHik7uDJsr9Xqgp8IJVFqdh"
                  clientKey:@"rOp5JguDawLm8YmSHYpFUhllQrhtq3AFQqUj5wtV"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"timetable.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    const char *dbpath = [databasePath UTF8String];
    
    if ([filemgr fileExistsAtPath: databasePath] == NO) {
        if (sqlite3_open(dbpath, &timetable) == SQLITE_OK){
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS DATABASENAMES (ID INTEGER PRIMARY KEY AUTOINCREMENT, DATABASENAME TEXT, LASTROW INTEGER, FIRST TEXT, SECOND TEXT, THIRD TEXT, FOURTH TEXT, FIFTH TEXT, SIXTH TEXT, SEVENTH TEXT, EIGHTH TEXT, LUNCH TEXT)";
            if (sqlite3_exec(timetable, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK) {}
            for (int i=1;i<5;i++) {
                
                [self create_database_tables:i];
                
                sqlite3_stmt *statement;
                NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO DATABASENAMES (DATABASENAME, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, LUNCH, LASTROW) VALUES (\"\",\"00:00\n00:00\",\"00:00\n00:00\",\"00:00\n00:00\",\"00:00\n00:00\",\"00:00\n00:00\",\"00:00\n00:00\",\"00:00\n00:00\",\"00:00\n00:00\",\"00:00\n00:00\",%i)",1];
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(timetable, insert_stmt, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE) {}
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(timetable);
    }
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    [timer invalidate];
    [self start_Timer];
    return YES;
}

-(void)start_Timer {
    if ([[self.defaults objectForKey:@"NotificationForLesson"]isEqualToString:@"On"]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLocalNotifications) userInfo:nil repeats:YES];
    }
}

-(void)updateLocalNotifications {
    
    if ([[[UIApplication sharedApplication]scheduledLocalNotifications]count]!=0) {
    }
    else {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &timetable) == SQLITE_OK) {
            sqlite3_stmt *select_statement;
            NSString *select_querySQL = [NSString stringWithFormat:@"SELECT DATABASENAME, LASTROW, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, LUNCH FROM DATABASENAMES WHERE id=%d",1];
            const char *select_query_stmt = [select_querySQL UTF8String];
            if (sqlite3_prepare_v2(timetable, select_query_stmt, -1, &select_statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(select_statement) == SQLITE_ROW) {
                    NSString *object = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 0)];
                    int lastrow = sqlite3_column_int(select_statement, 1);
                    if (![object isEqualToString:@""]) {
                        
                        NSArray *majors = [[NSArray alloc]initWithObjects:@"Translation Studies",@"Accounting",@"Economics", @"Finance", @"Marketing", @"Management", @"IT", nil];
                        int majorsCount = 0;
                        for (NSString *major in majors) {
                            if ([object rangeOfString:major options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                majorsCount++;
                            }
                        }
                        if (majorsCount==0) {
                            notification_for_type = @"Teacher";
                        }
                        else {
                            notification_for_type = @"Student";
                        }
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Almaty"]];
                        
                        NSDate *date = [NSDate date];
                        
                        [dateFormat setDateFormat:@"HH"];
                        NSString *hour_string = [dateFormat stringFromDate:date];
                        hour = [hour_string intValue];
                        
                        [dateFormat setDateFormat:@"mm"];
                        NSString *minute_string = [dateFormat stringFromDate:date];
                        minute = [minute_string intValue];
                        
                        currentTime = [NSDate date];
                        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *dateComponants = [calendar components:
                                                            (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: currentTime];
                        currentTime = [calendar dateFromComponents:dateComponants];
                        [dateFormat setDateFormat:@"EEEE"];
                        [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
                        today = [dateFormat stringFromDate:currentTime];
                        
                        [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"kk_KZ"]];
                        
                        NSDateComponents *nextDaysComponents = [NSDateComponents new] ;
                        
                        BOOL predefineNotifications = NO;
                        
                        if ([today isEqualToString:@"Saturday"]) {
                            predefineNotifications = YES;
                            nextDaysComponents.day = 2;
                        }
                        else if ([today isEqualToString:@"Sunday"]) {
                            predefineNotifications = YES;
                            nextDaysComponents.day = 1;
                        }
                        else {
                            
                            NSString *lastLessonDurations = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 9)];
                            NSArray *arrayOfLastLessonDurations = [self formatLessonDurationBeforeUpdate:lastLessonDurations];
                            
                            if (hour>[[arrayOfLastLessonDurations objectAtIndex:2]intValue]||(hour==[[arrayOfLastLessonDurations objectAtIndex:2]intValue]&&minute>[[arrayOfLastLessonDurations objectAtIndex:3]intValue])) {
                                predefineNotifications = YES;
                                nextDaysComponents.day = 1;
                            }
                            arrayOfLastLessonDurations = nil;
                            
                        }
                        
                        if (predefineNotifications) {
                            currentTime = [calendar dateByAddingComponents:nextDaysComponents toDate:currentTime options:0] ;
                            [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
                            today = [dateFormat stringFromDate:currentTime];
                            [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"kk_KZ"]];
                        }
                        
                        lessons_duration = [[NSMutableArray alloc]initWithObjects:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 2)],[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 3)],[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 4)],[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 5)],[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 6)],[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 7)],[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 8)],[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 9)],[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(select_statement, 10)], nil];
                        
                        currentDayLessons = [NSMutableArray new];
                        countOfMissingLessons = 0;
                        
                        [self getLesson:1];
                        [self getLesson:2];
                        [self getLesson:3];
                        [self getLesson:4];
                        [self getLesson:5];
                        [self getLesson:6];
                        [self getLesson:7];
                        [self getLesson:8];
                        [self getLesson:9];
                        
                        if (countOfMissingLessons==9) {
                            //FATAL ERROR
                            [timer invalidate];
                            [self.defaults setObject:@"Off" forKey:@"NotificationForLesson"];
                            [[[UIAlertView alloc]initWithTitle:@"FATAL ERROR" message:@"Smth wrong occured on the server, perhaps the durations of your lessons are badly constructed, please warn the person who is responsible for managing schedules about it immediately, otherwise you won't be able to use this feature" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                        }
                        else {
                            
                            for (int i=0;i<[currentDayLessons count];i++) {
                                if ([currentDayLessons objectAtIndex:i]&&![[currentDayLessons objectAtIndex:i]isEqualToString:@""]&&([[currentDayLessons objectAtIndex:i] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Bon appetit" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Приятного аппетита" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Afiyet olsun" options:NSCaseInsensitiveSearch].location!= NSNotFound)) {
                                    for (int j=i;j<[currentDayLessons count]-1;j++) {
                                        [lessons_duration exchangeObjectAtIndex:j withObjectAtIndex:[lessons_duration count]-1];
                                    }
                                    break;
                                }
                            }
                            
                            formatted_lessons_duration = [NSMutableArray new];
                            
                            for (int i=0;i<[lessons_duration count];i++) {
                                [formatted_lessons_duration addObject:[self formatLessonDurationBeforeUpdate:[lessons_duration objectAtIndex:i]]];
                            }
                            
                            if (!predefineNotifications) {
                                if (hour<=[[[formatted_lessons_duration objectAtIndex:0]objectAtIndex:0]intValue]&&minute<[[[formatted_lessons_duration objectAtIndex:0]objectAtIndex:1]intValue]) {
                                    predefineNotifications = YES;
                                }
                            }
                            
                            if (!predefineNotifications) {
                                
                                if (![today isEqualToString:@"Saturday"]&&![today isEqualToString:@"Sunday"]) {
                                    BOOL foundLunch = NO;
                                    for (int i=0;i<lastrow;i++) {
                                        if ([currentDayLessons objectAtIndex:i]&&![[currentDayLessons objectAtIndex:i]isEqualToString:@""]) {
                                            if (!foundLunch&&([[currentDayLessons objectAtIndex:i] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Bon appetit" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Приятного аппетита" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Afiyet olsun" options:NSCaseInsensitiveSearch].location!= NSNotFound)) {
                                                if (hour<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]||(hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]&&minute<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue])) {
                                                    [self setNotification:[currentDayLessons objectAtIndex:i] setHour:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue] setMinutes:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]];
                                                }
                                                foundLunch = YES;
                                            }
                                            else {
                                                [self checkFelicitousTimeForArrayAtIndex:i];
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            else {
                                
                                BOOL foundLunch = NO;
                                
                                for (int i=0;i<lastrow;i++) {
                                    
                                    if ([currentDayLessons objectAtIndex:i]&&![[currentDayLessons objectAtIndex:i]isEqualToString:@""]) {
                                        
                                        if (([[currentDayLessons objectAtIndex:i] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Bon appetit" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Приятного аппетита" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i] rangeOfString:@"Afiyet olsun" options:NSCaseInsensitiveSearch].location!= NSNotFound)) {
                                            if (!foundLunch) {
                                                [self setNotification:[currentDayLessons objectAtIndex:i] setHour:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue] setMinutes:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]];
                                                foundLunch = YES;
                                            }
                                        }
                                        else {
                                            
                                            NSString *notificationText = @"";
                                            notificationText = [self formatLesson:[currentDayLessons objectAtIndex:i] begins:YES];
                                            if (![notificationText isEqualToString:@""]) {
                                                [self setNotification:notificationText setHour:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue] setMinutes:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]];
                                            }
                                            notificationText = [self formatLesson:[currentDayLessons objectAtIndex:i] begins:NO];
                                            if (![notificationText isEqualToString:@""]) {
                                                [self setNotification:notificationText setHour:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue] setMinutes:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:3]intValue]];
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }// for end
                                
                            }//else end
                            
                            //NSLog(@"%@",[[UIApplication sharedApplication]scheduledLocalNotifications]);
                            
                        }
                        
                    }
                }
            }
            sqlite3_finalize(select_statement);
        }
        sqlite3_close(timetable);
    }
}

-(NSString*)formatLesson:(NSString*)lesson begins:(BOOL)it_is_begin {
    NSString *targetName = @"", *assignment = @"";
    BOOL found = NO;
    for (int i=(int)[lesson length]-1;i>=0;i--) {
        if ([[NSCharacterSet newlineCharacterSet]characterIsMember:[lesson characterAtIndex:i]]) {
            targetName = [lesson substringWithRange:NSMakeRange(i+1, [lesson length]-(i+1))];
            assignment = [[[lesson substringWithRange:NSMakeRange(0, i)]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]componentsJoinedByString:@" "];
            found = YES;
            break;
        }
    }
    if (found) {
        if (it_is_begin) {
            if ([notification_for_type isEqualToString:@"Student"]) {
                lesson = [NSString stringWithFormat:@"Lesson %@ of %@ begins",assignment,targetName];
            }
            else {
                lesson = [NSString stringWithFormat:@"Lesson %@ for %@ begins",targetName,assignment];
            }
        }
        else {
            if ([notification_for_type isEqualToString:@"Student"]) {
                lesson = [NSString stringWithFormat:@"Lesson %@ of %@ is over",assignment,targetName];
            }
            else {
                lesson = [NSString stringWithFormat:@"Lesson %@ for %@ is over",targetName,assignment];
            }
        }
    }
    else {
        lesson = @"";
    }
    return lesson;
}

-(void)checkFelicitousTimeForArrayAtIndex:(int)i {
    NSString *notificationText = @"";
    if (hour<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]||(hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue]&&minute<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue])) {
        notificationText = [self formatLesson:[currentDayLessons objectAtIndex:i] begins:YES];
        if (![notificationText isEqualToString:@""]) {
            [self setNotification:notificationText setHour:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:0]intValue] setMinutes:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:1]intValue]];
        }
    }
    BOOL nextLunch = NO;
    if (hour<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue]||(hour==[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue]&&minute<[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:3]intValue])) {
        if (i+1<[currentDayLessons count]) {
            if (([[currentDayLessons objectAtIndex:i+1] rangeOfString:@"Ас болсын" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i+1] rangeOfString:@"Bon appetit" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i+1] rangeOfString:@"Приятного аппетита" options:NSCaseInsensitiveSearch].location!= NSNotFound||[[currentDayLessons objectAtIndex:i+1] rangeOfString:@"Afiyet olsun" options:NSCaseInsensitiveSearch].location!= NSNotFound)) {
                nextLunch = YES;
            }
        }
        if (!nextLunch) {
            notificationText = [self formatLesson:[currentDayLessons objectAtIndex:i] begins:NO];
            if (![notificationText isEqualToString:@""]) {
                [self setNotification:notificationText setHour:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:2]intValue] setMinutes:[[[formatted_lessons_duration objectAtIndex:i]objectAtIndex:3]intValue]];
            }
        }
    }
}

-(void)setNotification:(NSString*)text setHour:(int)assignedHour setMinutes:(int)assignedMinutes {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: currentTime];
    [components setHour: assignedHour];
    [components setMinute: assignedMinutes];
    NSDate *newDate = [gregorian dateFromComponents: components];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = newDate;
    notification.alertBody = text;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)get_Lesson_From_Database_At_Index:(int)i {
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM DATABASE%i WHERE id=%d",[today uppercaseString],1,i];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(timetable, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            lesson_name = [[NSString alloc] initWithUTF8String:(const char *)
                           sqlite3_column_text(statement, 0)];
        }
    }
    sqlite3_finalize(statement);
}

-(void)getLesson:(int)index {
    [self get_Lesson_From_Database_At_Index:index];
    if (!lesson_name) {
        lesson_name = @"";
        countOfMissingLessons++;
    }
    [currentDayLessons addObject:lesson_name];
}

-(NSArray*)formatLessonDurationBeforeUpdate:(NSString*)text {
    
    int counter = 0;
    int lastDecimalIndex = 0;
    
    currentBeginningHour = 0;
    currentBeginningMinutes = 0;
    currentFinishingHour = 0;
    currentFinishingMinutes = 0;
    
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
    
    NSArray *arrayOfValidDurations = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:currentBeginningHour],[NSNumber numberWithInt:currentBeginningMinutes],[NSNumber numberWithInt:currentFinishingHour],[NSNumber numberWithInt:currentFinishingMinutes],nil];
    
    return arrayOfValidDurations;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        [[[UIAlertView alloc]initWithTitle:nil
                                   message:notification.alertBody
                                  delegate:self cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil]show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
