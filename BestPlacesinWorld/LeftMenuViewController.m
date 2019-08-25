//
//  LeftMenuViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MenuTableViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <FirebaseAuth/FIRUser.h>
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <FirebaseAuth/FIRAuth.h>
#import "LoginViewController.h"
#import <SpinKit/RTSpinKitView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import <APMultiMenu/APMultiMenu.h>
@interface LeftMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *menutableView;
@property (nonatomic) NSArray *tableElements;
@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableElements = [[NSArray alloc] initWithObjects:@"Home", @"Wishlist",@"My Reviews",@"Map",@"Profile",@"Feedback", @"Logout", nil];
    
    self.menutableView.dataSource = self;
    self.menutableView.delegate = self;
    self.menutableView.backgroundColor = [UIColor clearColor];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
     //self.navigationController.navigationBar.hidden=YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableElements count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MenuTableViewCell"] ;
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.menutitleLabel.text=[_tableElements objectAtIndex:indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==  0) {

          [self.sideMenuContainerViewController setMainViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeNav"]];
     
    }
    if (indexPath.row ==  1) {
        
        [self.sideMenuContainerViewController setMainViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"WishNav"]];
    }
    if (indexPath.row ==  2) {
        
        [self.sideMenuContainerViewController setMainViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ReviewNav"]];
    }
    if (indexPath.row ==  3) {
        
        [self.sideMenuContainerViewController setMainViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MapNav"]];
    }
    if (indexPath.row ==  4) {
        
        [self.sideMenuContainerViewController setMainViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileNav"]];
    }
     if (indexPath.row ==  5) {
        
          [self.sideMenuContainerViewController setMainViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackNav"]];
     }
    if (indexPath.row ==  6) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] isEqualToString:@"Guest"]) {
          
            [self resetDefaults];
            UINavigationController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
            [self presentViewController:vc animated:true completion:nil];

        }
        else
        {
        RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWanderingCubes color:[UIColor whiteColor]];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.square = YES;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = spinner;
        hud.labelText = @"Logging out";
        [spinner startAnimating];
        NSError *signOutError;
        
        BOOL status = [[FIRAuth auth] signOut:&signOutError];
        if (!status) {
             [hud hideAnimated:true];
            NSLog(@"Error signing out: %@", signOutError);
            return;
        }else{
        
          
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:true];
                [self resetDefaults];
                UINavigationController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
                [self presentViewController:vc animated:true completion:nil];
            });
          
            
        }
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
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
