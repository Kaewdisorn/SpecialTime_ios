//
//  Profile.h
//  ST
//
//  Created by Wongsaphat Praisri on 8/7/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface Profile : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *email;

- (IBAction)logout:(id)sender;



@end
