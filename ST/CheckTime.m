//
//  CheckTime.m
//  ST
//
//  Created by Wongsaphat Praisri on 8/9/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import "CheckTime.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>


@interface CheckTime ()<CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
    NSArray *data;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *location;
    int randomindex;
    CLLocation *loc;
    
    NSString *keepName;
    NSString *keepPromo;
    NSString *keepdate;
    
}

@end

@implementation CheckTime

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Special Time";
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"hh:mm:ss aa "];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Thailand"]];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Thailand"];
            
            [dateFormat setLocale:locale];
            
            NSDate *now1 = [NSDate date];
            NSString  *now2 = [dateFormat stringFromDate:now1];
            NSDate *now = [dateFormat dateFromString:now2];
            NSLog(@"TIME NOW : %@",now);
           // NSLog(@"THAI TIME : %@",[dateFormat stringFromDate:now1]);

            
            NSDate *timetest = [dateFormat dateFromString:@"00:00:00 AM"];
            NSLog(@"TIME TEST : %@",timetest);
            
            
            NSDate *specialtime = [dateFormat dateFromString:@"11:00:00 AM "];
            NSLog(@"SpecialTime: %@",specialtime);
            

            
            switch ([/*timetest*/ now compare:specialtime]) {
                case (NSOrderedAscending):{
                    NSLog(@"Before");
                    _view1.hidden = NO;
                    _view2.hidden = YES;
                    break;
                }
                case (NSOrderedDescending):{
                    NSLog(@"After");
                    _view2.hidden = NO;
                    [self Getdata];
                    break;
                }
                case (NSOrderedSame):{
                    NSLog(@"Same");
                    _view2.hidden = NO;
                    [self Getdata];
                    break;
                    
                }
                    
                default:
                    break;
            }
            
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) Getdata {
    
    geocoder = [[CLGeocoder alloc] init];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self->locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            
            [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
            [[PFUser currentUser] saveInBackground];
        }
    }];
    
    PFUser *user = [PFUser currentUser];
    PFGeoPoint *userGeoPoint = user[@"currentLocation"];
    
    PFQuery *qr = [PFQuery queryWithClassName:@"shop"];
    [qr whereKey:@"Shoplocation" nearGeoPoint:userGeoPoint withinKilometers:10];

    
    [qr findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error) {
        
        if(!error)
        {
            
            data = [[NSMutableArray alloc] initWithArray:objects];
            data = objects;
            int index = data.count;
            randomindex = arc4random() % index;
            //NSLog(@"Random = %d",randomindex);
            
            PFObject *obj = [data objectAtIndex:randomindex];
            _name.text = [obj objectForKey:@"Name"];
            keepName = _name.text;
            _promo.text = [obj objectForKey:@"specialpromotion"];
            keepPromo = _promo.text;
            
           PFGeoPoint *point = [obj objectForKey:@"Shoplocation"];
            
        loc = [[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];


            
            PFFile *theImage = [obj objectForKey:@"pic"];
            NSData *imageData;
            imageData = [theImage getData];
            
            UIImage *aImage;
            aImage = [UIImage imageWithData:imageData];
            _imgview.image =aImage;
 
        }
        else
        {
            NSLog(@"Errorrrr = %@",error);
            
        }
    }];
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        
            placemark = [placemarks lastObject];
            
            /*  NSLog(@"%@", [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
             placemark.subThoroughfare, placemark.thoroughfare,
             placemark.postalCode,placemark.locality,
             placemark.administrativeArea,
             placemark.country]); */
            self.locate.text = [NSString stringWithFormat:@"%@ , %@",
                                       placemark.locality,
                                       placemark.administrativeArea];
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)privilege:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get Privilege!" message:@" Would you like to use privilege ? " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
    alert.tag=101;
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 101) {
        
        if (buttonIndex == 0) {
            
            NSLog(@"Cancle");
        }
        
        else if(buttonIndex == 1){
            
            [self keepdata];
            
            
        
            
            
            _can.enabled = NO;
            
            

           int64_t delayInSeconds = 86400;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                _can.enabled = YES;
                
         
                
            });
            
            
        }
        
    }
    
}

-(void)keepdata{
    
    PFUser *curuser = [PFUser currentUser];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Thailand"]];
    
    PFObject *addd = [PFObject objectWithClassName:@"used"];
    [addd setObject:curuser.username forKey:@"user"];
    [addd setObject:keepName forKey:@"name"];
    [addd setObject:keepPromo forKey:@"promotion"];
    [addd setObject:keepdate  = [dateFormat stringFromDate:now]forKey:@"timeused"];
    

    
    [addd saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            NSLog(@"okokokokokokok");
            
        } else {
 
        }
        
    }];
    

    
}



@end
