//
//  PrincipalViewController.m
//  SimpleWeather
//
//  Created by Luis Fernando Guisso Filho on 05/11/13.
//  Copyright (c) 2013 Luis Fernando Guisso Filho. All rights reserved.
//

#import "PrincipalViewController.h"

@interface PrincipalViewController ()

@end

@implementation PrincipalViewController

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [gpsManager stopUpdatingLocation];
    CLLocation * loc = locations[0];
    CLGeocoder * geoC =[[CLGeocoder alloc]init];
    [geoC reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count>0) {
            local = placemarks[0];
            cidade.text = local.locality;
            NSString * cityWoeid = local.locality;
            cityWoeid = [cityWoeid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * pickWoeid = [NSString stringWithFormat:@"http://where.yahooapis.com/v1/places.q('%@')?appid=[xl9vzx_V34FMv8Peb.kCcB75Gmi_7n2rKkytVEVPOUj0CTmMnhXda0KrupNzKOGw_dN54ydrvasuGxTyST0iA7WFapE.WIg-]", cityWoeid];
            NSData * infoWoeid = [NSData dataWithContentsOfURL:[NSURL URLWithString:pickWoeid]];
            XMLDictionaryParser * dados = [[XMLDictionaryParser alloc]init];
            NSDictionary * woeid =  [dados dictionaryWithData:infoWoeid];
            NSString * dadosClima = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c", woeid[@"place"][@"woeid"]];
            NSData * infoClima = [NSData dataWithContentsOfURL:[NSURL URLWithString:dadosClima]];
            XMLDictionaryParser * info = [[XMLDictionaryParser alloc]init];
            NSDictionary * clima = [info dictionaryWithData:infoClima];
            NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Documents/clima.plist"];
            [clima writeToFile:path atomically:true];
            graus.text = [NSString stringWithFormat:@"%@",clima[@"channel"][@"item"][@"yweather:condition"][@"_code"]];
            condicao.text = [NSString stringWithFormat:@"%@",clima[@"channel"][@"item"][@"yweather:condition"][@"_text"]];
            umidade.text = [NSString stringWithFormat:@"%@", clima[@"channel"][@"yweather:atmosphere"][@"_humidity"]];
            vento.text = [NSString stringWithFormat:@"%@", clima[@"channel"][@"yweather:wind"][@"_speed"]];
            dia.text = [NSString stringWithFormat:@"%@", clima[@"channel"][@"item"][@"yweather:forecast"][0][@"_day"]];
        }
    }];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //guardo o texto
    city = searchBar.text;
    //pego o texto converto, tiro os espaços
    city = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //pego o texto digitado e jogo no url do API
    NSString * api = [NSString stringWithFormat:@"http://www.previsaodotempo.org/api.php?city=%@", city];
    //carregar o link da api
    NSData * dados = [NSData dataWithContentsOfURL:[NSURL URLWithString:api]];
    //transformo o JSON em um dicionario
    NSDictionary * d = [NSJSONSerialization JSONObjectWithData:dados options:NSJSONReadingAllowFragments error:nil];
    NSString * temp = d[@"data"][@"temperature"];
    float tempNumero = [temp floatValue];
    float celcius = (tempNumero - 32.0)*(5.0/9.0);
    graus.text =[NSString stringWithFormat:@"%.0f˚",celcius];
    cidade.text = [NSString stringWithFormat:@"%@", local.location];
    condicao.text = [NSString stringWithFormat:@"%@",d[@"data"][@"skytext"]];
    umidade.text = [NSString stringWithFormat:@"%@ mm",d[@"data"][@"humidity"]];
    vento.text = [NSString stringWithFormat:@"%@ Km/h",d[@"data"][@"wind"]];
    dia.text = [NSString stringWithFormat:@"%@",d[@"data"][@"day"]];
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([CLLocationManager locationServicesEnabled]) {
        gpsManager = [[CLLocationManager alloc]init];
        gpsManager.delegate = self;
        [gpsManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
