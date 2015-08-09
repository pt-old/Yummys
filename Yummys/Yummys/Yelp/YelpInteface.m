//
//  YPAPISample.m
//  YelpAPI

#import "YelpInterface.h"
#import "NSURLRequest+OAuth.h"

/**
 Default paths and search terms used in this example
 */
static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"20";
static NSString * const kRadiusFilter      = @"10000";
static NSString * const kTermFilter        = @"dinner";

@implementation YelpInterface : NSObject 

#pragma mark - Public
- (void)queryBusiness:(NSString *)location completionHandler:(void (^)(NSArray *businesses, NSError *error))completionHandler {
    NSLog(@"Querying the Search API with location \'%@'", location);
    __block NSArray *businesses = [[NSMutableArray alloc] init];
    __block NSInteger offset = 0;
    [self queryBusinessInfoWithLocation:location offset:0 completionHandler:^(NSArray *retrievedBusiness, NSInteger totalBusinesses, NSInteger currentOffset, NSError *error) {
        businesses = [businesses arrayByAddingObjectsFromArray:retrievedBusiness];
        completionHandler(businesses, error);
        offset += 20;
        NSLog(@"currentOffset = %ld, businessCount = %lu, retirevedBusinessCount = %lu", (long)currentOffset, (unsigned long)businesses.count,retrievedBusiness.count);
        while (offset < totalBusinesses) {
            [self queryBusinessInfoWithLocation:location offset:offset completionHandler:^(NSArray *retrievedBusiness, NSInteger totalBusinesses, NSInteger currentOffset, NSError *error) {
                businesses = [businesses arrayByAddingObjectsFromArray:retrievedBusiness];
                //if (currentOffset + 20 > totalBusinesses) {
                    completionHandler(businesses, error);
                //}
                NSLog(@"currentOffset = %ld, businessCount = %lu, retirevedBusinessCount = %lu", (long)currentOffset, (unsigned long)businesses.count,retrievedBusiness.count);
            }];

            offset +=20;
        }
    }];
}

- (void)queryBusinessInfoWithLocation:(NSString *)location offset:(NSInteger)offset completionHandler:(void (^)(NSArray *businesses, NSInteger totalBusinesses, NSInteger offset, NSError *error))completionHandler {
    
    //Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithLocation:location offset:offset];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            NSString *totalStr = searchResponseJSON[@"total"];
            NSInteger totalBusinesses = totalStr.integerValue;
            //NSLog(@"Result = %@", businessArray);
            if ([businessArray count] > 0) {
                completionHandler(businessArray,totalBusinesses, offset, error);
            } else {
                completionHandler(nil, totalBusinesses, offset, error); // No business was found
            }
        } else {
            completionHandler(nil, 0, 0, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}


- (void)queryBusinessInfoForBusinessId:(NSString *)businessID completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler {

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLRequest *businessInfoRequest = [self _businessInfoRequestForID:businessID];
  [[session dataTaskWithRequest:businessInfoRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (!error && httpResponse.statusCode == 200) {
      NSDictionary *businessResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

      completionHandler(businessResponseJSON, error);
    } else {
      completionHandler(nil, error);
    }
  }] resume];

}


#pragma mark - API Request Builders

/**
 Builds a request to hit the search endpoint with the given parameters.
 
 @param term The term of the search, e.g: dinner
 @param location The location request, e.g: San Francisco, CA

 @return The NSURLRequest needed to perform the search
 */
- (NSURLRequest *)_searchRequestWithLocation:(NSString *)location offset:(NSInteger)offset {
  NSDictionary *params = @{
                           @"term": kTermFilter,
                           @"ll": location,
                           @"radius_filter":kRadiusFilter,
                           @"offset":[NSString stringWithFormat:@"%ld", (long)offset],
                           @"sort":@"0"
                           };

  return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
    //return [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.yelp.com/v2/search?term=Dance&limit=200&offset=50&sort=0&location=San+Francisco"]];
}

/**
 Builds a request to hit the business endpoint with the given business ID.
 
 @param businessID The id of the business for which we request informations

 @return The NSURLRequest needed to query the business info
 */
- (NSURLRequest *)_businessInfoRequestForID:(NSString *)businessID {

  NSString *businessPath = [NSString stringWithFormat:@"%@%@", kBusinessPath, businessID];
  return [NSURLRequest requestWithHost:kAPIHost path:businessPath];
}

@end
