//
//  WishListViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "WishListViewController.h"
#import <APMultiMenu.h>
#import "HomeTableViewCell.h"
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <SpinKit/RTSpinKitView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/SDWebImage.h>
#import "DetailViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
@interface WishListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *wishTabelView;
@property (nonatomic) NSArray *wishlistArray;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation WishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.ref = [[FIRDatabase database] reference];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftMenu:)];
    self.title = @"Your Wishlist!";
      self.wishTabelView.backgroundColor = [UIColor clearColor];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] isEqualToString:@"Guest"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Signup or Login" subTitle:@"Please signup or Login to see your Wishlist" closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
    [self getUserData];
    }
   // self.feedbackButton.layer.cornerRadius=5.0;
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 4;
    return _wishlistArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WishTableViewCell"];
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WishTableViewCell"] ;
        
    }
    //cell.menutitleLabel.text=[_tableElements objectAtIndex:indexPath.row];
    NSDictionary *city=[[_wishlistArray objectAtIndex:indexPath.row] objectForKey:@"city"];
    cell.backgroundColor = [UIColor clearColor];
    cell.nameLabel.text=[city objectForKey:@"Name"];
    cell.cityImage.layer.cornerRadius=10.0;
    cell.cityImage.layer.borderWidth=1;
    cell.cityImage.layer.borderColor=[UIColor whiteColor].CGColor;
    [cell.cityImage sd_setImageWithURL:[city objectForKey:@"Image"]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(void)getUserData
{
    RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWanderingCubes color:[UIColor whiteColor]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.square = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = spinner;
    hud.labelText = @"Getting Wishlist";
    
    [[[[_ref child:@"users"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]child:@"userwishlist"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         // Get user value
         NSMutableArray *array=[[NSMutableArray alloc] init];
         
     
     
         
         for (snapshot in snapshot.children)
         {
             [array addObject:snapshot.value];
            
         }
         self.wishlistArray=array.mutableCopy;
         [self.wishTabelView reloadData];
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [hud hideAnimated:true];
             
         });
         // ...
     } withCancelBlock:^(NSError * _Nonnull error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [hud hideAnimated:true];
             
         });
         NSLog(@"%@", error.localizedDescription);
     }];
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
