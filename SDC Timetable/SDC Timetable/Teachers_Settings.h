//
//  Teachers_Settings.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/6/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "updateDatabase.h"
#import <Parse/Parse.h>
#import <sqlite3.h>
#import <MessageUI/MessageUI.h>
@interface Teachers_Settings : UITableViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) updateDatabase *updateIt;
@property (strong, nonatomic) UIView *dimmed_View;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSMutableArray *teachers;
@property (strong, nonatomic) NSMutableArray *teachersClass;
@property (strong, nonatomic) NSMutableArray *teachersEmails;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) PFQuery *query;
@property (nonatomic) CGFloat clickedX;
@end
