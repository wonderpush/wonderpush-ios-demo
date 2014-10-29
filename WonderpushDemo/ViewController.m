//
//  ViewController.m
//  WonderpushDemo
//
//  Created by YAKAZ on 01/10/14.
//  Copyright (c) 2014 WonderPush. All rights reserved.
//

#import "ViewController.h"
#import "WonderPush_public.h"

@interface ViewController ()

@end

@implementation ViewController

static NSArray* cellConfiguration;

- (void)viewDidLoad {
    [super viewDidLoad];
    cellConfiguration = @[@{@"title":@"FIRST VISIT",      @"event":@"firstVisit",
                            @"bgColor": [UIColor colorWithRed:0/255.   green:144/255. blue:255/255. alpha:1.0]},
                          @{@"title":@"NEWS READ",        @"event":@"newsRead",
                            @"bgColor": [UIColor colorWithRed:16/255.  green:172/255. blue:255/255. alpha:1.0]},
                          @{@"title":@"GAME OVER",        @"event":@"gameOver",
                            @"bgColor": [UIColor colorWithRed:99/255.  green:192/255. blue:242/255. alpha:1.0]},
                          @{@"title":@"LIKE",             @"event":@"like",
                            @"bgColor": [UIColor colorWithRed:172/255. green:217/255. blue:228/255. alpha:1.0]},
                          @{@"title":@"ADD TO CART",      @"event":@"addToCart",
                            @"bgColor": [UIColor colorWithRed:149/255. green:149/255. blue:149/255. alpha:1.0]},
                          @{@"title":@"PURCHASE",         @"event":@"purchase",
                            @"bgColor": [UIColor colorWithRed: 51/255. green: 51/255. blue: 51/255. alpha:1.0]},
                          @{@"title":@"GEOFENCING",       @"event":@"geofencing",
                            @"bgColor": [UIColor colorWithRed:  0/255. green:153/255. blue:102/255. alpha:1.0]},
                          @{@"title":@"INACTIVE USER",    @"event":@"inactivity",
                            @"bgColor": [UIColor colorWithRed:222/255. green:113/255. blue:113/255. alpha:1.0]}];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TABLE VIEW DATASOURCE METHODS 

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *myLabel;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"cell"];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 65.f);
        myLabel = [[UILabel alloc] initWithFrame:cell.frame];
        myLabel.tag = 111;
        myLabel.textAlignment= NSTextAlignmentCenter;
        myLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        myLabel.font = [UIFont boldSystemFontOfSize:30.];
        [cell.contentView addSubview:myLabel];
    }
    
    myLabel = (UILabel*)[cell.contentView viewWithTag:111];
    myLabel.text = [[cellConfiguration objectAtIndex:[indexPath row]] valueForKey:@"title"];
    myLabel.backgroundColor = [[cellConfiguration objectAtIndex:[indexPath row]] valueForKey:@"bgColor"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellConf = [cellConfiguration objectAtIndex:[indexPath row]];
    id type = [cellConf valueForKey:@"event"];
    id data = [cellConf valueForKey:@"data"];
    [WonderPush trackEvent:type withData:data];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [cellConfiguration count];
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return @[@"test"];
//}

//- (NSInteger)tableView:(UITableView *)tableView
//sectionForSectionIndexTitle:(NSString *)title
//               atIndex:(NSInteger)index
//{
//    
//}
//
//
//- (NSString *)tableView:(UITableView *)tableView
//titleForHeaderInSection:(NSInteger)section
//{
//    
//}
//
//- (NSString *)tableView:(UITableView *)tableView
//titleForFooterInSection:(NSInteger)section
//{
//    
//}

@end

