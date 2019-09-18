//
//  BeerTableCell.h
//  Beer App
//
//  Created by Admins on 19/01/19.
//  Copyright © 2019 Monish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PodListTableCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *img;
@property (nonatomic, weak) IBOutlet UIImageView *locationIcon;
@property (nonatomic, weak) IBOutlet UIImageView *capacityIcon;
@property (nonatomic, weak) IBOutlet UIImageView *timeIcon;
@property (nonatomic, weak) IBOutlet UIImageView *dateIcon;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *address;
@property (nonatomic, weak) IBOutlet UILabel *occupancy;
@property (nonatomic, weak) IBOutlet UILabel *price;
@property (nonatomic, weak) IBOutlet UILabel *timeLbl;
@property (nonatomic, weak) IBOutlet UILabel *idLbl;
@property (nonatomic, weak) IBOutlet UIButton *bookBtn;

@end

NS_ASSUME_NONNULL_END
