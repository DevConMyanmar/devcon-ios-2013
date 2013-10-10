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
    
    NavBarButton *btnBack = [[NavBarButton alloc] init];
    [btnBack addTarget:self action:@selector(animateDropDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = backButton;
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //tbl.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
}

- (void)animateDropDown:(NavBarButton *)btn{
    MainNavigationViewController * mainNav = (MainNavigationViewController *)self.navigationController;
    [mainNav animateDropDown];
}

- (void)viewWillAppear:(BOOL)animated{
    AppDelegate * delegate= [[UIApplication sharedApplication]delegate];
    
    arrSchedules = [delegate.db getAllSchedules];
    NSLog(@"schedules count %d",[arrSchedules count]);
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
        
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:221/255.f green:126/255.f blue:55/255.f alpha:1] icon:[UIImage imageNamed:@"Star_Unselect"] andTag:indexPath.row];
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
        [button setImage:[UIImage imageNamed:@"Star_Unselect"] forState:UIControlStateNormal];
    }
    else if (obj.isFav == 1){
        [button setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
    }
    cell.tag = indexPath.row;
    
    [cell loadTheViewWith:obj];
    //[cell reloadTheScrollViewHeight:([ScheduleCell heightForCellWithPost:[arrSchedules objectAtIndex:indexPath.row]]+ 81)];
    return cell;
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
                [button setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
                obj.isFav = 1;
                [delegate.db updateScheduleFav:obj.idx andFav:obj.isFav];
                [arrSchedules replaceObjectAtIndex:cell.tag withObject:obj];
            }
            else if (obj.isFav == 1){
                [button setImage:[UIImage imageNamed:@"Star_Unselect"] forState:UIControlStateNormal];
                obj.isFav = 0;
                [delegate.db updateScheduleFav:obj.idx andFav:obj.isFav];
                [arrSchedules replaceObjectAtIndex:cell.tag withObject:obj];
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
    ObjSchedule * obj = [arrSchedules objectAtIndex:cell.tag];
    ScheduleDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScheduleDetail"];
    viewController.objSchedule = obj;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
