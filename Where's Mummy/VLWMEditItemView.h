//
//  VLWMEditItemView.h
//  Where's Mummy
//
//  Created by Vu Long on 30/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysImageCropperViewController.h"
@class VLWMItemData;
@interface VLWMEditItemView : UIViewController <UzysImageCropperDelegate>
@property (weak, nonatomic) VLWMItemData *itemData;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *questionField;
//@property (weak, nonatomic) IBOutlet UIImageView *imageField;
@property (strong, nonatomic) UIImagePickerController * picker;
@property (strong, nonatomic) UzysImageCropperViewController * imageCroper;
@property (weak, nonatomic) IBOutlet UIButton *btRun;
@property (weak, nonatomic) IBOutlet UIButton *btShake;
@end
