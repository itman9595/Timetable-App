//
//  About_us.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 10/8/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "About_us.h"

@implementation About_us

- (void)go_to_Editor_Mode_Login {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
    }
    else {
        EditorModeLogin *editor_Mode_Login =
        [self.storyboard instantiateViewControllerWithIdentifier:
         @"EditorModeLogin"];
        [self presentViewController:editor_Mode_Login animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *secretPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(go_to_Editor_Mode_Login)];
    secretPress.minimumPressDuration = 10.0;
    [self.editor_Menu_Button addGestureRecognizer:secretPress];
    
    if ([self.navigationController respondsToSelector:
         @selector(interactivePopGestureRecognizer)]) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    }
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //self.centerY.constant = -20;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 667.0f) {
            //iPhone 6
            
        }
        else  if (screenSize.height == 736.0f&&(newOrientation == UIInterfaceOrientationPortrait || newOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
            //iPhone 6 Plus
            self.thanx_Width.constant = 400;
            self.thanx_Height.constant = 30;
            [self.thanx_Label setFont:[UIFont fontWithName:@"Didot-Bold" size:24]];
            self.copyright_Width.constant = 400;
            self.copyright_Height.constant = 100;
            [self.copyright_Label setFont:[UIFont systemFontOfSize:20]];
            self.sdc_Width.constant = 280;
            self.sdc_Height.constant = 30;
            [self.SDC.titleLabel setFont:[UIFont systemFontOfSize:24]];
        }
        else  if (screenSize.width == 736.0f&&(newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight)) {
            //iPhone 6 Plus
            self.thanx_Width.constant = 400;
            self.thanx_Height.constant = 30;
            [self.thanx_Label setFont:[UIFont fontWithName:@"Didot-Bold" size:24]];
            self.copyright_Width.constant = 480;
            self.copyright_Height.constant = 80;
            [self.copyright_Label setFont:[UIFont systemFontOfSize:20]];
            self.sdc_Width.constant = 280;
            self.sdc_Height.constant = 30;
            [self.SDC.titleLabel setFont:[UIFont systemFontOfSize:24]];
        }
    }
    else {
        self.thanx_Width.constant = 540;
        self.thanx_Height.constant = 60;
        [self.thanx_Label setFont:[UIFont fontWithName:@"Didot-Bold" size:30]];
        self.copyright_Width.constant = 600;
        self.copyright_Height.constant = 144;
        [self.copyright_Label setFont:[UIFont systemFontOfSize:28]];
        self.sdc_Width.constant = 360;
        self.sdc_Height.constant = 36;
        [self.SDC.titleLabel setFont:[UIFont systemFontOfSize:30]];
    }
}

- (IBAction)go_to_SDC:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://vk.com/sdckz"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
