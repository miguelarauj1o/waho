//
//  ListViewTableViewCell.m
//  waho
//
//  Created by Déborah Mesquita on 19/07/15.
//  Copyright (c) 2015 Miguel Araújo. All rights reserved.
//

#import "ListViewTableViewCell.h"

@implementation ListViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    if([[UIScreen mainScreen] bounds].size.height == 667.00){
        self.constraintImgCategory.constant = 320.00;
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
