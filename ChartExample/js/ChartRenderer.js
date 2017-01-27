// ChartRenderer.js
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

var HCGlobals = {};
HCGlobals.charts = [];

// Renders a chart using HighCharts in specified container. Also used to redraw a chart.
// renderContainer: Container in which to render the chart
// options : HighCharts charting options (as defined by HighCharts)
// seriesData: HighCharts series data (as defined by HighCharts)
// enableElementTap: Flag to allow/disallow selection of a chart entry
// enableFunctionDrillup: Flag to show/hide button for drill

// Extend this template per your needs (Refer to Highcharts.com for template specification)
function renderChart(renderContainer, options, seriesData, enableElementTap, enableFunctionDrillup) {
    
    console.log("seriesData" + seriesData);
    var c = "container";
    var c1 = "#" + renderContainer;
    
    console.log(c1);
    var chart = $(c1).highcharts();
    
    console.log(chart);
    var callback;
    if (enableElementTap == true) {
        console.log("enableElementTap");
        // Define a callback function that invokes the native app through the WebKit messaging interface
        // This is called when element is tapped in chart
        callback = function() {
            var stringifiedChart = this.series.chart.toString();
            window.webkit.messageHandlers.elementTapped.postMessage({
                                                                    'container': renderContainer,
                                                                    'x': event.point.x,
                                                                    'y': event.point.y,
                                                                    'key': this.series.data[event.point.x].name
                                                                    });
            console.log("clicked" + event.point.x + " " + event.point.y);
        }
        
    }
    
    // Check if we are redrawing th chart or rendering it for the very first time
    if (chart === undefined) {
        console.log("First time chart creation with container" + renderContainer);
        // Create chart with template
        var chart = new Highcharts.Chart({
                                         chart: {
                                             plotBackgroundColor: null,
                                             plotBorderWidth: null,
                                             plotShadow: false,
                                             renderTo: renderContainer,
                                             type: options.type
                                         },
                                         
                                         title: {
                                             text: options.titleText
                                         },
                                         subtitle: {
                                             text: options.subtitleText
                                         },
                                         tooltip: {
                                             pointFormat: options.toolTipFormat
                                         },
                                         xAxis: {
                                             categories: options.xCategories,
                                             labels: {
                                                 rotation: -60,
                                             style: {
                                                 fontSize: '20px',
                                                 fontFamily: 'Verdana, sans-serif'
                                                }
                                            },
                                            title: {
                                                text: options.xAxisTitle
                                            }
                                         },
                                         yAxis: {
                                            title: {
                                                text: options.yAxisTitle
                                            },
                                            labels: {
                                         
                                              format: options.ylabelFormat
                                            }
                                         },
                                         // Add more plotOptions for other chart types
                                         plotOptions: {
                                             pie: {
                                                 allowPointSelect: true,
                                                 cursor: 'pointer',
                                                 dataLabels: {
                                                 enabled: true,
                                                 format: options.dataLabelFormat,
                                                 
                                                },
                                                showInLegend: true
                                            },
                                            column: {
                                                 allowPointSelect: true,
                                                 cursor: 'pointer',
                                                 dataLabels: {
                                                 enabled: true,
                                                 rotation: -90,
                                                 color: '#FFFFFF',
                                                 align: 'right',
                                                 y: 1, // 1 pixels down from the top
                                                 format: options.dataLabelFormat,
                                         
                                             }
                                            }
                                         
                                         },
                                         
                                         series: [{
                                                  colorByPoint: true,
                                                  point: {
                                                    events: {
                                                        click: callback
                                                    }
                                                },
                                            data: seriesData
                                         }],
                                         // Handle drilldown in the native app layer
                                         drilldown: {
                                            series: []
                                         }
                                         
                                         });
        HCGlobals.charts.push({
                                 renderContainer,
                                 chart
                                 });
    } else {
        // You could put drilldown data in the chart template itself. However, we are redrawing chart
        
        console.log("chart re-rendering" + options.titleText);
        chart.setTitle({
                       text: options.titleText
                       }, {
                       text: options.subtitleText
                       }, true);
        
        console.log (chart.xAxis)
        console.log (chart.yAxis)
        
        chart.update({
                     xAxis: {
                        categories: options.xCategories,
                        labels: {
                            rotation: -60,
                            style: {
                                fontSize: '20px',
                                fontFamily: 'Verdana, sans-serif'
                            }
                        },
                        title: {
                            text: options.xAxisTitle
                        }
                     },
                     yAxis: {
                        title: {
                            text: options.yAxisTitle
                        },
                        labels: {
                     
                            format: options.ylabelFormat
                        }
                        }
                     }
                     , false);

        var options = {
            'data': seriesData,
            'type': options.type,
            'name': options.xAxisTitle
        };
        
        
        var max = chart.series.length;
        for (var i = 0; i < max; i++) {
            chart.series[0].remove(false);
        }
        
       
        if (enableFunctionDrillup ) {
            // Show drillup button only if one is not already displayed
            if ( $('#drillupButtonID').length <= 0) {
            
                normalState = new Object();
                normalState.stroke_width = null;
                normalState.stroke = null;
                normalState.fill = null;
                normalState.padding = null;
                normalState.r = null;
                
                hoverState = new Object();
                hoverState = normalState;
                hoverState.fill = 'red';
                
                pressedState = new Object();
                pressedState = normalState;
                
                // Whenever button is tapped, notify the native app via  drillUp message
                var custombutton = chart.renderer.button('Go Back', 74, 40, function() {
                                                         window.webkit.messageHandlers.drillUp.postMessage({
                                                                                                           'container': renderContainer
                                                                                                           });
                                                         }, null, hoverState, pressedState).attr({
                                                                                                 id: 'drillupButtonID'
                                                                                                 }).add();
            }
        } else {
            // High Drill up button
            $('#drillupButtonID').remove();
        }
        
        // redraw chart
        chart.addSeries({
                        type: options.type,
                        data: options.data,
                        name: options.name,
                        colorByPoint: true,
                        point: {
                            events: {
                                click: callback
                            }
                        },
                        
                        }, false);
        
        chart.redraw();
    }
    
    
    
};
