//
//  LetterCollectionViewController.m
//  FanstasticViewer
//
//  Created by Kevin Almanza on 1/26/14.
//  Copyright (c) 2014 Kevin Almanza. All rights reserved.
//

#import "LetterCollectionViewController.h"
#import "LetterCell.h"
#import "LetterGroupViewController.h"
#import "DataManager.h"

@interface LetterCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LetterCollectionViewController

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
    [_collectionView registerClass:[LetterCell class] forCellWithReuseIdentifier:@"reuse"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:10.0];
    [flowLayout setMinimumLineSpacing:30.0];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [_collectionView setCollectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor darkGrayColor]];
    [_collectionView setContentInset:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self setTitle:@"Browse"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 26;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LetterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    char letter = 'A' + indexPath.row;
    [cell.textLabel setText:[NSString stringWithFormat:@"%c",letter]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:22]];
    [cell.layer setCornerRadius:5.0];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LetterCell *cell = (LetterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    LetterGroupViewController *lgvc = [[LetterGroupViewController alloc] init];
    DataManager *manager = [DataManager sharedManager];
    NSArray *heroKeys = [manager heroNamesWithPrefix:cell.textLabel.text];
    [lgvc setDataSource:heroKeys];
    [lgvc setTitle:cell.textLabel.text];
    
    [self.navigationController pushViewController:lgvc animated:YES];
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
}
 
 */

@end
