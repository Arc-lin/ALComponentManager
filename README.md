# ALComponentManager

当我们的组件化工程越来越大的时候，组件越来越多，AppDelegate的代码量也会越来越多，所以我们需要一个方法去管理AppDelegate里面的组件注册等其他相关工作

## Cocoapods安装

ALComponentManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ALComponentManager'
```

## 使用方法

相关内容可以阅读[文档](https://blog.arclin.cn/post/7e5c9fa9.html)

接下来举例说明

1. AppDelegate继承自`ALAppDelegate`，然后相关的代理方法里面在第一行调用super方法.

2. 在AppDelegate做分发埋点，
	
	如`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`
	
	埋点如下
	
	```
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		[[ALComponentManager sharedManager] triggerEvent:ALSetupEvent];
		[[ALComponentManager sharedManager] triggerEvent:ALInitEvent];

		dispatch_async(dispatch_get_main_queue(), ^{
			[[ALComponentManager sharedManager] triggerEvent:ALSplashEvent];
		});
		
		return YES;
	}

	```
	
	其他埋点见组件Demo
	
3. 给每个组件创建一个类并写上注解，如`ALComponentA.m`

	```
	@ALMod(ALComponentA);
	@interface ALComponentA()<ALComponentProtocol>

	@end

	@implementation ALComponentA

	@end
	```
	
4. 实现协议`ALComponentProtocol`和需要的协议方法。
	这个协议里面蕴含了基本所有的`AppDelegate`方法，当然要触发这些方法都是要预先在AppDelegate写上埋点。
	
	```
	@implementation ALComponentA

	+ (void)load
	{
		NSLog(@"Component A Load");    
	}

	- (instancetype)init
	{
		if (self = [super init]) {
			NSLog(@"ComponentA Init");
		}
		return self;
	}

	- (void)modSetUp:(ALContext *)context
	{
		NSLog(@"ComponentA setup");
	}

	@end
	```
	
4. 接下来你就可以尝试使用了。


## Author

arclin325@gmail.com

## License

ALComponentManager is available under the MIT license. See the LICENSE file for more info.
