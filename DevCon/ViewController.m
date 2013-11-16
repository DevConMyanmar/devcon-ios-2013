//
//  ViewController.m
//  DevCon
//
//  Created by Zayar on 10/7/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Expanded.h"
#import "AppDelegate.h"
#import "ScheduleCell.h"
#import "ObjSchedule.h"
#import "NavBarButton.h"
#import "MainNavigationViewController.h"
#import "SWTableViewCell.h"
#import "ScheduleDetailViewController.h"
@interface ViewController ()
{
    IBOutlet UITableView * tbl;
    NSMutableArray * arrSchedules;
    SWTableViewCell * selectedCell;
    NavBarButton *btnBack;
    MainNavigationViewController * mainNav;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textColor = [UIColor whiteColor];
    NSString * strValueFontName=@"AvenirNext-Regular";
    lblName.font = [UIFont fontWithName:strValueFontName size:19];
    lblName.text= @"DEV CON";
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.textColor = [UIColor colorWithHexString:@"005b71"];
    self.navigationItem.titleView = lblName;
    
    if ([tbl respondsToSelector:@selector(separatorInset)]) {
        [tbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    btnBack = [[NavBarButton alloc] init];
    [btnBack addTarget:self action:@selector(animateDropDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = backButton;
    mainNav = (MainNavigationViewController *)self.navigationController;
    mainNav.owner = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheView) name:@"refreshScheduleView" object:nil];
}

- (void)animateDropDown:(NavBarButton *)btn{
   
    BOOL isOpen = [mainNav getPullMenuBOOl];
    NSLog(@"menu open %d",isOpen);
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    if (isOpen) {
    
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

- (void)viewWillAppear:(BOOL)animated{
    [self refreshTheView];
}

- (void) refreshTheView{
    AppDelegate * delegate= [[UIApplication sharedApplication]delegate];
    
    arrSchedules = [delegate.db getAllSchedules];
    NSLog(@"schedules count %d",[arrSchedules count]);
    
    if (selectedCell) {
        ObjSchedule * obj = [arrSchedules objectAtIndex:selectedCell.tag];
        UIButton *button = [selectedCell.rightUtilityButtons objectAtIndex:0];
        if (obj.isFav == 0) {
            [button setImage:[UIImage imageNamed:@"Star_Unselect2.png"] forState:UIControlStateNormal];
        }
        else{
            [button setImage:[UIImage imageNamed:@"Star2"] forState:UIControlStateNormal];
        }
    }
    [self reloadData:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            ObjSchedule * obj = [arrSchedules objectAtIndex:cell.tag];
            UIButton *button = [cell.rightUtilityButtons objectAtIndex:index];
            NSLog(@"obj fav %d",obj.isFav);
            //button.backgroundColor = color;
            AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
            if (obj.isFav == 0) {
                [button setImage:[UIImage imageNamed:@"Star2"] forState:UIControlStateNormal];
                obj.isFav = 1;
                [delegate.db updateScheduleFav:obj.idx andFav:obj.isFav];
                [arrSchedules replaceObjectAtIndex:cell.tag withObject:obj];
                [cell wayToOriginalScrollView];
            }
            else if (obj.isFav == 1){
                [button setImage:[UIImage imageNamed:@"Star_Unselect2"] forState:UIControlStateNormal];
                obj.isFav = 0;
                [delegate.db updateScheduleFav:obj.idx andFav:obj.isFav];
                [arrSchedules replaceObjectAtIndex:cell.tag withObject:obj];
                [cell wayToOriginalScrollView];
            }
            break;
        }
            
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [tbl indexPathForCell:cell];
            
           // [_testArray removeObjectAtIndex:cellIndexPath.row];
            //[self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}


#pragma Tableview Delegate and Datasource
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
    static NSString *cellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //if (cell == nil) {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:221/255.f green:126/255.f blue:55/255.f alpha:1] icon:[UIImage imageNamed:@"Star_Unselect2"] andTag:indexPath.row];
    
    cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier height:([ScheduleCell heightForCellWithPost:[arrSchedules objectAtIndex:indexPath.row]]+ 81) leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    cell.delegate = self;
    // }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    return cell;
}

- (void)didSelectedTheCell:(SWTableViewCell *)cell{
    selectedCell = cell;
    ObjSchedule * obj = [arrSchedules objectAtIndex:cell.tag];
    ScheduleDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScheduleDetail"];
    viewController.objSchedule = obj;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)reloadData:(BOOL)animated
{
    [tbl reloadData];
    if (animated) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionMoveIn];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.9];
        [[tbl layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
    }
}

@end
