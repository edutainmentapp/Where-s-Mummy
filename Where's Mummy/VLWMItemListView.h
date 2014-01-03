//
//  VLWMItemListView.h
//  Where's Mummy
//
//  Created by Vu Long on 30/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VLWMGameData;
@interface VLWMItemListView : UIViewController
@property (strong) VLWMGameData *gameData;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *btLockStat;
@property (weak, nonatomic) IBOutlet UIButton *btNewStat;
@property (weak, nonatomic) IBOutlet UIButton *btPriceTier;
@end
