//
//  HomeViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "HomeViewController.h"
#import <APMultiMenu.h>
#import "HomeTableViewCell.h"
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <SpinKit/RTSpinKitView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/SDWebImage.h>
#import "DetailViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *hometableview;
@property (nonatomic) NSArray *cititesArray;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
   //  _cititesArray = [[NSArray alloc] initWithObjects:@"Istanbul", @"Baku", @"Newyork",@"Phuket",@"Lahore", @"Delhi",@"London",@"Paris", nil];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftMenu:)];
    self.title = [NSString stringWithFormat:@"Welcome %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
    
      self.hometableview.backgroundColor = [UIColor clearColor];
    [self getUserData];
    
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cititesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeTableViewCell"] ;
        
    }
    //cell.menutitleLabel.text=[_tableElements objectAtIndex:indexPath.row];
    NSDictionary *dic=[_cititesArray objectAtIndex:indexPath.row];
     cell.backgroundColor = [UIColor clearColor];
    cell.nameLabel.text=[dic objectForKey:@"Name"];
    cell.cityImage.layer.cornerRadius=10.0;
    cell.cityImage.layer.borderWidth=1;
    cell.cityImage.layer.borderColor=[UIColor whiteColor].CGColor;
   [cell.cityImage sd_setImageWithURL:[dic objectForKey:@"Image"]
                                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.favouriteButton.tag=indexPath.row;
    [cell.favouriteButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(void)buttonClicked:(id)sender
{
    NSLog(@"tag number is = %ld",(long)[sender tag]);
    //In this case the tag number of button will be same as your cellIndex.
    // You can make your cell from this.
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] isEqualToString:@"Guest"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Signup or Login" subTitle:@"Please signup or Login for this Action" closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSDictionary *city = [_cititesArray objectAtIndex:[sender tag]];
   
    [[[[[self.ref child:@"users"] child: [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] ] child:@"userwishlist"] childByAutoId] setValue:@{@"city": city}];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
  
     [alert showSuccess:self title:@"Successfully" subTitle:@"added to Wishlist" closeButtonTitle:@"OK" duration:0.0f];
    }
  
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vc.citydata=[_cititesArray objectAtIndex:indexPath.row];
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
-(void)getUserData
{
    
    
    RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWanderingCubes color:[UIColor whiteColor]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.square = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = spinner;
    hud.labelText = @"Getting Data";
    
    [[_ref child:@"Cities"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
    {
        // Get user value

        NSMutableArray *array=snapshot.value;
        [array removeObjectAtIndex:0];
        self.cititesArray=array.mutableCopy;
        [self.hometableview reloadData];
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

@end
