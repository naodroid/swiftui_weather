# SwiftUI + Async Weather

Showing Weather forecast using SwiftUI + Async.

Select a area, and show daily forecasts, using [OpenWeather API](https://openweathermap.org/api)

<p align="center">
<img src="./img/capture.gif" width="240">
</p>

## Highlight of this app

* SwiftUI.framework
* **Async/Await**
  * used in network access
* Using `LocationButton / AsyncImage`, which are new APIs in iOS 15.
* Clean Architecture
  * View - ViewModel - Repository
* MKMapView with CoreLocation
  * GPS with async/await
  * detect tap and add pin at tap position
* Adapt dark mode with asset-catalog-colors
* Use `WeatherKit` in iOS16

## how to run

* Install Xcode13.0 beta
* Build and Run

By default, this app will access local-json file.  
If you want to use network-api, please do as following

* sign in [OpenWeather](https://openweathermap.org/) and create Api Key
* rename `Config-sample.plist` to `Config.plist`
* Write your Api Key in `Constants.plist`

> city_list.json from Openweather is too big (20MB!).
> So I shrinked it. Please check city_json/


### WeatherKit

To run iOS16 devices, you need to set up your project as follows.

https://developer.apple.com/documentation/weatherkit/fetching_weather_forecasts_with_weatherkit

If you don't want to use WeatherKit, please change the WeatherRepository instance in `Weather5DayFragment` class.

## file structure

+ /  
  +- Config-sample.plist : config base file. rename and set your key
  +- RootView.swift : view at app-launching  
  +- Theme.swift : Color list  
  +- asset/ : cities and sample json  
  +- Entity/  
  +- Network/  
  +- PartsView/  : common views  
  +- Repository/  
  +- Utils/  
  +- View  
  += ViewModel  

## app structure

* Use Clean Architecture,
* avoid using `@State` in view.(except TextField, it requires state)
* use ViewModel for view state management. 
* use Repository for fetching data

Basic Structure

> Fragment - View - ViewModel - Repository

* Fragment
  * create ViewModel and put it to the environment.
  * create View with ViewModel
  * manage lifecycle-related-operation
* View
  * render view, created by Fragment
  * bind with `ViewModel` and call its functions.
* ViewModel
  * Manage View-State
  * `BindableObject`
* Repostiroy
  * Fetch data

## thanks

* [OpenWeather](https://openweathermap.org/)
* Many repositories using SwiftUI and authors.

## Known issues

* `Task.sleep` crashed, so I created a method insted.
* Need to write cancllation code in ViewModels.