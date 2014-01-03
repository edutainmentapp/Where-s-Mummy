//
//  VLWMGameListView.m
//  Where's Mummy
//
//  Created by Vu Long on 30/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMGameListView.h"
#import "VLWMItemListView.h"
#import "VLWMEditItemView.h"
#import "VLWMItemCell.h"
#import "VLWMGameData.h"
#import "VLWMGameInfo.h"
#import "VLWMPackageData.h"
@interface VLWMGameListView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (copy) NSMutableArray *masterGameDataList;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end

@implementation VLWMGameListView
- (IBAction)unwindToGameList:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[VLWMItemListView class]])
    {
        NSLog(@"Coming from GREEN!");
    }
    else if ([sourceViewController isKindOfClass:[VLWMEditItemView class]])
    {
        NSLog(@"Coming from BLUE!");
    }
}
- (IBAction)returnToMain{
//    [[self navigationController] popToRootViewControllerAnimated:NO];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.masterGameDataList!=nil&&self.masterGameDataList.count>0)
    {    [self.collectionView reloadData];}
    else
    {
    NSMutableArray *itemList = [VLWMPackageData loadGameData];
    self.masterGameDataList = itemList;
    [self.collectionView reloadData];
    }
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
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
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    //    return [self.masterItemDataList count];
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VLWMItemCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GameCell" forIndexPath:indexPath];
    VLWMGameData *item = [self.masterGameDataList objectAtIndex:indexPath.row];
    [cell setPhoto:item.dispImage];
    [cell setLabel:item.gameInfo.GameName];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VLWMGameData *gameData = [self.masterGameDataList objectAtIndex:indexPath.row];

    VLWMItemListView * gameView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditGameView"];
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
    CGSize retval = CGSizeMake(100, 130);
    return retval;
}
// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 20, 20);
}
#pragma mark - Prepare for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ViewGameDetailSegueID"])
    {
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
    VLWMGameData *gameData = [self.masterGameDataList objectAtIndex:indexPath.row];
    VLWMItemListView *itemListView = (VLWMItemListView *)segue.destinationViewController;
    itemListView.gameData = gameData;
    }
}
-(IBAction)openCreateNewGameView
{
    VLWMItemListView * gameView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditGameView"];
    [self presentModalViewController:gameView animated:YES];
}
- (BOOL)shouldAutorotate {
    return NO;
}

@end
