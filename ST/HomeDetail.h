//
//  HomeDetail.h
//  ST
//
//  Created by Wongsaphat Praisri on 8/8/15.
//  Copyright (c) 2015 Wongsaphat Praisri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HomeDetail : UIViewController

@property (nonatomic, strong) PFObject *exam;

@property (weak, nonatomic) IBOutlet UILabel *promotion;
@property (weak, nonatomic) IBOutlet UITextView *branch;
@property (weak, nonatomic) IBOutlet UITextView *terms;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *locate;

@end
