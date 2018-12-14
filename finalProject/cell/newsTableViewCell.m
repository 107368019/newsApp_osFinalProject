//
//  newsTableViewCell.m
//  finalProject
//
//  Created by taizhou on 2018/12/13.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "newsTableViewCell.h"
@interface newsTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *newsType;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *publisher;


@end

@implementation newsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
