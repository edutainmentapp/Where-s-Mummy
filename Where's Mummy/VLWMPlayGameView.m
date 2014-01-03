//
//  VLWMPlayGameView.m
//  Where's Mummy
//
//  Created by Vu Long on 01/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "VLWMPlayGameView.h"
#import "VLWMItemCell.h"
#import "VLWMItemData.h"
#import "VLWMItemInfo.h"
#import "VLWMGameData.h"
#import "VLWMGameInfo.h"
#import "NSMutableArray+Shuffle.h"
#import "VLWMCustomProgress.h"
#import "VLWMAppDelegate.h"
@interface VLWMPlayGameView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    float cellWidthSize;
    float cellHeighSize;
    float collectViewBorder;
    float fItemDispSize;
    SystemSoundID correctSound;
    SystemSoundID levelDoneSound;
    SystemSoundID currentQuestion;
//    SystemSoundID dftQuesSound;
    AVSpeechSynthesizer * mSynthesizer;
    NSMutableArray *playIdxQueue;
    NSMutableArray *dftQuestionList;
    int  miPlayingItemIdx;
    NSInteger miBatchSize;
    NSInteger miCorrectAnsCount;
    NSTimer *repeatQuesTime;
    UIImage *bgImage;
    UIImage *countViewImg;
    IBOutlet UIImageView *doneCount;
}
@property (nonatomic, copy) NSMutableArray *masterItemDataList;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@end

@implementation VLWMPlayGameView
static    SystemSoundID curAnswSound;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        NSLog(@"New view controller was pushed");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        NSLog(@"View controller was popped");
    }
}
- (NSInteger)getItemDispNum
{
    return 8;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    float   angle = M_PI/2;  //rotate 180°, or 1 π radians
    self.view.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);

    NSString * path = [[NSBundle mainBundle]pathForResource:@"answ_R" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    CFURLRef inFileURL = (CFURLRef)CFBridgingRetain(url);
    OSStatus errorCode = AudioServicesCreateSystemSoundID(inFileURL, &correctSound);
    
    path = [[NSBundle mainBundle]pathForResource:@"leveldone" ofType:@"caf"];
    url = [NSURL fileURLWithPath:path];
    inFileURL = (CFURLRef)CFBridgingRetain(url);
    errorCode = AudioServicesCreateSystemSoundID(inFileURL, &levelDoneSound);
    
//    path = [[NSBundle mainBundle]pathForResource:@"whereis" ofType:@"caf"];
//    url = [NSURL fileURLWithPath:path];
//    inFileURL = (CFURLRef)CFBridgingRetain(url);
//    errorCode = AudioServicesCreateSystemSoundID(inFileURL, &dftQuesSound);
    
    [self.gameData loadItemData:YES];
    if([(VLWMAppDelegate *)[UIApplication sharedApplication].delegate fileExists:self.gameData.bgImgPath])
    {
        bgImage = [UIImage imageWithContentsOfFile:self.gameData.bgImgPath];
        if(bgImage!=nil)
            _bgImageView.image = bgImage;
    }
    collectViewBorder = 1;
    float displayWidth = (SCREEN_WIDTH-collectViewBorder-(4)*1);
    cellWidthSize = displayWidth/4;
    
    float viewHeight = self.collectionView.frame.size.height;
    float displayHeight = viewHeight - (collectViewBorder*2)-(2*1);
    cellHeighSize = displayHeight/2;

    fItemDispSize = cellWidthSize<cellHeighSize?cellWidthSize/2:cellHeighSize/2;
    NSLog(@"cell size %f, %f",cellWidthSize,cellHeighSize);
    NSLog(@"item size %f",fItemDispSize);
    
//    CGRect rec = CGRectMake(0, 0, SCREEN_HEIGHT,SCREEN_WIDTH);
//    VLWMCustomProgress * pro = [[VLWMCustomProgress alloc] initWithFrame:rec];
//    [pro show];
    //    self.masterItemDataList = self.gameData.itemList;
//    NSLog(@"Number of item %lu",(unsigned long)self.gameData.itemList.count);
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadNextBatch];
}
- (void)viewDidAppear:(BOOL)animated
{
//    for(VLWMItemCell *cell in self.collectionView.visibleCells){
//        [cell startIdleAni];
//    }
    [self playNextItem];
}
- (void)dealloc
{
    [self cleanUpBeforeExit];
}
- (BOOL)loadNextBatch
{
    miCorrectAnsCount = 0;
    [self changeCountView];
    self.masterItemDataList = [self.gameData getNextBatch:YES];
    if(self.masterItemDataList.count<=0)
        return NO;
    miBatchSize = [self getItemDispNum];
    playIdxQueue = [NSMutableArray array];
    for (int i=0; i<self.masterItemDataList.count ; i ++) {
        [playIdxQueue addObject:[NSNumber numberWithInt:i]];
    }
    [playIdxQueue shuffleArray];
    
    [self.collectionView reloadData];
    
    return YES;
}
- (void)playNextItem
{
    if(miCorrectAnsCount<self.masterItemDataList.count)
    {
        if(repeatQuesTime!=nil)
        {
            [repeatQuesTime invalidate];
            repeatQuesTime = nil;
        }
        miPlayingItemIdx = [[playIdxQueue objectAtIndex:miCorrectAnsCount] intValue];
        NSLog(@"Playing index: %i",miPlayingItemIdx);
        VLWMItemData *currentItem = [self.masterItemDataList objectAtIndex:miPlayingItemIdx];
        if(currentQuestion!=0)
            releaseSound(currentQuestion);
        currentQuestion = [self createSound:[currentItem getQuesSoundID]];
        if(curAnswSound!=0)
            releaseSound(curAnswSound);
        curAnswSound = [self createSound:[currentItem getAnswSoundID]];
        if(currentQuestion==0)
//            [self playQuesNAnsw:dftQuesSound];
            [self textToSpeech:[self nextQuestion:currentItem.itemInfo.ItemName]];
        else
            [self playSound:currentQuestion];
        self.hintView.image = currentItem.dispImage;
        repeatQuesTime =[NSTimer scheduledTimerWithTimeInterval:20
                                                      target:self
                                                       selector:@selector(timeOut:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    else
    {
        [self playSound:levelDoneSound];
        if([self.gameData hasMoreItem])
        {
            for(VLWMItemCell *cell in self.collectionView.visibleCells){
                [cell stopAni];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LEVEL FINISHED" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Next",nil];
            
            UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 250, 100)];
            someTextView.backgroundColor = [UIColor clearColor];
            someTextView.textColor = [UIColor whiteColor];
            someTextView.editable = NO;
            someTextView.font = [UIFont systemFontOfSize:15];
            someTextView.text = @"Enter Text Here";
            [alert addSubview:someTextView];
            [alert show];
//            [self playNextItem];
        }
        else
        {
            [self.gameData saveGameData:nil priceTier:nil isNew:NO isComplete:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GAME FINISHED" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
            
            UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 250, 100)];
            someTextView.backgroundColor = [UIColor clearColor];
            someTextView.textColor = [UIColor whiteColor];
            someTextView.editable = NO;
            someTextView.font = [UIFont systemFontOfSize:15];
            someTextView.text = @"Enter Text Here";
            [alert addSubview:someTextView];
            [alert show];
            //DISPLAY COMPLETE AND GO TO NEXT GAME OR COME BACK TO GAME SELECTION
//            [self performSegueWithIdentifier: @"PlayGameToGameListSegue" sender: self];
        }
    }
}
-(void)timeOut:(NSTimer*)timer{
    //use sound
    [self playSound:currentQuestion];
    //use Siri
//    [self textToSpeech:[self nextQuestion:currentItem.itemInfo.ItemName]];
    
//    static int count = 0;
//    count++;
//    if(count == 60){
//        [timer invalidate];
//        timer = nil;
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.masterItemDataList count];
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VLWMItemCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PlayItemCell" forIndexPath:indexPath];
    VLWMItemData *item = [self.masterItemDataList objectAtIndex:indexPath.row];
    [cell setPhoto:item.dispImage width:fItemDispSize height:fItemDispSize];
//    CGSize disSize = CGSizeMake(120, 120);
//    [self moveToLeft:cell.mainImageView finished:nil context:nil];
//    [cell setPhoto:item.dispImage size:&disSize];
//    [cell setTransLayerSecondView:@"round_halftrans_layer"];
    if(item.itemInfo.runStyle>0&&item.itemInfo.shakeStyle>0)
        [cell startAni:item.itemInfo.runStyle shakeType:item.itemInfo.shakeStyle];
    else
        [cell startIdleAni];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VLWMItemCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell stopAni];
    if(miPlayingItemIdx==indexPath.row)//SELECT CORRECT ITEM
    {
        [repeatQuesTime invalidate];
        repeatQuesTime = nil;
        [self playSound:correctSound];
//        [self aniSwingZ:cell.mainImageView.layer];
        [cell stopAni];
        [cell aniCorrect];
        miCorrectAnsCount ++;
        releaseSound(currentQuestion);
        [self changeCountView];
        [self playNextItem];
    }
    else//SELECT WRONG ITEM
    {
        VLWMItemData *item = [self.masterItemDataList objectAtIndex:indexPath.row];
        SystemSoundID answerSound = [self createSound:item.getAnswSoundID];
        if (answerSound==0)
            [self textToSpeech:item.itemInfo.ItemName];
        else
            [self playNReleaseSound:answerSound];
        [self aniShake:cell.mainImageView];
    }
    //ZOOM
//    [UIView animateWithDuration:1
//                          delay:0
//                        options:UIViewAnimationCurveEaseOut
//                     animations:^{
//                         cell.imageView.transform = CGAffineTransformMakeScale(2,2);
//                     }
//                     completion:^(BOOL finished) {
//                     }
//     ];
    
    //SHAKING
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.14];
//    [UIView setAnimationRepeatAutoreverses:YES];
//    [UIView setAnimationRepeatCount:10];
//    cell.imageView.transform = CGAffineTransformMakeRotation(69);
//    cell.imageView.transform = CGAffineTransformMakeRotation(-69);
//    [UIView commitAnimations];
//ROTATE
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.14];
//    [UIView setAnimationRepeatAutoreverses:YES];
//    [UIView setAnimationRepeatCount:10];
//    cell.imageView.transform = CGAffineTransformRotate(cell.imageView.transform, 90.0f);
////    [cell.imageView setTransform:CGAffineTransformRotate(cell.imageView.transform, 90.0f)];
//    [UIView commitAnimations];
    
//FULL ROTATION
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 /* full rotation*/ * 2 * 2 ];
//    rotationAnimation.duration = 10;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = 1.0;
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    [cell.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void) aniShake:(UIImageView *)view
{    
    [UIView animateWithDuration:0.14
                          delay:0
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^{
                         [UIView setAnimationRepeatAutoreverses:YES];
                         [UIView setAnimationRepeatCount:10];
                         view.transform = CGAffineTransformMakeRotation(69);
                         view.transform = CGAffineTransformMakeRotation(-69);
                     }
                     completion:^(BOOL finished) {
                         view.transform = CGAffineTransformMakeRotation(0);;
                     }
     ];
}
- (void) aniSwingZ:(CALayer *)layer
{
    //SWING IN Z
    CATransform3D rotationAndPerspectiveTransformR = CATransform3DIdentity;
    rotationAndPerspectiveTransformR.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformR = CATransform3DRotate(rotationAndPerspectiveTransformR, 60.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    CATransform3D rotationAndPerspectiveTransformL = CATransform3DIdentity;
    rotationAndPerspectiveTransformL.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformL = CATransform3DRotate(rotationAndPerspectiveTransformL, -60.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    CATransform3D resetView = CATransform3DIdentity;
    resetView.m34 = 1.0 / -500;
    resetView = CATransform3DRotate(resetView, 0.0f, 0.0f, 0.0f, 0.0f);
    [UIView animateWithDuration:1
                          delay:0
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^{
                         [UIView setAnimationRepeatAutoreverses:YES];
                         [UIView setAnimationRepeatCount:10];
                         layer.transform = rotationAndPerspectiveTransformR;
                         layer.transform = rotationAndPerspectiveTransformL;
                     }
                     completion:^(BOOL finished) {
                         layer.transform = resetView;
                     }
     ];

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
#pragma mark – UICollectionViewDelegateFlowLayout
// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        CGSize retval = CGSizeMake(cellWidthSize, cellHeighSize);
//    CGSize retval = CGSizeMake(100, 100);
//    VLWMItemData *item = [self.masterItemDataList objectAtIndex:indexPath.row];
//    CGSize retval = item.dispImage.size.width > 0 ? item.dispImage.size : CGSizeMake(100, 100);
//    retval.height += 35; retval.width += 35;
    return retval;
}
// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
-(SystemSoundID)createSound:(NSString *) strPath
{
    SystemSoundID itemSound;
    NSURL * fileUrl =[NSURL fileURLWithPath:strPath];
    NSError *err;
    if ([fileUrl checkResourceIsReachableAndReturnError:&err] == NO)
    {
        return 0;
    }
    else
    {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl,&itemSound);
        return itemSound;
    }
}
-(void)playSound:(SystemSoundID) ssID
{
	AudioServicesAddSystemSoundCompletion (ssID,NULL,NULL,nil,(__bridge void*) self);
	AudioServicesPlaySystemSound(ssID);
}
-(void)playNReleaseSound:(SystemSoundID) ssID
{
	AudioServicesAddSystemSoundCompletion (ssID,NULL,NULL,releaseSoundComplete,(__bridge void*) self);
	AudioServicesPlaySystemSound(ssID);
}
-(void)playQuesNAnsw:(SystemSoundID) ssID
{
	AudioServicesAddSystemSoundCompletion (ssID,NULL,NULL,playNextComplete,(__bridge void*) self);
	AudioServicesPlaySystemSound(ssID);
}
static void releaseSoundComplete (SystemSoundID  mySSID, void* myself)
{
    releaseSound(mySSID);
}
static void playNextComplete (SystemSoundID  mySSID, void* myself)
{
	AudioServicesAddSystemSoundCompletion (curAnswSound,NULL,NULL,releaseSoundComplete,myself);
	AudioServicesPlaySystemSound(curAnswSound);
}
void releaseSound(SystemSoundID ssID)
{
    AudioServicesRemoveSystemSoundCompletion (ssID);
    AudioServicesDisposeSystemSoundID(ssID);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self playChangeScreenSound];
    [self cleanUpBeforeExit];
}
-(void)cleanUpBeforeExit
{
    releaseSound(correctSound);
    releaseSound(levelDoneSound);
    releaseSound(currentQuestion);
    releaseSound(curAnswSound);
    self.gameData = nil;
    self.masterItemDataList = nil;
    if(repeatQuesTime!=nil)
    {
        [repeatQuesTime invalidate];
        repeatQuesTime = nil;
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier: @"PlayGameToGameListSegue" sender: self];
    }
    else{
        [self loadNextBatch];
        [self playNextItem];
    }
}
-(void)changeCountView
{
    NSString *newImgFile = [NSString stringWithFormat:@"done%d", miCorrectAnsCount];
    NSString * path = [[NSBundle mainBundle]pathForResource:newImgFile ofType:@"png"];
    if(countViewImg!=nil)
        countViewImg = nil;
    countViewImg = [UIImage imageWithContentsOfFile:path];
    if(countViewImg!=nil)
        doneCount.image = countViewImg;
}
- (void)playChangeScreenSound
{
    CFURLRef inFileURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"chime_medium" ofType:@"aac"]]);
    SystemSoundID ssID;
    AudioServicesCreateSystemSoundID(inFileURL, &ssID);
    AudioServicesAddSystemSoundCompletion (ssID,NULL,NULL,releaseSoundComplete,(__bridge void*) self);
    AudioServicesPlaySystemSound(ssID);
}
-(void)textToSpeech:(NSString *)strToSpeak
{
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:strToSpeak];
    [utterance setRate:0.1666f];
    [utterance setPitchMultiplier:1.55f];
    [[self localSynthesizer] speakUtterance:utterance];
    utterance = nil;
}
-(AVSpeechSynthesizer *)localSynthesizer
{
    if (mSynthesizer==nil)
        mSynthesizer = [[AVSpeechSynthesizer alloc]init];
    return mSynthesizer;
}
-(NSString *)nextQuestion:(NSString *)strObj
{
    if(dftQuestionList==nil)
    {
        NSString * ques1 = @"Where is ";
        NSString * ques2 = @"Which one is ";
        NSString * ques3 = @"Let's select ";
        NSString * ques4 = @"Let's pick up ";
        dftQuestionList = [NSMutableArray arrayWithObjects:ques1,ques2,ques3,ques4, nil];
    }
    NSUInteger randomIndex = arc4random() % [dftQuestionList count];
    NSString * strReturn = [dftQuestionList objectAtIndex:randomIndex];
    strReturn = [strReturn stringByAppendingString:strObj];
    return strReturn;
}
- (IBAction)dismissView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotate {
    return NO;
}

@end
