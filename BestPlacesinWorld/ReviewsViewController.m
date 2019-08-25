//
//  ReviewsViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "ReviewsViewController.h"
#import <APMultiMenu.h>
#import "ReviewTableViewCell.h"
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <SpinKit/RTSpinKitView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/SDWebImage.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
@interface ReviewsViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic) NSArray *reviewsArray;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation ReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.ref = [[FIRDatabase database] reference];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftMenu:)];
    self.title = @"Your Reviews";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] isEqualToString:@"Guest"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Signup or Login" subTitle:@"Please signup or Login to see your reviews" closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
    [self getUserData];
    }
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
    return _reviewsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewTableViewCell"];
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ReviewTableViewCell"] ;
        
    }
    NSDictionary *city=[[_reviewsArray objectAtIndex:indexPath.row] objectForKey:@"review"];
    //cell.menutitleLabel.text=[_tableElements objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.cityNameLabel.text=[city objectForKey:@"Name"];
    cell.userNameLabel.text=[city objectForKey:@"review"];
    [cell.cityImage sd_setImageWithURL:[city objectForKey:@"Image"]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.ratingView.backgroundColor=[UIColor clearColor];
    cell.ratingView.value=[[city objectForKey:@"rating"] floatValue];
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
    hud.labelText = @"Getting User Reviews";
    
    [[[[_ref child:@"users"] child:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]child:@"userreview"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         // Get user value
         NSMutableArray *array=[[NSMutableArray alloc] init];
         
         
         
         
         for (snapshot in snapshot.children)
         {
             [array addObject:snapshot.value];
             
         }
         self.reviewsArray=array.mutableCopy;
         [self.reviewTableView reloadData];
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
