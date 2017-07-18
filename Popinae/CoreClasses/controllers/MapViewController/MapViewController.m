//
//  MapViewController.m
//  Popinae
//
//  Created by Sohaib Muhammad on 24/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import "MapViewController.h"
#import "MealFeed.h"
#import "RestaurantFeed.h"

@interface MapViewController ()<MKMapViewDelegate>
{
    CLLocationCoordinate2D coordinate;
    MealFeed *mealsFeed;
    RestaurantFeed *restaurantFeed;

    NSString *pinTitle;
    
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;



@end

@implementation MapViewController

- (void)setCoordinate:(Meal *)meal {
    coordinate.latitude = [meal.storeLat doubleValue];
    coordinate.longitude = [meal.storeLng doubleValue];
    pinTitle=nil;
    pinTitle= meal.mealTitle;
}

- (void)setCoordinateRestaurant:(Restaurant *)restaurant {
    coordinate.latitude = [restaurant.storeLat doubleValue];
    coordinate.longitude = [restaurant.storeLng doubleValue];
    pinTitle=nil;
    pinTitle= restaurant.storeName;
}


- (void)addPinsOnMap {
  
    
    for(int i=0; i<mealsFeed.mealFeed.count; i++)
    {
        Meal *meal=[mealsFeed.mealFeed objectAtIndex:i];
        [self setCoordinate:meal];
        
        [self addPinToMap];
    }
}

- (void)addPinToMap {
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = pinTitle;
   // point.subtitle = @"Is here!!!";
    
    [self.mapView addAnnotation:point];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    NSLog(@"Tab bar controller selected index = %lu",(unsigned long)self.tabBarController.selectedIndex);
    
    
    
    if (_isThisControllerOpenFromOtherController) {
       
        mealsFeed=[MealFeed sharedMealFeed];
        [self.mapView setRegion:[mealsFeed calculateRegion] animated:YES];
        [self setCoordinate:_meal];
        
       // MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
        //[self.mapView setRegion:[mealFeed calculateRegion]animated:YES];
        
        [self addPinToMap];
        
    }else if (_isThisControllerOpenFromRestaurant)
    {
        restaurantFeed=[RestaurantFeed sharedRestaurantFeed];
        [self.mapView setRegion:[restaurantFeed calculateRegion] animated:YES];
        [self setCoordinateRestaurant:_restaurant];
        [self addPinToMap];
    }
    
    else{
        mealsFeed=[MealFeed sharedMealFeed];
        [self.mapView setRegion:[mealsFeed calculateRegion] animated:YES];
        [self addPinsOnMap];
      //  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 2800, 2800);
      //  [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];

        
    }
    
   // [self zoomToFitMapAnnotations:self.mapView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark MKMapViewDelegate Methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1800, 1800);
    //[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}

/*- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString *identifier = @"TaggedLocation";
    
    MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
        annotationView.annotation = annotation;
    }
     //   [annotationView setPinColor:MKPinAnnotationColorGreen];
    
    
   //     annotationView.animatesDrop = YES;
   // annotationView.image = [UIImage imageNamed:@"pin.png"];
    [annotationView setEnabled:YES];
    [annotationView setCanShowCallout:YES];
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}*/



-(void)zoomToFitMapAnnotations:(MKMapView*)aMapView
{
    if([aMapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(MKPointAnnotation *annotation in _mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [aMapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}




@end
