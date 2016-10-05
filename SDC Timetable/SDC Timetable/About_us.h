//
//  About_us.h
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/8/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "EditorModeLogin.h"

@interface About_us : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thanx_Width, *thanx_Height,*copyright_Width, *copyright_Height, *sdc_Width, *sdc_Height, *centerY;
- (IBAction)go_to_SDC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *thanx_Label, *copyright_Label;
@property (weak, nonatomic) IBOutlet UIButton *SDC, *editor_Menu_Button;
@end
