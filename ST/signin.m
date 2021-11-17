//
//  signin.m
//  ST
//
//  Created by Wongsaphat Praisri on 8/8/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import "signin.h"

@interface signin ()

@end

@implementation signin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)signin:(id)sender {
    
    [PFUser logInWithUsernameInBackground:_user.text password:_pass.text block:^(PFUser *user , NSError *error){
        
        if(!error){
            [self performSegueWithIdentifier:@"home" sender:self];
            [self viewDidLoad];
            
        }
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Username or Password incorrect !! " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [self viewDidLoad];
            
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
