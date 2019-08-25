//
//  CityReviewsViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "CityReviewsViewController.h"
#import "ReviewTableViewCell.h"
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <SpinKit/RTSpinKitView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/SDWebImage.h>
@interface CityReviewsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cityReviewTableView;
@property (nonatomic) NSArray *reviewsArray;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation CityReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
          self.ref = [[FIRDatabase database] reference];
    self.title = @"Reviews";
    [self getUserData];
    // Do any additional setup after loading the view.
}
 // Do any additional setup after loading the view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 4;
    return _reviewsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityReviewTableViewCell"];
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CityReviewTableViewCell"] ;
        
    }
    //cell.menutitleLabel.text=[_tableElements objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *city=[[_reviewsArray objectAtIndex:indexPath.row] objectForKey:@"review"];
    //cell.menutitleLabel.text=[_tableElements objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.cityNameLabel.text=[city objectForKey:@"Name"];
    cell.userNameLabel.text=[city objectForKey:@"username"];
    cell.reviewLabel.text=[city objectForKey:@"review"];
    [cell.cityImage sd_setImageWithURL:[city objectForKey:@"Image"]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.ratingView.backgroundColor=[UIColor clearColor];
    cell.ratingView.value=[[city objectForKey:@"rating"] floatValue];
    return cell;
    
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
    hud.labelText = @"Getting City Reviews";
    
    [[[[_ref child:@"Cities"] child:[NSString stringWithFormat:@"%@",[_citydata objectForKey:@"Id"]]] child:@"reviews"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         // Get user value
         NSMutableArray *array=[[NSMutableArray alloc] init];
         
         
         
         
         for (snapshot in snapshot.children)
         {
             [array addObject:snapshot.value];
             
         }
         self.reviewsArray=array.mutableCopy;
         [self.cityReviewTableView reloadData];
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
