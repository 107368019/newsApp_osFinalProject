//
//  newsView.m
//  finalProject
//
//  Created by taizhou on 2018/12/24.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "newsView.h"


@implementation newsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)setimgWithUrl:(NSString*)url title:(NSString*)title{
    
    [_imgView setImage:[UIImage imageNamed:@"homeCubee"]];
    _title.text=title;
    
    
}
@end
