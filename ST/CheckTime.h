//
//  CheckTime.h
//  ST
//
//  Created by Wongsaphat Praisri on 8/9/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckTime : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *promo;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *locate;
- (IBAction)privilege:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *can;

@end
