//
//  newsPopupViewController.m
//  finalProject
//
//  Created by taizhou on 2018/12/25.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "newsPopupViewController.h"

@interface newsPopupViewController ()
@property (strong, nonatomic) IBOutlet UILabel *publish;
@property (strong, nonatomic) IBOutlet UIImageView *newsImgview;
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) content_newsReq  *data;
@end

@implementation newsPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setting];
}

- (void)setting{
    _titleLabel.text=_data.title;
    _textview.text=_data.content;
    _publish.text=_data.publisher;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.data.imageUrl]];
        if (imgData){
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                UIImage *image = [UIImage imageWithData:imgData];
                self.newsImgview.image=image;
            });
        }
    });
}

- (void)showInVC:(UIViewController *)vc data:(content_newsReq*)data{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.data=data;
        
        
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        
        // Animation 1，移除的話會變成由下往上刷(present的預設動畫)
        CATransition* transition = [CATransition animation];
        transition.duration = 1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        
        [vc presentViewController:self animated:false completion:^{
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.view.alpha = 0;
            [UIView animateWithDuration:.25 animations:^{
                self.view.alpha = 1;
                self.view.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    });
}

- (void)dissmissSelfFromView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CATransition* transition = [CATransition animation];
        transition.duration = .25;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        
        [self dismissViewControllerAnimated:false completion:nil];
    });
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dissmissSelfFromView];
    
}


@end
