//
//  CVViewController.m
//  CollectionView4
//
//  Created by John Chen on 5/7/14.
//  Copyright (c) 2014 JohnChen. All rights reserved.
//

#import "CVViewController.h"
#import "CVCollectionViewCell.h"
#import "CVCollectionFooter.h"
#import "CVCollectionHeader.h"

static NSString* kCollectionViewCellId = @"CollectionCell";
static NSString* kCollectionHeaderId = @"CollectionHeader";
static NSString* kCollectionFooterId = @"CollectionFooter";
const NSTimeInterval kAnimationDuration = 0.2;

@interface CVViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak,nonatomic) IBOutlet UICollectionView* collectionView;
@property NSArray* images;
@end

@implementation CVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.images = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"]];
	
    UICollectionViewFlowLayout* flowlayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowlayout.sectionInset = UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0);
    flowlayout.headerReferenceSize = CGSizeMake(300.0, 50.0);
    flowlayout.footerReferenceSize = CGSizeMake(300.0, 50.0);
    
    UINib* nib = [UINib nibWithNibName:NSStringFromClass([CVCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kCollectionViewCellId];
    
    UINib* nibheader = [UINib nibWithNibName:NSStringFromClass([CVCollectionHeader class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibheader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionHeaderId];
    
    UINib* nibfooter =[UINib nibWithNibName:NSStringFromClass([CVCollectionFooter class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibfooter forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionFooterId];
    
    
    //增加pinch手势
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    for (UIGestureRecognizer* getsture in self.collectionView.gestureRecognizers) {
        if ([getsture isKindOfClass:[UIPinchGestureRecognizer class]]) {
            [getsture requireGestureRecognizerToFail:pinch];
        }
    }
    [self.collectionView addGestureRecognizer:pinch];
}

-(void)pinchGestureRecognizer:(UIPinchGestureRecognizer*)pinch
{
    UICollectionViewFlowLayout* flowlayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    flowlayout.itemSize = CGSizeMake(80.0*pinch.scale, 80.0*pinch.scale);
    
    [flowlayout invalidateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CVCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId forIndexPath:indexPath];
    cell.imageview.image = self.images[arc4random_uniform(self.images.count)];
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CVCollectionHeader* header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionHeaderId forIndexPath:indexPath];
        header.label.text = [NSString stringWithFormat:@"Header - %d",indexPath.section+1];
        return header;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        CVCollectionFooter* footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionFooterId forIndexPath:indexPath];
        [footer.button setTitle:[NSString stringWithFormat:@"Footer - %d",indexPath.section+1] forState:UIControlStateNormal];
        return footer;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    
    [UIView animateWithDuration:kAnimationDuration animations:^(void){
        cell.alpha=0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:kAnimationDuration animations:^(){
            cell.alpha = 1.0;
        }];
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        cell.transform = CGAffineTransformMakeScale(2.0, 2.0);
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

//cell上的长按显示的菜单
-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
//    return YES; 全面打开的话，有3个action：cut、copy、paste
    if (action == @selector(copy:)) {
        return YES;
    }
    
    return NO;
}
-(void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action==@selector(copy:)) {
        CVCollectionViewCell* cell = (CVCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [[UIPasteboard generalPasteboard] setImage:cell.imageview.image];
    }
}

@end
