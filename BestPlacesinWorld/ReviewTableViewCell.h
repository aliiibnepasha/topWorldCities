//
//  ReviewTableViewCell.h
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCSStarRatingView/HCSStarRatingView.h>
NS_ASSUME_NONNULL_BEGIN

@interface ReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

@end

NS_ASSUME_NONNULL_END
