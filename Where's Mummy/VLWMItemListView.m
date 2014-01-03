//
//  VLWMItemListView.m
//  Where's Mummy
//
//  Created by Vu Long on 30/09/2013.
//  Copyright (c) 2013 Vu Long. All rights reserved.
//

#import "VLWMItemListView.h"
#import "VLWMItemCell.h"
#import "VLWMItemData.h"
#import "VLWMGameData.h"
#import "VLWMGameInfo.h"
#import "VLWMEditItemView.h"
#define MI_MAX_PRICE_TIER ((int) 4)
@interface VLWMItemListView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    BOOL * blLock;
    BOOL * blNew;
    NSInteger miPriceTier;
}
@property (nonatomic, copy) NSMutableArray *masterItemDataList;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) NSString  * mstrCurPath;
@property(nonatomic) NSInteger  miDelItemIdx;
@end

@implementation VLWMItemListView
- (IBAction)unwindToItemList:(UIStoryboardSegue *)unwindSegue
{
}
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.gameData loadItemData:NO];
    self.masterItemDataList = self.gameData.itemList;
    _mstrCurPath = self.gameData.docPath;
    [self.collectionView reloadData];
    
    if (self.gameData) {
        self.nameField.text = self.gameData.gameInfo.GameName;
    }
    
    [self setLockStat:self.gameData.gameInfo.lock];
    [self setNewStat:self.gameData.gameInfo.isNew];
    [self setPriceTier:self.gameData.gameInfo.priceTier];
    UIMenuItem *itemA = [[UIMenuItem alloc] initWithTitle:@"CUSTOM" action:@selector(customAction:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:itemA]];
    
//    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Custom Action"
//                                                      action:@selector(customAction:)];
//    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
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
    return [self.masterItemDataList count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    //    return [self.masterItemDataList count];
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VLWMItemCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    VLWMItemData *item = [self.masterItemDataList objectAtIndex:indexPath.row];
    [cell setPhoto:item.dispImage];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VLWMItemData *item = [self.masterItemDataList objectAtIndex:indexPath.row];
    
    VLWMEditItemView *itemView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditItemView"];
    itemView.itemData = item;
    [self presentModalViewController:itemView animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
#pragma mark – UICollectionViewDelegateFlowLayout
// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(100, 100);
    return retval;
}
// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
#pragma mark - Prepare for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"EditItemSegueID"])
//    {
//    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
//    NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
//    VLWMItemData *item = [self.masterItemDataList objectAtIndex:indexPath.row];
//
//    VLWMEditItemView *itemView = (VLWMEditItemView *)segue.destinationViewController;
//    itemView.itemData = item;
//    }
//    else if([[segue identifier] isEqualToString:@"AddNewItemSegueID"])
//    {
//        VLWMItemData *newItem = [[VLWMItemData alloc] initWithTitle:@"New Item" question:@"Where is new item?" dispImage:nil fullImage:nil];
//        newItem.privatePath = self.gameData.docPath;
//        NSMutableArray *itemList = [self.gameData loadItemData:NO];
//        [itemList addObject:newItem];
//        self.masterItemDataList = itemList;
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_masterItemDataList.count-1 inSection:0];
//        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//        [self.collectionView insertItemsAtIndexPaths:indexPaths];
//        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
//        VLWMEditItemView *itemView = (VLWMEditItemView *)segue.destinationViewController;
//        itemView.itemData = newItem;
//    }
//    else if ([[segue identifier] isEqualToString:@"UnwindToGameSegueID"])
//        else
//    {
//        if(self.masterItemDataList!=nil && self.masterItemDataList.count>0)
//        {
//            VLWMItemData *itemdata = [self.masterItemDataList objectAtIndex:0];
//            self.gameData.itemList = self.masterItemDataList;
//            self.gameData.dispImage = itemdata.dispImage;
//            self.gameData.gameInfo.GameName = self.nameField.text;
////            self.gameData.gameInfo.isNew = YES;
//            [self.gameData saveGame];
//            [self.gameData saveGameData:blLock priceTier:miPriceTier isNew:blNew isComplete:blLock];
//        }
//
//    }
}
#pragma mark - UICollectionViewDelegate methods
- (BOOL)collectionView:(UICollectionView *)collectionView
      canPerformAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    if (action == @selector(customAction:)) {
        return YES;
    }
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView
      canPerformAction:(SEL)action
            withSender:(id)sender {
    if (action == @selector(customAction:)) {
        return YES;
    }
    return NO;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(customAction:))
        return YES;
    else if (action == @selector(delete:))
        return YES;
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"shouldShowMenuForItemAtIndexPath: %d", indexPath.item);
    _miDelItemIdx = indexPath.item;
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView
         performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    NSLog(@"performAction");
}

#pragma mark - UIMenuController required methods
- (BOOL)canBecomeFirstResponder {
    // NOTE: This menu item will not show if this is not YES!
    return YES;
}

#pragma mark - Custom Action(s)
- (void)customAction:(id)sender {
    VLWMItemData *item = [self.masterItemDataList objectAtIndex:_miDelItemIdx];
    NSString *strDelPath = item.docPath;
    NSLog(@"Deleting item at path %@", strDelPath);
    [self.gameData deleteDoc:strDelPath];
    [self.gameData loadItemData:NO];
    self.masterItemDataList = self.gameData.itemList;
    [self.collectionView reloadData];

//    VLWMItemData *item = [self.masterItemDataList objectAtIndex:indexPath.row];
}
// iOS 7.0 custom delegate method for the Cell to pass back a method for what custom button in the UIMenuController was pressed
- (void)customAction:(id)sender forCell:(UICollectionViewCell *)cell {
    VLWMItemData *item = [self.masterItemDataList objectAtIndex:_miDelItemIdx];
    NSString *strDelPath = item.docPath;
    NSLog(@"Deleting item at path %@", strDelPath);
    [self.gameData deleteDoc:strDelPath];
    [self.gameData loadItemData:NO];
    self.masterItemDataList = self.gameData.itemList;
    [self.collectionView reloadData];
}

- (IBAction)nameFieldChanged:(id)sender {
    self.gameData.gameInfo.GameName = self.nameField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tapLock:(id)sender {
    NSLog(@"Before: %d",blLock);
    NSString * path = [[NSBundle mainBundle]pathForResource:@"b1" ofType:@"png"];
    UIImage * lock = [UIImage imageWithContentsOfFile:path];
    NSString * pathUnlock = [[NSBundle mainBundle]pathForResource:@"b2" ofType:@"png"];
    UIImage * unlock = [UIImage imageWithContentsOfFile:pathUnlock];
    if(blLock)
    {
        [self.btLockStat setImage:unlock forState:UIControlStateNormal];
        blLock = NO;
    }
    else
    {
        [self.btLockStat setImage:lock forState:UIControlStateNormal];
        blLock = YES;
    }
    NSLog(@"After: %d",blLock);
}
- (IBAction)tapNew:(id)sender {
    NSString * path = [[NSBundle mainBundle]pathForResource:@"b1" ofType:@"png"];
    UIImage * new = [UIImage imageWithContentsOfFile:path];
    NSString * pathUnlock = [[NSBundle mainBundle]pathForResource:@"b2" ofType:@"png"];
    UIImage * old = [UIImage imageWithContentsOfFile:pathUnlock];
    if(blNew)
    {
        [self.btNewStat setImage:old forState:UIControlStateNormal];
        blNew = NO;
    }
    else
    {
        [self.btNewStat setImage:new forState:UIControlStateNormal];
        blNew = YES;
    }
}
- (IBAction)tapPriceTier:(id)sender {
    if(miPriceTier<4)
        miPriceTier ++;
    else
        miPriceTier = 0;
    NSString *newImgFile = [NSString stringWithFormat:@"a%d", miPriceTier];
    NSString * path = [[NSBundle mainBundle]pathForResource:newImgFile ofType:@"png"];
    UIImage * new = [UIImage imageWithContentsOfFile:path];
    [self.btPriceTier setImage:new forState:UIControlStateNormal];
}
- (void)setLockStat:(BOOL)stat
{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"b1" ofType:@"png"];
    UIImage * lock = [UIImage imageWithContentsOfFile:path];
    NSString * pathUnlock = [[NSBundle mainBundle]pathForResource:@"b2" ofType:@"png"];
    UIImage * unlock = [UIImage imageWithContentsOfFile:pathUnlock];
    if(stat)
    {
        [self.btLockStat setImage:lock forState:UIControlStateNormal];
        blLock = YES;
    }
    else
    {
        [self.btLockStat setImage:unlock forState:UIControlStateNormal];
        blLock = NO;
    }
}
- (void)setNewStat:(BOOL)stat
{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"b1" ofType:@"png"];
    UIImage * new = [UIImage imageWithContentsOfFile:path];
    NSString * pathUnlock = [[NSBundle mainBundle]pathForResource:@"b2" ofType:@"png"];
    UIImage * old = [UIImage imageWithContentsOfFile:pathUnlock];
    if(stat)
    {
        [self.btNewStat setImage:new forState:UIControlStateNormal];
        blNew = YES;
    }
    else
    {
        [self.btNewStat setImage:old forState:UIControlStateNormal];
        blNew = NO;
    }
}
- (void)setPriceTier:(NSInteger)priceTier
{
    NSString *newImgFile = [NSString stringWithFormat:@"a%d", priceTier];
    NSString * path = [[NSBundle mainBundle]pathForResource:newImgFile ofType:@"png"];
    UIImage * new = [UIImage imageWithContentsOfFile:path];
    [self.btPriceTier setImage:new forState:UIControlStateNormal];
    miPriceTier = priceTier;
}
-(IBAction)addNewItem:(id)sender
{
    VLWMItemData *newItem = [[VLWMItemData alloc] initWithTitle:@"New Item" question:@"Where is new item?" dispImage:nil fullImage:nil];
    newItem.privatePath = self.gameData.docPath;
    NSMutableArray *itemList = [self.gameData loadItemData:NO];
    [itemList addObject:newItem];
    self.masterItemDataList = itemList;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_masterItemDataList.count-1 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];

    VLWMEditItemView *itemView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditItemView"];
    itemView.itemData = newItem;
    [self presentModalViewController:itemView animated:YES];

}
-(IBAction)returnToList:(id)sender
{
    if(self.masterItemDataList!=nil && self.masterItemDataList.count>0)
    {
        VLWMItemData *itemdata = [self.masterItemDataList objectAtIndex:0];
        self.gameData.itemList = self.masterItemDataList;
        self.gameData.dispImage = itemdata.dispImage;
        self.gameData.gameInfo.GameName = self.nameField.text;
        //            self.gameData.gameInfo.isNew = YES;
        [self.gameData saveGame];
        [self.gameData saveGameData:blLock priceTier:miPriceTier isNew:blNew isComplete:blLock];
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotate {
    return NO;
}

@end
