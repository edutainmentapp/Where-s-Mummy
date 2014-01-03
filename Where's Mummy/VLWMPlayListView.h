//
//  VLWMPlayListView.h
//  Where's Mummy
//
//  Created by Vu Long on 01/10/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLWMPlayListView : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak) IBOutlet UIImageView *leftDoor;
@property (nonatomic,weak) IBOutlet UIImageView *rightDoor;
@property (nonatomic, assign, setter=willPlayAni:) BOOL playAni;
@property (nonatomic, assign) NSString * mstrAniRes;
@end
