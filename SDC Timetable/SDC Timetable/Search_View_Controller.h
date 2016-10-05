//
//  Search_View_Controller.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/20/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <sqlite3.h>
#import "updateDatabase.h"
@interface Search_View_Controller : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate> {
    BOOL elements_exist;
    BOOL students_Are_Ready_To_Be_Displayed, teachers_Are_Ready_To_Be_Displayed, students_List_Has_Been_Processed, teachers_List_Has_Been_Processed, name_Added_To_List, timer_Has_Been_Launched;
}
@property (strong, nonatomic) PFQuery *query;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *studentsResultsTableViewController,
*teachersResultsTableViewController;
@property (strong, nonatomic) NSMutableArray *existing_students, *students_existing_names, *students_existing_surnames, *students_full_Name, *students_names, *students_surnames, *existing_teachers ,*teachers_existing_names, *teachers_existing_surnames, *teachers_existing_class_names;
@property (strong, nonatomic) NSMutableArray *filtered_existing_students, *filtered_students_groups, *filtered_existing_teachers, *filtered_teachers_existing_class_names;
@property (strong, nonatomic) NSMutableArray *students_Group_Titles;
@property (strong, nonatomic) NSMutableArray *partOfFilteredExistingPeople;
@property (strong, nonatomic) NSString *search_text_with_Letters_Only;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIView *dimmed_View;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) updateDatabase *updateIt;
-(void)create_Download_Signs;
@end
