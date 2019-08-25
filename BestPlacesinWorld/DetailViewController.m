//
//  DetailViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "DetailViewController.h"
#import "HomeTableViewCell.h"
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <SpinKit/RTSpinKitView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/SDWebImage.h>
#import "DetailViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import "DetailViewController.h"
#import "AddReviewViewController.h"
#import "CityReviewsViewController.h"


@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIView *AboutView;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *AddReviewBtnBg;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.ref = [[FIRDatabase database] reference];
    self.cityImage.layer.cornerRadius=10.0;
    self.AboutView.layer.cornerRadius=9.0;
    self.AddReviewBtnBg.layer.cornerRadius=5.0;
    
    _descriptionLabel.text=[_citydata objectForKey:@"Description"];
    _nameLabel.text=[_citydata objectForKey:@"Name"];
    _countryLabel.text=[_citydata objectForKey:@"Country"];
    [_cityImage sd_setImageWithURL:[_citydata objectForKey:@"Image"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    // Do any additional setup after loading the view.
}
- (IBAction)addReviewButtonTouched:(id)sender
{
    AddReviewViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddReviewViewController"];
    vc.citydata=_citydata;
    [self.navigationController pushViewController:vc animated:true];
}
- (IBAction)addToWishlistButtonTouched:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] isEqualToString:@"Guest"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Signup or Login" subTitle:@"Please signup or Login for this Action" closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
    [[[[[self.ref child:@"users"] child: [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] ] child:@"userwishlist"] childByAutoId] setValue:@{@"city": _citydata}];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showSuccess:self title:@"Successfully" subTitle:@"added to Wishlist" closeButtonTitle:@"OK" duration:0.0f];
    }
}
- (IBAction)seereviewButtonTouched:(id)sender
{
    
    CityReviewsViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CityReviewsViewController"];
    vc.citydata=_citydata;
    [self.navigationController pushViewController:vc animated:true];
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
