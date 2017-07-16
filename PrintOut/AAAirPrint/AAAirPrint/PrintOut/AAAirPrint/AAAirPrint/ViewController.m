//
//  ViewController.m
//  AAAirPrint
//
//  Created by AKSHAY AWTADE on 16/07/17.
//  Copyright © 2017 AKSHAY AWTADE. All rights reserved.
//

#import "ViewController.h"
#define pageHeight 792
#define pageWidth  612
@interface ViewController ()

@end

@implementation ViewController{
    UIButton *printButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)PrintDataWithName:(NSString *) name Flat:(NSString *) flatno street:(NSString *)street city :(NSString *)city {
    printButton=[[UIButton alloc]initWithFrame:CGRectMake(100, 200, 70, 70)];
    [printButton setTitle:@"PRINT" forState:UIControlStateNormal];
    [self savePDFWithName:name flat_no:flatno street:street city:city];
    //[NSBundle mainBundle]re
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.jobName =@"Report";
    
    pc.printInfo = printInfo;
    pc.showsNumberOfCopies = YES;
    pc.printingItem = [NSURL fileURLWithPath:self.pdfFilePath];
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %ld", error.domain,
                  (long)error.code);
            [self alertWithMessage:[NSString stringWithFormat:@"Failed to print, error: %@",error.localizedDescription]];
        }
    };
    
    
    [pc presentFromRect:printButton
     .frame inView:self.view animated:YES completionHandler:completionHandler];
}
- (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange

       andFramesetter:(CTFramesetterRef)framesetter
{
    
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Create a path object to enclose the text. Use 72 point
    
    // margins all around the text.
    
    CGRect    frameRect = CGRectMake(100, 100, 368, 648);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    
    // The currentRange variable specifies only the starting point. The framesetter
    
    // lays out as much text as will fit into the frame.
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    
    CGPathRelease(framePath);
    
    // Core Text draws from the bottom-left corner up, so flip
    
    // the current transform prior to drawing.
    
    CGContextTranslateCTM(currentContext, 0, pageHeight);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    
    CTFrameDraw(frameRef, currentContext);
    
    // Update the current range based on what was drawn.
    
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    
    currentRange.location += currentRange.length;
    
    currentRange.length = 0;
    
    CFRelease(frameRef);
    
    return currentRange;
    
}

- (void)drawPageNumber:(NSInteger)pageNum
{
    NSString* pageString = [NSString stringWithFormat:@""];
    
    UIFont* theFont = [UIFont systemFontOfSize:25];
    
    CGSize pageStringSize = [pageString sizeWithAttributes:
                             
                             @{NSFontAttributeName:
                                   
                                   theFont}];
    
    CGRect stringRect = CGRectMake(((pageWidth - pageStringSize.width) / 2.0),
                                   
                                   720.0 + ((72.0 - pageStringSize.height) / 2.0) ,
                                   
                                   pageStringSize.width,
                                   
                                   pageStringSize.height);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName: paragraphStyle};
    
    [pageString drawInRect:stringRect withAttributes:attributes];
    
}



-(void)savePDFWithName:(NSString *) name flat_no:(NSString *) flatNo street:(NSString *)street_no city :(NSString *)city{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Report" ofType:@"pdf"];
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    
    path = [arrayPaths objectAtIndex:0];
    
    self.pdfFilePath = [path stringByAppendingPathComponent:
                        
                        [NSString stringWithFormat:@"%f.pdf",
                         
                         [[NSDate date]
                          
                          timeIntervalSince1970] ]];
    
    // Prepare the text using a Core Text Framesetter
    NSString *stringToPrint=[NSString stringWithFormat:@"Hi %@ here is your entered address: \n Flat NO:- %@ Street No: %@ City: %@",name,flatNo,street_no,city];
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL,
                                                                 
                                                                 (CFStringRef)stringToPrint, NULL);
    
    
    
    if (currentText) {
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
        
        if (framesetter) {
            
            NSString* pdfFileName = self.pdfFilePath;
            
            //[NSString stringWithString:@"test.pdf"];
            
            // Create the PDF context using the default page: currently constants at the size
            
            // of 612 x 792.
            
            UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
            
            CFRange currentRange = CFRangeMake(0, 0);
            
            NSInteger currentPage = 0;
            
            BOOL done = NO;
            
            do {
                
                // Mark the beginning of a new page.
                
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageWidth,
                                                          
                                                          pageHeight), nil);
                
                
                
                // Draw a page number at the bottom of each page
                
                currentPage++;
                
                [self drawPageNumber:currentPage];
                
                
                // Render the current page and update the current range to
                
                // point to the beginning of the next page.
                
                currentRange = [self renderPage:currentPage withTextRange:
                                
                                currentRange andFramesetter:framesetter];
                
                
                
                // If we're at the end of the text, exit the loop.
                
                if (currentRange.location == CFAttributedStringGetLength
                    
                    ((CFAttributedStringRef)currentText))
                    
                    done = YES;
                
            } while (!done);
            
            
            // Close the PDF context and write the contents out.
            
            UIGraphicsEndPDFContext();
            
            // Release the framewetter.
            
            CFRelease(framesetter);
            
        } else {
            
            NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
            
        }
        
        // Release the attributed string.
        
        CFRelease(currentText);
        
    } else {
        
        NSLog(@"Could not create the attributed string for the framesetter");
        
    }
    
}
#pragma mark - QLPreviewControllerDataSource

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    
    return 1;
    
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    
    return [NSURL fileURLWithPath:self.pdfFilePath];
    
}


-(void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController{
    NSLog(@"print started");
}
-(void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController{
    NSLog(@"Finished Job");
   [self alertWithMessage:@"Finished Printing"];
    
    
}




-(void)alertWithMessage: (NSString *)stringMessage{
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"AIRPRINT" message:stringMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}



- (IBAction)buttonPrintTapped:(id)sender {
    if(self.textFeildCity.text.length>0 && self.textFeildStretNo.text.length>0 && self.textFeildFlat.text.length>0 && self.textFeildName.text.length>0){
    [self PrintDataWithName:self.textFeildName.text Flat:self.textFeildFlat.text street:self.textFeildStretNo.text city:self.textFeildCity.text];
    }else{
        [self alertWithMessage:@"Please fill all the details and try again."];
    }
    }

- (IBAction)aboutUSButtonTapped:(id)sender {
    [self alertWithMessage:@"Airprint \n Version 1.0 \n Developed by: Akshay Awtade\nContact No: +918308011436"];
}
@end
