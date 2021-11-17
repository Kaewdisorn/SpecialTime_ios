//
//  Profile.m
//  ST
//
//  Created by Wongsaphat Praisri on 8/7/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import "Profile.h"
#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface Profile ()<CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
}

@end

@implementation Profile
@synthesize imgview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Profile";
    
    PFUser *user = [PFUser currentUser];
    PFFile *pic = [user objectForKey:@"img"];
    _user.text = user.username;
    _email.text = user.email;
    
    [pic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        if (!error) {
            
            imgview.image = [UIImage imageWithData:pic.getData];
            
        }
    }];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)logout:(id)sender {
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Logout" message:@"Would you like to logout?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancle",nil];
    
    
    
    messageAlert.tag=101;
    [messageAlert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 101) {
        
        if (buttonIndex == 0) {
            
            [PFUser logOut];
            exit(0);
            
        } else if(buttonIndex == 1){
            NSLog(@"Cancle");


        }
        
        
    }

    
}


@end
