# Overview
Demonstration of using Highcharts for graph rendering in native iOS app. The app is written in Swift 3.0.2 (requires Xcode 8.2+). Highcharts is a JS based charting engine and the sample app demonstrates the ability to render charts using Highcharts within a WKWebview in a native app. The sample app also demonstrates drill down capabilities.

- About Highcharts : http://www.highcharts.com . 
- The highcharts API : http://api.highcharts.com/highcharts

![](http://www.priyaontech.com/wp-content/uploads/2017/01/highchartdemo.gif)

# Details
The sample app demonstrates the following :-
- Ability to dynamically load chart data / chart options
- Ability to listen to element selection events  
- Multi-level Drilling down / Drilling up 


The app uses a ```WKWebView``` to load the Highchart and uses ```WebKit``` messaging interface for communication between the native iOS app world and JS world. 
 - Details of the WKWebview at https://developer.apple.com/reference/webkit/wkwebview

The native iOS layer sends the chart data / options to the JS charting layer using the ```evaluatejavascipt ``` method. 
 - Details of the method at https://developer.apple.com/reference/webkit/wkwebview/1415017-evaluatejavascript

The native iOS layer listens to drillup/drill down events from the chart using the ```WKScriptMessageHandler``` interface and can redraw the chart with appropriate chart data. 
 - Details of WKScriptMessageHandler at https://developer.apple.com/reference/webkit/wkscriptmessagehandler




#License
MIT License. See LICENSE for details.


