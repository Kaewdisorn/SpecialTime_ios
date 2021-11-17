//
//  TableViewController.m
//  ST
//
//  Created by Wongsaphat Praisri on 8/13/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import "TableViewController.h"
#import "usedCell.h"

@interface TableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    PFUser *cur = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"used"];
    [query whereKey:@"user" equalTo:cur.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error) {
        
        if(!error)
        {
            
            used = [[NSMutableArray alloc] initWithArray:objects];
            used = objects;
           // NSLog(@"TEST TEST : %@",[objects objectAtIndex:0]);
            
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"Errorrrr = %@",error);
            
        }
    }];
    
}
-(void) viewWillAppear:(BOOL)animated{
    
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return used.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    usedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

 
    
    //cell.textLabel.text = @"ชื่อร้านนนนนนนน";
    //cell.detailTextLabel.text = @"โปรโมชั่นนนนน";
    PFObject *item = [used objectAtIndex:indexPath.row];
    
  //  NSLog(@"test arr : %lu",(unsigned long)aaa.count);
   // NSLog(@"test arr : %lu",(unsigned long)used.count);

    [self viewDidLoad];

    cell.name.text = [item objectForKey:@"name"];
    cell.promotion.text = [item objectForKey:@"promotion"];
    cell.date.text = [item objectForKey:@"timeused"];


    
    return cell;
}


@end
