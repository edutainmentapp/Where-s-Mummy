//
//  VLWMViewNaviController.m
//  Where's Mummy
//
//  Created by Vu Long on 11/12/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMViewNaviController.h"

@interface VLWMViewNaviController ()

@end

@implementation VLWMViewNaviController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate {
    return NO;
//    if (self.topViewController != nil) return [self.topViewController shouldAutorotate];
//    else return [super shouldAutorotate];
}
////
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
////    if (self.topViewController != nil) return [self.topViewController supportedInterfaceOrientations];
////    else return [super supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//        return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
////    if (self.topViewController != nil) return [self.topViewController preferredInterfaceOrientationForPresentation];
////    else return [super preferredInterfaceOrientationForPresentation];
//}
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation     {
//    return (UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
//}
@end
