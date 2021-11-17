//
//  HomeDetail.m
//  ST
//
//  Created by Wongsaphat Praisri on 8/8/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import "HomeDetail.h"
#import <CoreLocation/CoreLocation.h>


@interface HomeDetail ()<CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *location,*location1,*location2;
    CLLocation *loc;
}


@end

@implementation HomeDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [_exam objectForKey:@"Name"];
    
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self->locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    _promotion.text = [_exam objectForKey:@"promotion"];
    _branch.text = [_exam objectForKey:@"branch"];
    _terms.text = [_exam objectForKey:@"term"];
    
    
    PFFile *userImageFile = _exam[@"pic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            
            _imgview.image = image;
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
   
            
    
    PFGeoPoint *point = [_exam objectForKey:@"Shoplocation"];
            
    loc = [[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];

    
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
- (IBAction)MAP:(id)sender {
    
    PFGeoPoint *point1 =[_exam objectForKey:@"Shoplocation"];
    location1 = [[CLLocation alloc] initWithLatitude:point1.latitude longitude:point1.longitude];
    
    //CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake(31.20691,121.477847);

   // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",point1.latitude,point1.longitude]];
    
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f",point1.latitude,point1.longitude]];
    
    
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        NSLog(@"Google Maps app is not installed");
        //left as an exercise for the reader: open the Google Maps mobile website instead!
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
