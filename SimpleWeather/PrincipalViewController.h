//
//  PrincipalViewController.h
//  SimpleWeather
//
//  Created by Luis Fernando Guisso Filho on 05/11/13.
//  Copyright (c) 2013 Luis Fernando Guisso Filho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <XMLDictionary/XMLDictionary.h>


@interface PrincipalViewController : UIViewController <CLLocationManagerDelegate>{
    NSString * city;
    IBOutlet UISearchBar * meuSearch;
    IBOutlet UILabel *cidade, *graus, *condicao, *umidade, *vento, *dia;
    CLLocationManager * gpsManager;
    CLPlacemark * local;
}

@end