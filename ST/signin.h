//
//  signin.h
//  ST
//
//  Created by Wongsaphat Praisri on 8/8/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface signin : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pass;

- (IBAction)signin:(id)sender;
@end
