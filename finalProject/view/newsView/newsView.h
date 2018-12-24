//
//  newsView.h
//  finalProject
//
//  Created by taizhou on 2018/12/24.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface newsView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *title;
-(void)setimgWithUrl:(NSString*)url title:(NSString*)title;

@end


