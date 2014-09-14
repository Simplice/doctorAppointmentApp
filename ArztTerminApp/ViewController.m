//
//  ViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 22.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@property (nonatomic, strong) UISwitch *switcher;

@end

@implementation ViewController

@synthesize infoTextLabel = _infoTextLabel;

@synthesize switcher = _switcher;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // ajouter une image au backgroungColor
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"320-fond.jpg"]];
    
    self.infoTextLabel.attributedText = [self makeAttributedStringFromString:self.infoTextLabel.text];
    
    //
    self.switcher = [[UISwitch alloc] init];
    [self.switcher setOn:YES];
    // Alert initialisieren und anzeigen
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"" delegate:self cancelButtonTitle:@"abbrechen" otherButtonTitles:@"senden", nil];
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    if (!self.switcher.isOn) {
        [self viewDidLoad];
    } else {
        [self.tabBarController.tabBar setHidden:NO];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    if (self.tabBarController.selectedIndex == 0) {
        [self.switcher setOn:NO];
    } else {
        [self.tabBarController.tabBar setHidden:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSString *username = [alertView textFieldAtIndex:0].text;
        NSString *passwort = [alertView textFieldAtIndex:1].text;
        if (![username isEqualToString:@""] && ![passwort isEqualToString:@""]
            && [username isEqualToString:cUsername] && [passwort isEqualToString:cpasswort]) {
            
            [self.switcher setOn:YES];
            return;
        }
    }
    [self.tabBarController setSelectedIndex:0];
    [self.switcher setOn:NO];
    
}

-(NSMutableAttributedString*) makeAttributedStringFromString: (NSString*) textString {
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:textString];
    NSInteger stringLength=[textString length];
    UIColor *strokeColor=[UIColor blackColor];
    UIColor *backgroundColor=[UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.5];
    UIColor *foregroundColor=[UIColor colorWithRed:0.4 green:0.6 blue:0.93 alpha:0.75];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, stringLength)];
    [attString addAttribute:NSStrokeColorAttributeName value:strokeColor range:NSMakeRange(0, stringLength)];
    [attString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:-3.0] range:NSMakeRange(0, stringLength)];
    [attString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:NSMakeRange(28, 11)]; // 28 is the index where to start end 11 means counting 11 character after the startindex, even the startindex including
    
    return attString;
}

@end
