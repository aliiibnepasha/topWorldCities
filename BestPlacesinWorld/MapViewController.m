//
//  MapViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "MapViewController.h"
#import <APMultiMenu.h>
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <SpinKit/RTSpinKitView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/SDWebImage.h>
#import "DetailViewController.h"
@interface MapViewController ()
@property (nonatomic) NSArray *cititesArray;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(readonly, NS_NONATOMIC_IPHONEONLY) CLLocationCoordinate2D;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.ref = [[FIRDatabase database] reference];
    
    [self getUserData];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftMenu:)];
    self.title = @"See World Here!";
    
   
    
 
    // Do any additional setup after loading the view.
}

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
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [hud hideAnimated:true];
             for (int i=0; i<self.cititesArray.count; i++)
             {
                 NSDictionary *city=[self.cititesArray objectAtIndex:i];
                 MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                 annotation.title=[city objectForKey:@"Name"];
                 annotation.coordinate=CLLocationCoordinate2DMake([ [city objectForKey:@"lat"] doubleValue], [[city objectForKey:@"long"] doubleValue]);
                 [self.mapView addAnnotation:annotation];
             }
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
