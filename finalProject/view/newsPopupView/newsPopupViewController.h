//
//  newsPopupViewController.h
//  finalProject
//
//  Created by taizhou on 2018/12/25.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newsRes.h"
NS_ASSUME_NONNULL_BEGIN

@interface newsPopupViewController : UIViewController
- (void)showInVC:(UIViewController *)vc data:(content_newsReq*)data;

@end

NS_ASSUME_NONNULL_END
