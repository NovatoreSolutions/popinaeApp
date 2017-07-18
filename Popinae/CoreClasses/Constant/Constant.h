//
//  Constant.h
//  Popinae
//
//  Created by Sohaib Muhammad on 22/01/2015.
//  Copyright (c) 2015 iDevNerds. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPHONE      [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPAD        [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad


#if DEBUG
#define BASE_URL   @"http://api.popinae.com/v1/"
#else
#define BASE_URL   @"http://api.popinae.com/v1/"
#endif


extern NSString* const kMealsNearby;
extern NSString* const kRestaurants;

extern NSString* const kLoginURL;
extern NSString* const kSignupURL;

extern NSString* const kViewCartURL;
extern NSString* const kUpdateCartURL;

extern NSString* const kPlaceOrderURL;
extern NSString* const kPlacedOrdersListURL;
extern NSString* const kPlacedOrderDetailURL;

extern NSString* const kMealsList;



    // Test purpose

#define APP_THEME [UIColor colorWithRed:100.0f/255.0f green:57.0f/255.0f blue:0.0f/255.0f alpha:1.0f]

#define BAR_TINT_COLOR              [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1.0f]

#define DETAIL_MIDDLE_BAR_COLOR              [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:245.0f/255.0f alpha:1.0f]
#define DETAIL_ORDER_BTN_COLOR              [UIColor colorWithRed:155.0f/255.0f green:210.0f/255.0f blue:60.0f/255.0f alpha:1.0f]

#define DETAIL_SEPARATOR_COLOR              [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:203.0f/255.0f alpha:1.0f]

#define TAB_BAR_ITEM_ACTIVE         @{NSForegroundColorAttributeName:[UIColor colorWithRed:100.0f/255.0f green:57.0f/255.0f blue:0.0f/255.0f alpha:1.0f], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:10.0f]}

#define TAB_BAR_ITEM_INACTIVE       @{NSForegroundColorAttributeName:[UIColor colorWithRed:132.0f/255.0f green:132.0f/255.0f blue:132.0f/255.0f alpha:1.0f], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:10.0f]}

// Cart View Controller Colors

#define CART_VC_MAIN_VIEW_BGCOLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define CART_VC_TABLE_VIEW_HEADER_BGCOLOR [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]
#define CART_VC_TABLE_VIEW_CELL_BGCOLOR [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:245.0f/255.0f alpha:1.0f]
#define CART_VC_PICKER_VIEW_BGCOLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define CART_VC_CANCEL_BUTTON_BGCOLOR [UIColor colorWithRed:178.0f/255.0f green:35.0f/255.0f blue:33.0f/255.0f alpha:1.0f]
#define CART_VC_ORDER_BUTTON_BGCOLOR [UIColor colorWithRed:155.0f/255.0f green:210.0f/255.0f blue:60.0f/255.0f alpha:1.0f]


// Orders View Controller Colors

#define ORDERS_VC_TABLE_VIEW_HEADER_SEPARATOR_COLOR [UIColor colorWithRed:217.0f/255.0f green:217.0f/255.0f blue:216.0f/255.0f alpha:1.0f]
#define ORDERS_VC_TABLE_VIEW_HEADER_UPPER_SUBVIEW_BGCOLOR [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]
#define ORDERS_VC_TABLE_VIEW_HEADER_BOTTOM_SUBVIEW_BGCOLOR [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:245.0f/255.0f alpha:1.0f]
#define ORDERS_VC_TABLE_VIEW_HEADER_LABEL_STATUS_DETAILS_TEXTCOLOR [UIColor colorWithRed:178.0f/255.0f green:34.0f/255.0f blue:5.0f/255.0f alpha:1.0f]

#define ORDERS_VC_TABLE_VIEW_FOOTER_SEPARATOR_COLOR [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:212.0f/255.0f alpha:1.0f]
#define ORDERS_VC_TABLE_VIEW_FOOTER_BGCOLOR [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:245.0f/255.0f alpha:1.0f]

#define ORDERS_VC_TABLE_VIEW_CELL_BGCOLOR [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:245.0f/255.0f alpha:1.0f]


// Login View Controller Colors

#define LOGIN_VC_BGCOLOR [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]

// Registration View Controller Colors

#define REGISTRATION_VC_BGCOLOR [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]

/*******************
 * App Color Codes *
 *******************/


#define NAV_BAR_COLOR @"#F8F8F8"//@"#ADC146"
#define NAV_BAR_TEXT_COLOR @"#EBEBEB"
#define NAV_BAR_TINT_COLOR @"#000000"


#define LOGIN_TEXT_COLOR @"#000000"
#define LOGIN_TEXT_COLOR2 @"#4A4A4A"


#define APP_BACKGROUND_COLOR @"#32689B"
#define APP_TEXT_COLOR @"#C6E1FF"
#define APP_SEPARATOR_COLOR @"#A2BAD1"
#define APP_SEPARATOR_HEIGHT 0.5f
#define HOSTS_CELL_BACKGROUND_COLOR @"#2A3B54"
#define MAIN_CONTAINER_VIEW_BORDER_COLOR @"#000000"


#define TAB_BAR_COLOR @"#18334D" // with alpha 0.9
#define TAB_BAR_TEXT_COLOR @"#6A7B8B"
#define ERROR_SINGLETON @"THERE CAN ONLY BE ONE INSTANCE"




// General Keys

#define kMessage            @"message"
#define kStatus             @"status"
#define kData               @"data"
#define kRecords               @"records"
#define kTotalCount               @"totalCount"
#define kTotalPages               @"totalPages"
#define kPreviousPageURL               @"prevUrl"
#define kNextPageURL               @"nextUrl"



#define kMealId             @"mealId"
#define kMealDescription    @"mealDescription"
#define kMealPrice          @"mealPrice"
#define kMealTitle          @"mealTitle"
#define kMealImage          @"mealImage"
#define kMealFamilyId       @"mealFamilyId"
#define kMealFamilyName     @"mealFamilyName"
#define kMealCurrencyCode   @"currencyCode"
#define kMealCurrencyID     @"currencyID"
#define kMealCurrencySymbol @"currencySymbol"
#define kMealCurrencyTitle  @"currencyTitle"
#define kMealQuantity       @"quantity"
#define kMealStoreId        @"storeId"
#define kMealStoreName      @"storeName"
#define kMealStoreLat       @"storeLat"
#define kMealStoreLng       @"storeLng"
#define kMealDistance       @"distance"

#define kToken              @"token" // may be redundant

    //Restaurants

#define kcompanyId  @"companyId"
#define kstoreName  @"storeName"
#define kstoreAddress  @"storeAddress"
#define kstoreLocation  @"storeLocation"
#define kstorePostalCode  @"storePostalCode"
#define kstoreCity  @"storeCity"
#define kstoreState  @"storeState"
#define kstoreCountry  @"storeCountry"
#define kstoreLat  @"storeLat"
#define kstoreLng  @"storeLng"
#define kcurrencyId  @"currencyId"
#define kstorePhone  @"storePhone"
#define kstoreImage  @"storeImage"

// constants For User

#define USER_ERROR_SINGLETON   @"THERE CAN ONLY BE ONE USER INSTANCE"
#define USER_DEFAULTS_KEY      @"user"

#define kUserID       @"clientId"
#define kUserName     @"clientName"
#define kUserToken    @"token"
#define kUserEmail    @"clientEmail"
#define kUserPhone    @"clientPhone"
#define kUserPassword @"clientPassword"

#define kUserLoginTimeStamp @"loginTimeStamp"

#define kUserLoginKey          @"login"
#define kUserPasswordKey       @"password"
#define kUserTokenDurationKey  @"tokenDuration"

#define kUserSignupNameKey     @"name"
#define kUserSignupEmailKey    @"email"
#define kUserSignupPhoneKey    @"phone"
#define kUserSignupPasswordKey @"password"

// constants for Cart

#define kCartTokenParam    @"token"
#define kCartMealIDParam   @"mealId"
#define kCartQuantityParam @"quantity"

// url parameters nearby

#define klat @"lat"
#define klng @"lng"
#define kradius @"radius"
#define kkeyword @"keyword"
#define kpageNo @"pageNo"
#define krecordsNo @"recordsNo"

    //url parameters restaurants

#define kstoreId @"storeId"
#define ksortBy @"sortBy"
#define ksortOrder @"sortOrder"
#define kLanguage @"lang"


// constants for PlacedOrder

#define kPlacedOrderId             @"orderId"
#define kPlacedOrderClientId       @"clientId"
#define kPlacedOrderStoreId        @"storeId"
#define kPlacedOrderDate           @"orderDate"
#define kPlacedOrderIsPending      @"isPending"
#define kPlacedOrderIsPaid         @"isPaid"
#define kPlacedOrderScheduleDate   @"scheduleDate"
#define kPlacedOrderDeliveryDate   @"deliveryDate"
#define kPlacedOrderTotalPrice     @"totalPrice"
#define kPlacedOrderComments       @"comments"
#define kPlacedOrderStatusId       @"orderStatusId"
#define kPlacedOrderStoreName      @"storeName"
#define kPlacedOrderCurrencyId     @"currencyId"
#define kPlacedOrderCurrencyCode   @"currencyCode"
#define kPlacedOrderCurrencyTitle  @"currencyTitle"
#define kPlacedOrderCurrencySymbol @"currencySymbol"
#define kPlacedOrderClientName     @"clientName"
#define kPlacedOrderStatusTitle    @"orderStatusTitle"

#define kPlacedOrderMeals          @"meals"

#define kPlacedOrderTokenParam @"token"
#define kPlacedOrderRecordsKey @"records"

















