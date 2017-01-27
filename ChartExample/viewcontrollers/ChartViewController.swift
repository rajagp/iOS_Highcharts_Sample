//
//  ChartViewController.swift
//
//  Copyright © 2017 Lunaria Software LLC.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import WebKit



class ChartViewController: UIViewController {

    enum ChartEvents:String {
        case elementTapped = "elementTapped"
        case drillUp = "drillUp"
    }
    static let numCharts = 3
    fileprivate static let chartContainer = "container" // must match the div id of container in index.html
    fileprivate var currChartIndex = 0
    fileprivate var selectedElementsBreadCrumbs: [Int] = []
    
    var webView:WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupWebView()
        loadContainerPage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}

// MARK:
extension ChartViewController {
    
    fileprivate func setupWebView() {
        let webConfig = self.webConfiguration()
        webView = WKWebView.init(frame: self.view.frame, configuration: webConfig)
        
        webView?.navigationDelegate = self
        webView?.backgroundColor = UIColor.blue
        self.view.addSubview(webView!)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        setupWebViewConstraints()

    }
    
    fileprivate func setupWebViewConstraints() {
        
        let left = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.webView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0)
   
        let right = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.webView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0)
   
        let top = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.webView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
   
        let bottom = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.webView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
   
        
        self.view.addConstraints([left,right,top,bottom])
    }
    
    fileprivate func webConfiguration() -> WKWebViewConfiguration {
        // Create WKWebViewConfiguration instance
        let webConfig = WKWebViewConfiguration.init()
        
        // Setup WKUserContentController instance for injecting user script
        let userController = WKUserContentController.init()
        
        // Add a script message handler for receiving  "buttonClicked" event notifications posted from the JS document using window.webkit.messageHandlers.buttonClicked.postMessage script message
        self.addJSMessageHandlersInUserController(userController)
        
        
        // Get theme script that's to be injected into the document
        self.loadThemeScriptInUserController(userController)
        
        // Load charting script
        self.loadChartScriptInUserController(userController)
        
        // Setup the webconfig
        webConfig.userContentController = userController;
        
        return webConfig
        
    }
    
    
    fileprivate func addJSMessageHandlersInUserController(_ userController:WKUserContentController) {
        print(#function)
        userController.add(self,name:ChartEvents.elementTapped.rawValue)
        
        userController.add(self, name:ChartEvents.drillUp.rawValue)
    }
    
    fileprivate func loadThemeScriptInUserController(_ userController:WKUserContentController) {
        // Get theme script that's to be injected into the document
        print(#function)
        let filePath = Bundle(for: ChartViewController.self).path(forResource: "dark-blue", ofType: "js")
        
        guard filePath != nil else {return }
        
        do {
            let themeJS = try String.init(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
           
            // Specify when and where and what user script needs to be injected into the web document
            let themeScript = WKUserScript.init(source: themeJS, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
            
            // Add the user script to the WKUserContentController instance
            userController.addUserScript(themeScript)
        } catch {
            print("Failed to load theme into the JS")
        }
    }

    fileprivate func loadChartScriptInUserController(_ userController:WKUserContentController) {
        // Get chart rendering script that's to be injected into the document
        print(#function)
        let filePath = Bundle(for: ChartViewController.self).path(forResource: "ChartRenderer", ofType: "js")
        
        guard filePath != nil else {return }
        
        do {
            let chartJS = try String.init(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
            
            // Specify when and where and what user script needs to be injected into the web document
            let chartScript = WKUserScript.init(source: chartJS, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
            
            // Add the user script to the WKUserContentController instance
            userController.addUserScript(chartScript)
        } catch {
            print("Failed to load chart into the JS")
        }

    }
    
    fileprivate func loadContainerPage() {
        print(#function)
        // Loads the index.html that is the base page for loading the chart
        guard let filePath = Bundle(for: ChartViewController.self).path(forResource: "index", ofType: "html") else {
            print("Could not locate index.html")
            return
        }
        do {
            
            let currFrame = self.view.frame;
            
            let content =  try String(contentsOfFile:filePath)
            
            let formattedContent = String.init(format: content,currFrame.size.width,currFrame.size.height)
            
            let _ = self.webView?.loadHTMLString(formattedContent, baseURL: URL.init(fileURLWithPath: Bundle(for: ChartViewController.self).bundlePath))
        }
        catch {
            print("Failed to load contents of index.html")
        }
    }
    
    fileprivate func loadChartAtIndex(_ indexOfNewChart:Int,indexOfElementSelectedInPrevChart:Int,indexOfElementSelectedInCurrChart:Int) {
        do {
            
            // jugglery to parse the sample data. This  depends on the way your data is structured
            var chartData:Data = Data()
            if (indexOfNewChart > 0 ) {
                if let jsonData = Chart.data(indexOfNewChart,indexOfElementSelectedInPrevChart).value as? [[Any]] {
                   
                    let jsonDataAtSelectedIndex = jsonData[indexOfElementSelectedInCurrChart]
                
                    chartData = try JSONSerialization.data(withJSONObject:  jsonDataAtSelectedIndex as Any, options: .prettyPrinted)
                }
                
            }
            else {
                // first chart is a special case. The chart data is structured differently
                chartData = try JSONSerialization.data(withJSONObject:  Chart.data(indexOfNewChart,-1).value as Any, options: .prettyPrinted)
            }
            
            
            let optionsData = try JSONSerialization.data(withJSONObject:  Chart.options(indexOfNewChart).value as Any, options: .prettyPrinted)
            
            let chartDataStr = String.init(data: chartData, encoding: String.Encoding.utf8)!
            let optionDatStr =  String.init(data: optionsData, encoding: String.Encoding.utf8)!
            let showDrillUp =  indexOfNewChart == 0 ? "false" :"true" // Disable Drill up option if displaying very first chart
            let enableElementSelection = "true"
            
            // Construct JS to invoke chart rendering function
            let js = "renderChart('\(ChartViewController.chartContainer)',\(optionDatStr),\(chartDataStr),\(enableElementSelection),\(showDrillUp))"
            
            print(js)
            self.webView?.evaluateJavaScript(js, completionHandler:{ error in
                print(error)
            })
            
          
        }
        catch {
            print("Could not load contents of chart")
            
        }
        
    }
    
   
    
}

// MARK: WKScriptMessageHandler
extension ChartViewController:WKScriptMessageHandler {
    // event handlers to handle webkit events fired from JS
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch  message.name {
            case ChartEvents.elementTapped.rawValue:
            if currChartIndex == ChartViewController.numCharts - 1 {
                return
            }
            // Nothing technically preventing supporting drill downs multiple levels deep. 
            // But the sample chart enum data structured to only handle two levels of selection
            // Also, all logic here will depend on how your data is structured. 
            // The key point to note is the ability to call the JS function with relevent chart data
            if let selectedElement = message.body as? Dictionary<String,Any>, let selectedIndex = selectedElement["x"] as? Int{
                
                var indexOfElementSelectedInPreviousChart = -1
                var indexOfElementSelectedInCurrentChart = -1
                switch selectedElementsBreadCrumbs.count {
                case 1:
                     // Chart at index 1 is in display. So get the chart data entry corresponding to the selected element
                    indexOfElementSelectedInPreviousChart = selectedElementsBreadCrumbs[currChartIndex-1]
                    indexOfElementSelectedInCurrentChart = selectedIndex
                case 0:
                    // Chart at index 0 is in display. So get the chart data entry corresponding to the selected element
                    indexOfElementSelectedInPreviousChart = selectedIndex
                    indexOfElementSelectedInCurrentChart = 0
                default:
                    print("Unsupported. We only support drill downs two levels deep")
                }
                currChartIndex = currChartIndex + 1 // This is essentially the new chart to be displayed
                selectedElementsBreadCrumbs.append(selectedIndex) // used for drillup /drilldown
                

                self.loadChartAtIndex(currChartIndex,indexOfElementSelectedInPrevChart:indexOfElementSelectedInPreviousChart,indexOfElementSelectedInCurrChart:indexOfElementSelectedInCurrentChart)
            }
        case ChartEvents.drillUp.rawValue:
            if currChartIndex == 0 {
                return
            }
            
            // All logic here will depend on how your data is structured.
            // The key point to note is the ability to call the JS function with relevent chart data for rendering
            var indexOfElementSelectedInPreviousChart = -1
            var indexOfElementSelectedInCurrentChart = -1
            switch selectedElementsBreadCrumbs.count {
                case 2:
                // Chart at index 2 is in display. So get the chart data entry corresponding to the elemnt selected in parent chart
                indexOfElementSelectedInPreviousChart = selectedElementsBreadCrumbs[currChartIndex - 2]
                indexOfElementSelectedInCurrentChart = 0
                case 1:
                    // Chart at index 1 is in display.
                    indexOfElementSelectedInPreviousChart = 0
                    indexOfElementSelectedInCurrentChart = 0
              
                default:
                    print("Unsupported. We only support drill downs two levels deep")
            }
            
            
            currChartIndex = currChartIndex - 1
            selectedElementsBreadCrumbs.remove(at: currChartIndex)
                
             self.loadChartAtIndex(currChartIndex,indexOfElementSelectedInPrevChart:indexOfElementSelectedInPreviousChart,indexOfElementSelectedInCurrChart:indexOfElementSelectedInCurrentChart)
            
            
        default:
            print("Unrecognized message from webviewer")
            
        }
        
            
    }

    
}

// MARK:WKNavigationDelegate
extension ChartViewController:WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         self.loadChartAtIndex(currChartIndex,indexOfElementSelectedInPrevChart:-1,indexOfElementSelectedInCurrChart:0)
    }
}
