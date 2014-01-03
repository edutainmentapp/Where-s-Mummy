//
//  VLWMItemCell.h
//  Where's Mummy
//
//  Created by Vu Long on 23/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

//#import <QuartzCore/QuartzCore.h>
//@class Cell; // Forward declare Custom Cell for the property
//
//@protocol MyMenuDelegate <NSObject>

//@optional
//- (void)customAction:(id)sender forCell:(Cell *)cell;
//@end
@interface VLWMItemCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) IBOutlet UIImageView *correctView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *playStatView;
@property (nonatomic, weak) IBOutlet UIImageView *purchStatView;
@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) id<MyMenuDelegate> delegate;
- (void)setPhoto:(UIImage *)image;
- (void)setPhoto:(UIImage *)image width:(float)fWid height:(float)fHei;
- (void)setLabel:(NSString *)name;
- (void)setPlayed;
- (void)markNew;
- (void)setPrice:(NSString*)priceTier;
- (void)setTransLayerSecondView:(NSString *)systemResource;
- (void)startIdleAni;
- (void)aniCorrect;
- (void)startAni:(NSInteger)runType shakeType:(NSInteger)shakeType;
- (void)stopAni;
//- (void)prepareForSwitchAni;
@end