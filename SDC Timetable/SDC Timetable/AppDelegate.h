//
//  AppDelegate.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 9/12/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *timetable;
@property (nonatomic) NSTimer *timer;
@property BOOL preactivateNotifications;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSString *lesson_name, *notification_for_type, *today;
@property (strong, nonatomic) NSDate *currentTime;
@property (strong, nonatomic) UILocalNotification *lessonNotification;
@property (strong, nonatomic) NSMutableArray *currentDayLessons, *lessons_duration,
*formatted_lessons_duration;
@property int currentBeginningHour, currentBeginningMinutes, currentFinishingHour, currentFinishingMinutes, countOfMissingLessons, hour, minute;
-(void)start_Timer;
@end
