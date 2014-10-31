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
static CGFloat cellHeight;

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

    cellHeight = (self.tableView.frame.size.height
                  - self.navigationController.navigationBar.frame.size.height
                  - [UIApplication sharedApplication].statusBarFrame.size.height
                  ) / [cellConfiguration count];
    if (cellHeight < 44)
        cellHeight = 44;

    [[NSNotificationCenter defaultCenter] addObserverForName:WP_NOTIFICATION_INITIALIZED object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self setTitle:@"SIMULATE AN EVENT BELOW"];
    }];
}


#pragma TABLE VIEW DATASOURCE METHODS 

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *myLabel;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"cell"];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cellHeight);
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
    return cellHeight;
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [cellConfiguration count];
}

@end

