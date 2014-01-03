//
//  VLWMPlayListView.m
//  Where's Mummy
//
//  Created by Vu Long on 01/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//
#import "VLWMViewController.h"
#import "VLWMPlayListView.h"
#import "VLWMPlayGameView.h"
#import "VLWMItemCell.h"
#import "VLWMGameData.h"
#import "VLWMGameInfo.h"
#import "VLWMPackageData.h"
#include <AudioToolbox/AudioToolbox.h>
@interface VLWMPlayListView ()
{
    float cellWidthSize;
    float cellHeighSize;
    float collectViewBorder;
    int iMaxPage;
}
@property (copy) NSMutableArray *masterGameDataList;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
@end

@implementation VLWMPlayListView
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    float   angle = M_PI/2;  //rotate 180°, or 1 π radians
    self.view.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);

    //    float scaleFactor = [[UIScreen mainScreen] scale];
    collectViewBorder = 20;
    float displayWidth = (SCREEN_WIDTH-collectViewBorder-(VLWMViewController.miNoOfColum)*10);
    cellWidthSize = displayWidth/(VLWMViewController.miNoOfColum);

    float viewHeight = self.collectionView.frame.size.height;
    float displayHeight = viewHeight - (collectViewBorder*2)-(VLWMViewController.miNoOfRow)*10;
    cellHeighSize = displayHeight/VLWMViewController.miNoOfRow;

    if(self.masterGameDataList!=nil&&self.masterGameDataList.count>0)
    {
        [self.collectionView reloadData];
    }
    else
    {
        NSMutableArray *itemList = [VLWMPackageData loadGameData];
        self.masterGameDataList = itemList;
        [self.collectionView reloadData];
        
        //        iMaxPage = ceil(itemList.count/VLWMViewController.miNoOfItemOnScreen);
        int iMaxItemPerPage = VLWMViewController.miNoOfRow*VLWMViewController.miNoOfColum;
        iMaxPage = (itemList.count+iMaxItemPerPage-1)/(iMaxItemPerPage);
        [self.pageControl setNumberOfPages:iMaxPage];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        NSLog(@"x:%f",self.collectionView.contentOffset.x+SCREEN_WIDTH);
        NSLog(@"x:%f",self.collectionView.frame.size.width);
    int iPage = ceil(self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
    NSLog(@"x:%i",iPage);
    if(iPage>iMaxPage)
        iPage = iMaxPage;
    _pageControl.currentPage=iPage;
    
}
- (IBAction)returnToMain{
    [self setDoorImgBeforeClose];
    [self startCloseAni];
    [self playChangeScreenSound:@"chime_short"];
//    [self performSelector:@selector(popRootController) withObject:nil afterDelay:2.1f];
        [self dismissModalViewControllerAnimated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    if(_playAni)
    {
        [self performSelector:@selector(startOpenAni) withObject:nil afterDelay:1.5f];
        _playAni = NO;
    }
}
- (void)setDoorImgBeforeClose
{
    NSString * path = [[NSBundle mainBundle]pathForResource:[_mstrAniRes stringByAppendingString:@"L"] ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    CGRect leftFrame = self.leftDoor.frame;
    leftFrame.origin.x = -leftFrame.size.width;
    self.leftDoor.frame = leftFrame;
    self.leftDoor.image = image;

    path = [[NSBundle mainBundle]pathForResource:[_mstrAniRes stringByAppendingString:@"R"]  ofType:@"png"];
    image = [UIImage imageWithContentsOfFile:path];
    CGRect rightFrame = self.rightDoor.frame;
    rightFrame.origin.x = self.view.bounds.size.width;
    self.rightDoor.frame = rightFrame;
    self.rightDoor.image = image;
    
    image = nil;
}
- (void)setDoorImgBeforeOpen
{
    NSString * path = [[NSBundle mainBundle]pathForResource:[_mstrAniRes stringByAppendingString:@"L"] ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    self.leftDoor.image = image;
    path = [[NSBundle mainBundle]pathForResource:[_mstrAniRes stringByAppendingString:@"R"] ofType:@"png"];
    image = [UIImage imageWithContentsOfFile:path];
    self.rightDoor.image = image;
    image = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    if(_playAni)
    {
        [self setDoorImgBeforeOpen];
    }
    if(!_playAni)
    {
        self.leftDoor.image = nil;
//        [self.leftDoor removeFromSuperview];
        self.rightDoor.image = nil;
    }
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.masterGameDataList count];
//        return 8;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
//    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VLWMItemCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GameCell" forIndexPath:indexPath];
    VLWMGameData *item = [self.masterGameDataList objectAtIndex:indexPath.row];
//    VLWMGameData *item = [self.masterGameDataList objectAtIndex:indexPath.section*3 + indexPath.row];

    [cell setPhoto:item.dispImage];
//    if([item.gameInfo.GameType isEqualToString:@"P"]&&[item.gameInfo.priceTier isEqualToString:@"N"])
//    {
//        //Paid game and not paid yet. Show Game Locked with price tier
//        [cell setPrice:@"tier4"];
//    }
    if(item.gameInfo.lock == YES)
    {
        //Paid game and not paid yet. Show Game Locked with price tier
        [cell setPrice:@"tier4"];
    }
    else{
        if(item.gameInfo.isNew)
            [cell markNew];
        else if(item.gameInfo.isCompleted)
            [cell setPlayed];
    }
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self playChangeScreenSound:@"chime_medium"];
    VLWMGameData *gameData = [self.masterGameDataList objectAtIndex:indexPath.row];
    VLWMPlayGameView * gameView = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayGameView"];
    gameView.gameData = gameData;
    [self presentModalViewController:gameView animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
#pragma mark – UICollectionViewDelegateFlowLayout
// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(cellWidthSize, cellHeighSize);
    return retval;
}
// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(collectViewBorder, collectViewBorder, collectViewBorder, collectViewBorder);
}
#pragma mark - Prepare for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PlayGameSegue"])
    {
        [self playChangeScreenSound:@"chime_medium"];
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        VLWMGameData *gameData = [self.masterGameDataList objectAtIndex:indexPath.row];
        VLWMPlayGameView *playGameView = (VLWMPlayGameView *)segue.destinationViewController;
        playGameView.gameData = gameData;
    }
}
static void releaseSoundComplete (SystemSoundID  ssID, void* myself)
{
    AudioServicesRemoveSystemSoundCompletion (ssID);
    AudioServicesDisposeSystemSoundID(ssID);
}
- (void)playChangeScreenSound:(NSString*)sound
{
    CFURLRef inFileURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:sound ofType:@"aac"]]);
    SystemSoundID ssID;
    AudioServicesCreateSystemSoundID(inFileURL, &ssID);
    AudioServicesAddSystemSoundCompletion (ssID,NULL,NULL,releaseSoundComplete,(__bridge void*) self);
    AudioServicesPlaySystemSound(ssID);
}
- (void) startOpenAni
{
    CGRect leftFrame = self.leftDoor.frame;
    leftFrame.origin.x = -leftFrame.size.width;
    
    CGRect rightFrame = self.rightDoor.frame;
    rightFrame.origin.x = self.view.bounds.size.width;
    
    [UIView animateWithDuration:2.0
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.leftDoor.frame = leftFrame;
                         self.rightDoor.frame = rightFrame;
                     }
                     completion:^(BOOL finished){
//                         self.leftDoor.image = nil;
//                                                  self.rightDoor.image = nil;
                     }];
}
- (void) startCloseAni
{
    CGRect leftFrame = self.leftDoor.frame;
    leftFrame.origin.x = 0;
    
    CGRect rightFrame = self.rightDoor.frame;
    rightFrame.origin.x = 0;
    
    [UIView animateWithDuration:2.0
                          delay:0.1
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.leftDoor.frame = leftFrame;
                         self.rightDoor.frame = rightFrame;
                     }
                     completion:^(BOOL finished){
//                         self.leftDoor.image = nil;
//                         self.rightDoor.image = nil;
                     }];
}
//-(void)popRootController
//{
//    CATransition* transition = [CATransition animation];
//    transition.duration = .75;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade; //kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    transition.subtype = kCATransitionReveal;//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [[self navigationController].view.layer addAnimation:transition
//                                                  forKey:kCATransition];
//    [[self navigationController] popToRootViewControllerAnimated:YES];
//}
- (IBAction)unwindToPlayList:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[VLWMPlayGameView class]])
        sourceViewController = nil;
}
- (BOOL)shouldAutorotate {
    return NO;
}

@end
