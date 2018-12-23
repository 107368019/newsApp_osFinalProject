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
@property (strong, nonatomic) IBOutlet UIImageView *newsImg;


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

- (void)setCell:(content_newsReq *)data img:(UIImage*)img{
   
    switch (data.type) {
        case 2:
            _newsType.text=@"焦點";
            break;
        case 3:
             _newsType.text=@"國際";
            break;
        case 4:
             _newsType.text=@"財經";
            break;
        case 5:
             _newsType.text=@"社會";
            break;
        case 6:
            _newsType.text=@"科技";
            break;
        case 7:
             _newsType.text=@"旅遊";
            break;
        case 8:
             _newsType.text=@"娛樂";
            break;
        case 10:
             _newsType.text=@"體育";
            break;
        default:
            break;
    }
    _content.text=data.title;
    _publisher.text=data.publisher;
   
    _newsImg.image =img;
}
@end
