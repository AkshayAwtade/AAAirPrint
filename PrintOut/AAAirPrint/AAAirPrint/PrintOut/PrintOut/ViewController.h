//
//  ViewController.h
//  PrintOut
//
//  Created by AKSHAY AWTADE on 13/07/17.
//  Copyright © 2017 AKSHAY AWTADE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *contactTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *cityTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *zipcodetextFeild;
- (IBAction)printButtonTapped:(id)sender;

@end

