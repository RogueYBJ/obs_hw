#import "ObsHwPlugin.h"


@implementation ObsHwPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"obs_hw"
            binaryMessenger:[registrar messenger]];
  ObsHwPlugin* instance = [[ObsHwPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"upImage" isEqualToString:call.method]){
      [self upImage:call.arguments result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void) upImage:(NSDictionary *)dic result:(FlutterResult)result{
    NSString * ak = [dic objectForKey:@"ak"];
    NSString * sk = [dic objectForKey:@"sk"];
    NSString * endPoint = [dic objectForKey:@"endPoint"];
    NSString * bucketName = [dic objectForKey:@"bucketName"];
    NSString * bucketDomain = [dic objectForKey:@"bucketDomain"];
    NSString * key = [dic objectForKey:@"key"];
    NSString * data = [dic objectForKey:@"data"];
    OBSStaticCredentialProvider *credentailProvider = [[OBSStaticCredentialProvider alloc] initWithAccessKey:ak secretKey:sk];
//
    OBSServiceConfiguration *conf = [[OBSServiceConfiguration alloc] initWithURLString:endPoint credentialProvider:credentailProvider];
//
//    // 初始化client
    OBSClient *client = [[OBSClient alloc] initWithConfiguration:conf];
//    NSData* decodedImgData = [[NSData alloc]initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData* decodedImgData = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
    OBSPutObjectWithDataRequest *request = [[OBSPutObjectWithDataRequest alloc]initWithBucketName:bucketName objectKey:key uploadData:decodedImgData];
//    [client putObject:request completionHandler:^(OBSPutObjectResponse *response, NSError *error){
//        NSLog(@"%@",response);
////        result(@"--------");
//    }];
    result(@"--------");
}



@end
