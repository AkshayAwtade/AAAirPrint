//
//  ViewController.h
//  AAAirPrint
//
//  Created by AKSHAY AWTADE on 16/07/17.
//  Copyright © 2017 AKSHAY AWTADE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuickLook/QuickLook.h>
@interface ViewController : UIViewController<UIPrintInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFeildName;
@property (weak, nonatomic) IBOutlet UITextField *textFeildFlat;
@property (weak, nonatomic) IBOutlet UITextField *textFeildStretNo;
@property (weak, nonatomic) IBOutlet UITextField *textFeildCity;
- (IBAction)buttonPrintTapped:(id)sender;
- (IBAction)aboutUSButtonTapped:(id)sender;
@property (nonatomic, retain) NSString* pdfFilePath;

@end

