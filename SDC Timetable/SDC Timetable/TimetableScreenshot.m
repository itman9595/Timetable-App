//
//  TimetableScreenshot.m
//  SDC Timetable
//
//  Created by Geek_Enigma on 11/27/14.
//  Copyright (c) 2014 Dimension. All rights reserved.
//

#import "TimetableScreenshot.h"

@interface TimetableScreenshot ()

@end

@implementation TimetableScreenshot

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"takeScreenshot" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.FirstLesson setText:@""];[self.FirstLessonDuration setText:@""];
    [self.SecondLesson setText:@""];[self.SecondLessonDuration setText:@""];
    [self.ThirdLesson setText:@""];[self.ThirdLessonDuration setText:@""];
    [self.FourthLesson setText:@""];[self.FourthLessonDuration setText:@""];
    [self.FifthLesson setText:@""];[self.FifthLessonDuration setText:@""];
    [self.SixthLesson setText:@""];[self.SixthLessonDuration setText:@""];
    [self.SeventhLesson setText:@""];[self.SeventhLessonDuration setText:@""];
    [self.EighthLesson setText:@""];[self.EighthLessonDuration setText:@""];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"takeScreenshot" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenshot) name:@"takeScreenshot" object:nil];
}

-(void)takeScreenshot {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"takeScreenshot" object:nil];
    CGFloat totalHeight = self.CreatedDate.frame.origin.y+self.CreatedDate.frame.size.height;
    CGRect frameOfLessonNumber, frameOfLessonDuration, frameOfLesson;
    if (![self.FirstLesson.text isEqualToString:@""]) {
        totalHeight+=self.FirstLesson.frame.size.height;
    }
    else {
        frameOfLessonNumber = [self.FirstLessonNumber frame];
        frameOfLessonDuration = [self.FirstLessonDuration frame];
        frameOfLesson = [self.FirstLesson frame];
        [self.SecondLessonNumber setFrame:frameOfLessonNumber];
        [self.SecondLessonDuration setFrame:frameOfLessonDuration];
        [self.SecondLesson setFrame:frameOfLesson];
        [self.FifthLessonNumber setFrame:CGRectZero];
        [self.FifthLessonDuration setFrame:CGRectZero];
        [self.FirstLesson setFrame:CGRectZero];
    }
    if (![self.SecondLesson.text isEqualToString:@""]) {
        totalHeight+=self.SecondLesson.frame.size.height;
    }
    else {
        frameOfLessonNumber = [self.SecondLessonNumber frame];
        frameOfLessonDuration = [self.SecondLessonDuration frame];
        frameOfLesson = [self.SecondLesson frame];
        [self.ThirdLessonNumber setFrame:frameOfLessonNumber];
        [self.ThirdLessonDuration setFrame:frameOfLessonDuration];
        [self.ThirdLesson setFrame:frameOfLesson];
        [self.SecondLessonNumber setFrame:CGRectZero];
        [self.SecondLessonDuration setFrame:CGRectZero];
        [self.SecondLesson setFrame:CGRectZero];
    }
    if (![self.ThirdLesson.text isEqualToString:@""]) {
        totalHeight+=self.ThirdLesson.frame.size.height;
    }
    else {
        frameOfLessonNumber = [self.ThirdLessonNumber frame];
        frameOfLessonDuration = [self.ThirdLessonDuration frame];
        frameOfLesson = [self.ThirdLesson frame];
        [self.FourthLessonNumber setFrame:frameOfLessonNumber];
        [self.FourthLessonDuration setFrame:frameOfLessonDuration];
        [self.FourthLesson setFrame:frameOfLesson];
        [self.ThirdLessonNumber setFrame:CGRectZero];
        [self.ThirdLessonDuration setFrame:CGRectZero];
        [self.ThirdLesson setFrame:CGRectZero];
    }
    if (![self.FourthLesson.text isEqualToString:@""]) {
        totalHeight+=self.FourthLesson.frame.size.height;
    }
    else {
        frameOfLessonNumber = [self.FourthLessonNumber frame];
        frameOfLessonDuration = [self.FourthLessonDuration frame];
        frameOfLesson = [self.FourthLesson frame];
        [self.FifthLessonNumber setFrame:frameOfLessonNumber];
        [self.FifthLessonDuration setFrame:frameOfLessonDuration];
        [self.FifthLesson setFrame:frameOfLesson];
        [self.FourthLessonNumber setFrame:CGRectZero];
        [self.FourthLessonDuration setFrame:CGRectZero];
        [self.FourthLesson setFrame:CGRectZero];
    }
    if (![self.FifthLesson.text isEqualToString:@""]) {
        totalHeight+=self.FifthLesson.frame.size.height;
    }
    else {
        frameOfLessonNumber = [self.FifthLessonNumber frame];
        frameOfLessonDuration = [self.FifthLessonDuration frame];
        frameOfLesson = [self.FifthLesson frame];
        [self.SixthLessonNumber setFrame:frameOfLessonNumber];
        [self.SixthLessonDuration setFrame:frameOfLessonDuration];
        [self.SixthLesson setFrame:frameOfLesson];
        [self.FifthLessonNumber setFrame:CGRectZero];
        [self.FifthLessonDuration setFrame:CGRectZero];
        [self.FifthLesson setFrame:CGRectZero];
    }
    if (![self.SixthLesson.text isEqualToString:@""]) {
        totalHeight+=self.SixthLesson.frame.size.height;
    }
    else {
        frameOfLessonNumber = [self.SixthLessonNumber frame];
        frameOfLessonDuration = [self.SixthLessonDuration frame];
        frameOfLesson = [self.SixthLesson frame];
        [self.SeventhLessonNumber setFrame:frameOfLessonNumber];
        [self.SeventhLessonDuration setFrame:frameOfLessonDuration];
        [self.SeventhLesson setFrame:frameOfLesson];
        [self.SixthLessonNumber setFrame:CGRectZero];
        [self.SixthLessonDuration setFrame:CGRectZero];
        [self.SixthLesson setFrame:CGRectZero];
    }
    if (![self.SeventhLesson.text isEqualToString:@""]) {
        totalHeight+=self.SeventhLesson.frame.size.height;
    }
    else {
        frameOfLessonNumber = [self.SeventhLessonNumber frame];
        frameOfLessonDuration = [self.SeventhLessonDuration frame];
        frameOfLesson = [self.SeventhLesson frame];
        [self.EighthLessonNumber setFrame:frameOfLessonNumber];
        [self.EighthLessonDuration setFrame:frameOfLessonDuration];
        [self.EighthLesson setFrame:frameOfLesson];
        [self.SeventhLessonNumber setFrame:CGRectZero];
        [self.SeventhLessonDuration setFrame:CGRectZero];
        [self.SeventhLesson setFrame:CGRectZero];
    }
    if (![self.EighthLesson.text isEqualToString:@""]) {
        totalHeight+=self.EighthLesson.frame.size.height;
    }
    else {
        frameOfLessonNumber = CGRectZero;
        frameOfLessonDuration = CGRectZero;
        frameOfLesson = CGRectZero;
        [self.EighthLessonNumber setFrame:frameOfLessonNumber];
        [self.EighthLessonDuration setFrame:frameOfLessonDuration];
        [self.EighthLesson setFrame:frameOfLesson];
    }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width, totalHeight), NO, [UIScreen mainScreen].scale); //retina display
    else
        UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, totalHeight));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshotimage, nil, nil, nil);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takeScreenshot) name:@"takeScreenshot" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
