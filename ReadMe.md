# SwiftUI + Combine Weather

Showing Weather forecast using SwiftUI + Combine.framework.

Select a area, and show daily forecasts, using [OpenWeather API](https://openweathermap.org/api)

<p align="center">
<img src="./img/img.png" width="480">
</p>

## Highlight of this app

* SwiftUI.framework
* Combine.framework
  * used in network-access and state - manegemnt
* Clean Architecture
  * View - ViewModel - Repository
* NetworkImageView
* MKMapView with CoreLocation
  * GPS with Combine.framework
  * detect tap and add pin at tap position
* Sample implementation of `MainThreadScheduler`
  * but, this won't work with delay-call.

## how to run

* Install Xcode11.0 beta
  * you need not install MacBeta (but you can't use preview)
* sign in [OpenWeather](https://openweathermap.org/) and create API-Key.
* Write your API-Key in `Constants.swift`
* Run!

If you don't want to create OpenWeather account, you can use local-stored-json instead.

* open `WeatherRepository.swift`
* in `WeatherRepositoryImpl.fetcfetch5DayForecast`, switch to use `resourceRequest`.

> city_list.json from Openweather is too big (20MB!).
> So I shrinked it. Please check city_json/.

## file structure

+ /
  +- Constants.swift : API-key.Please set your own key
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

* Dark-mode adaption
  * Colors from asset don't work when using `.colorScheme(.dark)`
  * But it will work when after switching simulater setting, only once.
* MainThreadScheduler won't work with delay-time
  * when I call action() an `DispatchQueue.main.async`, nothing happens.
