//
//  signup.h
//  ST
//
//  Created by Wongsaphat Praisri on 8/10/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface signup : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UITextField *repass;
@property (weak, nonatomic) IBOutlet UITextField *email;
- (IBAction)select:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
- (IBAction)confirm:(id)sender;
- (IBAction)take:(id)sender;
@end
