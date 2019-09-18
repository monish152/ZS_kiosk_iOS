//
//  BeerTableCell.m
//  Beer App
//
//  Created by Admins on 19/01/19.
//  Copyright © 2019 Monish Kumar. All rights reserved.
//

#import "PodListTableCell.h"

@implementation PodListTableCell
@synthesize img = _img;
@synthesize locationIcon = _locationIcon;
@synthesize capacityIcon = _capacityIcon;
@synthesize timeIcon = _timeIcon;
@synthesize title = _title;
@synthesize address = _address;
@synthesize occupancy = _occupancy;
@synthesize price = _price;
@synthesize bookBtn = _bookBtn;
@synthesize idLbl = _idLbl;
@synthesize dateIcon = _dateIcon;
@synthesize timeLbl = _timeLbl;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
