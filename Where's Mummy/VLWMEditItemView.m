//
//  VLWMEditItemView.m
//  Where's Mummy
//
//  Created by Vu Long on 30/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMEditItemView.h"
#import "VLWMItemData.h"
#import "VLWMItemInfo.h"
#import "UzysImageCropperViewController.h"
#import "VLWMItemCell.h"
#import <QuartzCore/QuartzCore.h>
#import "VLWMCameraLayer.h"
@interface VLWMEditItemView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger miRunMode;
    NSInteger miShakeMode;
}
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end
@implementation VLWMEditItemView
VLWMItemCell * sampleCell;
VLWMCameraLayer * cameraLayer;
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
    [self configureView];
}
- (void)configureView
{
    // Update the user interface for the detail item.
    if(self.itemData.itemInfo==nil)
        [self.itemData createBlankItemInfo:@"New Item" question:@""];
    if (self.itemData) {
        self.nameField.text = self.itemData.itemInfo.ItemName;
        self.questionField.text = self.itemData.itemInfo.ItemQuestion;
//        self.imageField.image = self.itemData.dispImage;
        
        miShakeMode = self.itemData.itemInfo.shakeStyle;
        NSString *newImgFile = [NSString stringWithFormat:@"a%d", miShakeMode];
        NSString * path = [[NSBundle mainBundle]pathForResource:newImgFile ofType:@"png"];
        UIImage * new = [UIImage imageWithContentsOfFile:path];
        [self.btShake setImage:new forState:UIControlStateNormal];

        miRunMode = self.itemData.itemInfo.runStyle;
        newImgFile = [NSString stringWithFormat:@"a%d", miRunMode];
        path = [[NSBundle mainBundle]pathForResource:newImgFile ofType:@"png"];
        new = [UIImage imageWithContentsOfFile:path];
        [self.btRun setImage:new forState:UIControlStateNormal];
    }
}
- (IBAction)nameFieldChanged:(id)sender {
    self.itemData.itemInfo.ItemName = self.nameField.text;
    [_itemData saveData];
}

- (IBAction)quesFieldChanged:(id)sender {
    self.itemData.itemInfo.ItemQuestion = self.questionField.text;
    [_itemData saveData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)addPicButtonTapped:(id)sender {
    if (self.picker == nil) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
//        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        self.picker.allowsEditing = NO;
    
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.picker.showsCameraControls = NO;
        self.picker.navigationBarHidden = YES;
        self.picker.toolbarHidden = YES;
        self.picker.wantsFullScreenLayout = YES;

        cameraLayer = [[VLWMCameraLayer alloc] initWithNibName:@"camera_overlay" bundle:nil];
        cameraLayer.pickerReference = self.picker;
        self.picker.cameraOverlayView = cameraLayer.view;
        self.picker.delegate = cameraLayer;

    }

    // Insert the overlay
    
    [self presentModalViewController:self.picker animated:NO];
    
//    [self presentModalViewController:_picker animated:YES];

    NSString * path = [[NSBundle mainBundle]pathForResource:@"pencil_close" ofType:@"jpg"];
//    UIImage * image = [UIImage imageWithContentsOfFile:path];
    
    _imageCroper = [[UzysImageCropperViewController alloc] initWithImage:[UIImage imageWithContentsOfFile:path] andframeSize:[UIScreen mainScreen].bounds.size
                                                             andcropSize:CGSizeMake(400, 400)];
    _imageCroper.delegate = self;
    _imageCroper.modalPresentationStyle = UIModalPresentationFullScreen;
}
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    UIImage *fullImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];

    NSString * path = [[NSBundle mainBundle]pathForResource:@"MaskedCircle" ofType:@"png"];
    UIImage * maskImage = [UIImage imageWithContentsOfFile:path];
    UIImage * maskedImage = [self maskImage:fullImage withMask:maskImage];
//    UIImage * storeImage = [self imageWithImage:maskedImage scaledToSize:(CGSizeMake(100,100))];

    [sampleCell setPhoto:maskedImage width:100 height:100];
//    self.imageField.image = self.itemData.dispImage;
//    self.imageField.image = maskedImage;
    
    self.itemData.dispImage = maskedImage;
    [self.itemData saveImages];
//    [sampleCell setPhoto:self.itemData.dispImage width:100 height:100];
    

}
- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image {
    //Save Image here
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)tapRun:(id)sender {
//    [sampleCell aniCorrect];
    if(miRunMode<5)
        miRunMode ++;
    else
        miRunMode = 1;
    NSString *newImgFile = [NSString stringWithFormat:@"a%d", miRunMode];
    NSString * path = [[NSBundle mainBundle]pathForResource:newImgFile ofType:@"png"];
    UIImage * new = [UIImage imageWithContentsOfFile:path];
    [self.btRun setImage:new forState:UIControlStateNormal];
    [sampleCell stopAni];
    [self.collectionView reloadData];

    self.itemData.itemInfo.runStyle = miRunMode;
    [_itemData saveData];
}
- (IBAction)tapShake:(id)sender {
//    [sampleCell aniCorrect];
    if(miShakeMode<4)
        miShakeMode ++;
    else
        miShakeMode = 1;
    NSString *newImgFile = [NSString stringWithFormat:@"a%d", miShakeMode];
    NSString * path = [[NSBundle mainBundle]pathForResource:newImgFile ofType:@"png"];
    UIImage * new = [UIImage imageWithContentsOfFile:path];
    [self.btShake setImage:new forState:UIControlStateNormal];
    [sampleCell stopAni];
    [self.collectionView reloadData];
    self.itemData.itemInfo.shakeStyle = miShakeMode;
    [_itemData saveData];
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    sampleCell = [cv dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];
//    VLWMItemData *item = [self.masterItemDataList objectAtIndex:indexPath.row];
//    [cell setPhoto:item.dispImage width:fItemDispSize height:fItemDispSize];
    [sampleCell setPhoto:self.itemData.dispImage width:100 height:100];
    if(miRunMode>0&&miShakeMode>0)
        [sampleCell startAni:miRunMode shakeType:miShakeMode];
    return sampleCell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.picker == nil) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        //        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.allowsEditing = NO;
    }
    [self presentModalViewController:_picker animated:YES];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"pencil_close" ofType:@"jpg"];
    
    _imageCroper = [[UzysImageCropperViewController alloc] initWithImage:[UIImage imageWithContentsOfFile:path] andframeSize:[UIScreen mainScreen].bounds.size
                                                             andcropSize:CGSizeMake(400, 400)];
    _imageCroper.delegate = self;
    _imageCroper.modalPresentationStyle = UIModalPresentationFullScreen;
}
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
	CGImageRef maskRef = maskImage.CGImage;
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    CGImageRelease(mask);
    
    UIImage * returnImage= [UIImage imageWithCGImage:masked];
    CGImageRelease(maskRef);

    UIGraphicsBeginImageContext(CGSizeMake(returnImage.size.width,returnImage.size.height));
    [returnImage drawInRect:CGRectMake(0,0,returnImage.size.width,returnImage.size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

	return newImage;
    
}
-(IBAction)dismissView:(id)sender
{
        [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotate {
    return NO;
}

@end
