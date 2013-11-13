//
//  FavouritesViewController.m
//  DevCon
//
//  Created by Zayar on 10/10/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import "FavouritesViewController.h"
#import "UIColor+Expanded.h"
#import "NavBarButton.h"
#import "MainNavigationViewController.h"
#import "UIColor+Expanded.h"
#import "AppDelegate.h"
#import "ScheduleCell.h"
#import "ObjSchedule.h"
#import "SWTableViewCell.h"
#import "ScheduleDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface FavouritesViewController ()
{
    IBOutlet UITableView * tbl;
    NSMutableArray * arrSchedules;
    SWTableViewCell * selectedCell;
    
    NavBarButton *btnBack;
    MainNavigationViewController * mainNav;
    UIBarButtonItem * backButton;
    
    IBOutlet UIButton * btnDrop;
}
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBeahvior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@end

@implementation FavouritesViewController

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
    lblName.text= @"FAVOURITES";
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.textColor = [UIColor colorWithHexString:@"005b71"];
    self.navigationItem.titleView = lblName;
    
    mainNav = (MainNavigationViewController *)self.navigationController;
    mainNav.owner = self;
    
   btnBack = [[NavBarButton alloc] init];
    [btnBack addTarget:self action:@selector(animateDropDown:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //tbl.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
    
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapped:)];
    [self.view addGestureRecognizer:gesture];
    
    // Set up
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:nil];
    
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:nil];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:nil];
    self.itemBehavior.elasticity = 0.6;
    self.itemBehavior.friction = 0.5;
    self.itemBehavior.resistance = 0.5;
    
    
    [self.animator addBehavior:self.gravityBeahvior];
    [self.animator addBehavior:self.collisionBehavior];
    [self.animator addBehavior:self.itemBehavior];
    
    CGFloat rotationAngleDegrees = -20;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformation = transform;
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
        //btn.imageView.transform = CGAffineTransformMakeRotation(M_PI_4);
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

- (void)viewWillAppear:(BOOL)animated{
    AppDelegate * delegate= [[UIApplication sharedApplication]delegate];
    
    arrSchedules = [delegate.db getAllSchedulesByFav];
    NSLog(@"schedules count %d",[arrSchedules count]);
    
    if (selectedCell) {
        ObjSchedule * obj = [arrSchedules objectAtIndex:selectedCell.tag];
        UIButton *button = [selectedCell.rightUtilityButtons objectAtIndex:0];
        if (obj.isFav == 0) {
            [button setImage:[UIImage imageNamed:@"Star_Unselect"] forState:UIControlStateNormal];
        }
        else{
            [button setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
        }
    }
    [tbl reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSchedules count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *CellIdentifier = @"ScheduleCell";
     ScheduleCell *cell = (ScheduleCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if (cell == nil) {
     cell = [[ScheduleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     ObjSchedule * obj = [arrSchedules objectAtIndex:[indexPath row]];
     [cell loadTheViewWith:obj];
     return cell;*/
    static NSString *cellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //if (cell == nil) {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    //[leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0] icon:[UIImage imageNamed:@"check.png"]];
    //[leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0] icon:[UIImage imageNamed:@"clock.png"]];
    //[leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] icon:[UIImage imageNamed:@"cross.png"]];
    //[leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0] icon:[UIImage imageNamed:@"list.png"]];
    
    [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:221/255.f green:126/255.f blue:55/255.f alpha:1] icon:[UIImage imageNamed:@"Star_Unselect2"] andTag:indexPath.row];
    //[rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
    
    cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier height:([ScheduleCell heightForCellWithPost:[arrSchedules objectAtIndex:indexPath.row]]+ 81) leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    cell.delegate = self;
    // }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*NSDate *dateObject = arrSchedules[indexPath.row];
     cell.textLabel.text = [dateObject description];
     cell.detailTextLabel.text = @"Some detail text";*/
    ObjSchedule * obj = [arrSchedules objectAtIndex:[indexPath row]];
    UIButton *button = [cell.rightUtilityButtons objectAtIndex:0];
    //button.backgroundColor = color;
    
    if (obj.isFav == 0) {
        [button setImage:[UIImage imageNamed:@"Star_Unselect2"] forState:UIControlStateNormal];
    }
    else if (obj.isFav == 1){
        [button setImage:[UIImage imageNamed:@"Star2"] forState:UIControlStateNormal];
    }
    cell.tag = indexPath.row;
    
    [cell loadTheViewWith:obj];
    //[cell reloadTheScrollViewHeight:([ScheduleCell heightForCellWithPost:[arrSchedules objectAtIndex:indexPath.row]]+ 81)];
    return cell;
}

- (IBAction)onAnimate:(id)sender{
    //[self.gravityBeahvior addItem:mainNav];
    //[self.collisionBehavior addItem:mainNav];
    //[self.itemBehavior addItem:mainNav];
    
    //[self.gravityBeahvior addItem:btnBack];
    //[self.collisionBehavior addItem:btnBack];
    //[self.itemBehavior addItem:btnBack];
    
    //[self.gravityBeahvior addItem:btnDrop];
    //[self.collisionBehavior addItem:btnDrop];
    //[self.itemBehavior addItem:btnDrop];
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            NSIndexPath *cellIndexPath = [tbl indexPathForCell:cell];
            ObjSchedule * obj = [arrSchedules objectAtIndex:cellIndexPath.row];
            AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
            if (obj.isFav == 1){
                obj.isFav = 0;
                [delegate.db updateScheduleFav:obj.idx andFav:obj.isFav];
                NSLog(@"cell tag %d",cellIndexPath.row);
                [arrSchedules removeObjectAtIndex:cellIndexPath.row];
                [tbl deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                 break;
            }
        }
        case 1:
        {
            // Delete button was pressed
            //NSIndexPath *cellIndexPath = [tbl indexPathForCell:cell];
            
            // [_testArray removeObjectAtIndex:cellIndexPath.row];
            //[self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"height for cell: %f",[ScheduleCell heightForCellWithPost:[arrSchedules objectAtIndex:indexPath.row]]);
    return ([ScheduleCell heightForCellWithPost:[arrSchedules objectAtIndex:indexPath.row]]+ 81);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"on selected!!!");
    ObjSchedule * obj = [arrSchedules objectAtIndex:indexPath.row];
    ScheduleDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScheduleDetail"];
    viewController.objSchedule = obj;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didSelectedTheCell:(SWTableViewCell *)cell{
    selectedCell = cell;
    ObjSchedule * obj = [arrSchedules objectAtIndex:cell.tag];
    ScheduleDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScheduleDetail"];
    viewController.objSchedule = obj;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *card = [(SWTableViewCell* )cell mainView];
    
    card.layer.transform = self.initialTransformation;
    card.layer.opacity = 0.8;
    
    [UIView animateWithDuration:0.4 animations:^{
        card.layer.transform = CATransform3DIdentity;
        card.layer.opacity = 1;
    }];
}

@end
