//
//  SpeakersViewController.m
//  DevCon
//
//  Created by Zayar on 10/10/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import "SpeakersViewController.h"
#import "UIColor+Expanded.h"
#import "NavBarButton.h"
#import "MainNavigationViewController.h"
#import "ObjSpeaker.h"
#import "AppDelegate.h"
#import "Utility.h"
@interface SpeakersViewController ()
{
    IBOutlet UICollectionView * empNameCollectionView;
    NSArray * arrEmpList;
}
@end
static NSString * const kCellReuseIdentifier = @"collectionViewCell";
@implementation SpeakersViewController

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
	// Do any additional setup after loading the view.
    UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textColor = [UIColor whiteColor];
    NSString * strValueFontName=@"AvenirNext-Regular";
    lblName.font = [UIFont fontWithName:strValueFontName size:19];
    lblName.text= @"SPEAKERS";
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.textColor = [UIColor colorWithHexString:@"005b71"];
    self.navigationItem.titleView = lblName;
    NavBarButton *btnBack = [[NavBarButton alloc] init];
    [btnBack addTarget:self action:@selector(animateDropDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = backButton;
    
    [empNameCollectionView registerNib:[UINib nibWithNibName:@"NameLoginCollectionItem" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    empNameCollectionView.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(134.5, 167.5)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [empNameCollectionView setCollectionViewLayout:flowLayout];
    [empNameCollectionView setAllowsSelection:YES];
    empNameCollectionView.delegate=self;
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 20, 10, 20)];
    
    [empNameCollectionView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //tbl.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
}

- (void)viewWillAppear:(BOOL)animated{
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    arrEmpList = [delegate.db getAllSpeakers];
}

- (void)animateDropDown:(NavBarButton *)btn{
    MainNavigationViewController * mainNav = (MainNavigationViewController *)self.navigationController;
    [mainNav animateDropDown];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrEmpList count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5; // This is the minimum inter item spacing, can be more
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //static NSString *CellIdentifier = @"NameLoginCollectionItem";
	/*NameLoginCollectionItem *cell = (NameLoginCollectionItem *) [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
     
     if (cell == nil) {
     NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NameLoginCollectionItem" owner:nil options:nil];
     for(id currentObject in topLevelObjects){
     if([currentObject isKindOfClass:[UITableViewCell class]]){
     cell = (NameLoginCollectionItem *) currentObject;
     
     break;
     }
     }
     }
     
     //UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
     //recipeImageView.image = [UIImage imageNamed:[arrEmpList objectAtIndex:indexPath.row]];
     //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arsenal_logo.png"]];
     [cell setName:[arrEmpList objectAtIndex:indexPath.row]];*/
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    ObjSpeaker * emp = [arrEmpList objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    [titleLabel setText:[NSString stringWithFormat:@"%@",emp.strSpeakerName]];
    
    UILabel *titlJobTitLabel = (UILabel *)[cell viewWithTag:88];
    [titlJobTitLabel setText:[NSString stringWithFormat:@"%@",emp.strJobTitle]];
    
    UILabel *titlCompanyLabel = (UILabel *)[cell viewWithTag:77];
    [titlCompanyLabel setText:[NSString stringWithFormat:@"%@",emp.strCompany]];
    
    UIImageView * imgView = (UIImageView *)[cell viewWithTag:99];
    [Utility makeCornerRadius:imgView andRadius:imgView.frame.size.width/2];
    [imgView setImage:[UIImage imageNamed:@"temp_profile"]];
    
    //[Utility makeBorder:cell andWidth:0.5 andColor:[UIColor grayColor]];
    [Utility makeCornerRadius:cell andRadius:4];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
