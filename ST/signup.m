//
//  signup.m
//  ST
//
//  Created by Wongsaphat Praisri on 8/10/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import "signup.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface signup ()

@end

@implementation signup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


-(void) viewWillAppear:(BOOL)animated{
    
    PFUser *user = [PFUser currentUser];
    if (user.username != nil) {
        [self performSegueWithIdentifier:@"home" sender:self];
  
    }
    
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

- (IBAction)confirm:(id)sender {
    
    [self CheckTextEmpty];
}

-(void)CheckTextEmpty {
    
    if ([_user.text isEqualToString:@""] || [_pass.text isEqualToString:@""] || [_repass.text isEqualToString:@""] || [_email.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Field is Empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [self viewDidLoad];
    } else{
        
        [self CheckPasswordMatch];
        
    }
}

-(void)CheckPasswordMatch {
    
    if (![_pass.text isEqualToString:_repass.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Password not match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [self viewDidLoad];
    } else {
        
        [self RegisterNewUser];
    }
}
-(void) RegisterNewUser {
    
    PFUser *newUser = [PFUser user];
    newUser.username = _user.text;
    newUser.password = _pass.text;
    newUser.email = _email.text;
    
    NSData* data = UIImageJPEGRepresentation(_imgview.image, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];


    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded , NSError *error){
        if(!error){
            
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // The image has now been uploaded to Parse. Associate it with a new object
                    [newUser setObject:imageFile forKey:@"img"];
                    
                    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            NSLog(@"Saved");
                        }
                        else{
                            // Error
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
                }
            }];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Sign Up Success" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            [self performSegueWithIdentifier:@"home" sender:self];

        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Username, Password or e-mail incorrect " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    


}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



//////////// Photo ///////////////////


- (IBAction)take:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }
}



- (IBAction)select:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imgview.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)fblog:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"fetched user:%@ ", result);
                             NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", result[@"id"]]];
                             NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
                           //  UIImage *fbImage = [UIImage imageWithData:imageData];
                             PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
                             
                             PFUser *fbnew = [PFUser user];
                             fbnew.username = result[@"name"];
                             fbnew.password = @"facebook";
                             
                             
                             [fbnew signUpInBackgroundWithBlock:^(BOOL succeeded , NSError *error){
                                 if(!error){
                                     
                                     
                                     [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             // The image has now been uploaded to Parse. Associate it with a new object
                                             [fbnew setObject:imageFile forKey:@"img"];
                                             
                                             [fbnew saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                 if (!error) {
                                                     NSLog(@"Saved");
                                                     //[self performSegueWithIdentifier:@"home" sender:self];

                                                 }
                                                 else{
                                                     // Error
                                                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                                                 }
                                             }];
                                         }
                                     }];
                                     [self performSegueWithIdentifier:@"home" sender:self];

                                 }
                             }];
                             
                             
                             
                       
                         }
                         
                     }];
                }
            }
        }
    }];


}




@end
