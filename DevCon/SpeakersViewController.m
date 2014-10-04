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
#import "UIImageView+AFNetworking.h"
@interface SpeakersViewController ()
{
    IBOutlet UICollectionView * empNameCollectionView;
    NSArray * arrEmpList;
    
    NavBarButton *btnBack;
    MainNavigationViewController * mainNav;
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
    btnBack = [[NavBarButton alloc] init];
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
    
    mainNav = (MainNavigationViewController *)self.navigationController;
    mainNav.owner = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheView) name:@"refreshScheduleView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self refreshTheView];
}

- (void)refreshTheView{
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    arrEmpList = [delegate.db getAllSpeakers];
    [empNameCollectionView reloadData];
}

- (void)animateDropDown:(NavBarButton *)btn{
    BOOL isOpen = [mainNav getPullMenuBOOl];
    NSLog(@"menu open %d",isOpen);
    if (isOpen) {
        //btn.imageView.transform = CGAffineTransformMakeRotation(M_PI_4);
        [UIView animateWithDuration:0.2 animations:^{
            btnBack.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    [mainNav animateDropDown];
}

-(void)pullDownAnimated:(BOOL)open{
    if (open) {
        [UIView animateWithDuration:0.2 animations:^{
            btnBack.transform = CGAffineTransformMakeRotation(3.14159265358979323846264338327950288);
        }];
    }
    else{
        
        [UIView animateWithDuration:0.2 animations:^{
            btnBack.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrEmpList count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5; // This is the minimum inter item spacing, can be more
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    ObjSpeaker * emp = [arrEmpList objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    [titleLabel setText:[NSString stringWithFormat:@"%@",emp.strSpeakerName]];
    
    UILabel *titlJobTitLabel = (UILabel *)[cell viewWithTag:77];
    [titlJobTitLabel setText:[NSString stringWithFormat:@"%@",emp.strJobTitle]];

    
    UIImageView * imgView = (UIImageView *)[cell viewWithTag:99];
    [Utility makeCornerRadius:imgView andRadius:imgView.frame.size.width/2];
    [imgView setImageWithURL:[NSURL URLWithString:emp.strProfilePic] placeholderImage:[UIImage imageNamed:@"img_profile_default"]];
    
    [Utility makeCornerRadius:cell andRadius:4];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
