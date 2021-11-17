//
//  Home.m
//  ST
//
//  Created by Wongsaphat Praisri on 8/7/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import "Home.h"
#import "CustomCell.h"
#import "HomeDetail.h"
#import <CoreLocation/CoreLocation.h>


@interface Home ()<CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
    NSArray *shopnear;
}
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.tableView reloadData];

    self.navigationItem.title = @"Home";
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self->locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
 

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
   // NSLog(@"Lati %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
           // NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            
            [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
            [[PFUser currentUser] saveInBackground];
            
            PFUser *user = [PFUser currentUser];
            PFGeoPoint *userGeoPoint = user[@"currentLocation"];
            
            PFQuery *query = [PFQuery queryWithClassName:@"shop"];
            [query whereKey:@"Shoplocation" nearGeoPoint:userGeoPoint withinKilometers:40];
            
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error) {
                
                if(!error)
                {
                    
                    data = [[NSMutableArray alloc] initWithArray:objects];
                    data = objects;
                    [self.tableView reloadData];
                    
                }
                else
                {
                    NSLog(@"Errorrrr = %@",error);
                    
                }
            }];
            [self.tableView reloadData];
        
        }
    }];
    
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
    return data.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    PFObject *item = [data objectAtIndex:indexPath.row];
    
    
    PFUser *user = [PFUser currentUser];
    PFGeoPoint *userGeoPoint = user[@"currentLocation"];
    double distanceDouble  = [userGeoPoint distanceInKilometersTo:[item objectForKey:@"Shoplocation"]];
   // NSLog(@"Distance: %.2f",distanceDouble);

    
    
    NSLog(@"%@",[item objectForKey:@"Name"]);
    cell.shopName.text = [item objectForKey:@"Name"];
    cell.promo.text = [item objectForKey:@"promotion"];

    PFFile *userImageFile = item[@"pic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imgview.image = image;
        }
    }];
    
    cell.kmmm.text = [NSString stringWithFormat:@"%.2f",distanceDouble];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    if ([segue.identifier isEqualToString:@"detail"]){
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    PFObject *object = [data objectAtIndex:indexPath.row];
    HomeDetail *detailViewController = segue.destinationViewController;
    detailViewController.exam =object;
    }
}

@end
