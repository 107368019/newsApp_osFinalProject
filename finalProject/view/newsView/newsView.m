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
    
    
    _title.text=title;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
        if (imgData){
            dispatch_async(dispatch_get_main_queue(), ^{                
                UIImage *image = [UIImage imageWithData:imgData];
                self.imgView.image=image;
            });
        }
    });
    
}
@end
