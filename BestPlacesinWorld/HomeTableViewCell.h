//
//  HomeTableViewCell.h
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

@end

NS_ASSUME_NONNULL_END
