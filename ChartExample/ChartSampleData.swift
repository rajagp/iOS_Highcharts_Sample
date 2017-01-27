//
//  ChartSampleData.swift
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

// Sample chart data . Refer to Highcharts.com for details of format of data
import Foundation

enum Chart {
    // Chart data
    case data (Int, Int)
    // Chart options
    case options (Int)
    
   
    var value:Any? {
        switch (self) {
        case .data (let chartIndex, let indexOfElementSelectedInPrevChart):
            switch (chartIndex, indexOfElementSelectedInPrevChart) {
            case (0,_):
            // For the very first chart, there is no element selection
            let val = [
                
                    ["name":"China","y":1378],
                    ["name":"India","y":1266],
                    ["name":"United States","y":323],
                    ["name":"Indonesia","y":258]
                
            ]
            
            return val
            
            case (1, 0):
                let val = [[
                    [
                        "0-14 years",
                        17.1
                    ],
                    [
                        "15-24 years",
                        13.27
                    ],
                    [
                        "25-54 years",
                        48.42
                    ],
                    [
                        "55-64 years",
                        10.87
                    ],
                    [
                        "> 65 years",
                        10.35
                    ]
                ]]
                return val
               
                case (1, 1):
                    let val = [[
                        [
                            "0-14 years",
                            27.71
                        ],
                        [
                            "15-24 years",
                            17.99
                        ],
                        [
                            "25-54 years",
                            40.91
                        ],
                        [
                            "55-64 years",
                            7.3
                        ],
                        [
                            "> 65 years",
                           6.09
                        ]
                        ]]
                    
                return val
                case (1, 2):
                    let val = [[
                        [
                            "0-14 years",
                            18.84
                        ],
                        [
                            "15-24 years",
                            13.46
                        ],
                        [
                            "25-54 years",
                            39.6
                        ],
                        [
                            "55-64 years",
                            12.85
                        ],
                        [
                            "> 65 years",
                            15.25
                        ]
                        ]]
                    return val
                    
            case (1,3):
                
                let val = [[
                    [
                        "0-14 years",
                        25.42
                    ],
                    [
                        "15-24 years",
                        17.03
                    ],
                    [
                        "25-54 years",
                        42.35
                    ],
                    [
                        "55-64 years",
                        8.4
                    ],
                    [
                        "> 65 years",
                        6.79
                    ]
                    ]]
                    return val
                
            case (2, 0):
                let val = [
                    [
                        [
                            "male",
                            126
                        ],
                        [
                            "female",
                            108
                        ]
                    ],
                    [
                        [
                            "male",
                            97
                        ],
                        [
                            "female",
                            85
                        ]
                    ],
                    [
                        [
                            "male",
                            339
                        ],
                        [
                            "female",
                            325
                        ]
                        
                    ],
                    [
                        [
                            "male",
                            75
                        ],
                        [
                            "female",
                            73
                        ]
                        
                    ],
                    [
                        [
                            "male",
                            67
                        ],
                        [
                            "female",
                            74
                        ]
                        
                    ]
                           
                ]
                return val
                
            case (2, 1):
                let val = [
                    [
                        [
                            "male",
                            186
                        ],
                        [
                            "female",
                            164
                        ]
                    ],
                    [
                        [
                            "male",
                            121
                        ],
                        [
                            "female",
                            106
                        ]
                    ],
                    [
                        [
                            "male",
                            267
                        ],
                        [
                            "female",
                            251
                        ]
                        
                    ],
                    [
                        [
                            "male",
                            46
                        ],
                        [
                            "female",
                            46
                        ]
                        
                    ],
                    [
                        [
                            "male",
                            36
                        ],
                        [
                            "female",
                            40
                        ]
                        
                    ]
                    
                ]
                return val
            case (2, 2):
                let val =   [
                    [
                        [
                            "male",
                            31
                        ],
                        [
                            "female",
                            29
                        ]
                    ],
                    [
                        [
                            "male",
                            22
                        ],
                        [
                            "female",
                            21
                        ]
                    ],
                    [
                        [
                            "male",
                            64
                        ],
                        [
                            "female",
                            64
                        ]
                        
                    ],
                    [
                        [
                            "male",
                            20
                        ],
                        [
                            "female",
                            21
                        ]
                        
                    ],
                    [
                        [
                            "male",
                            21
                        ],
                        [
                            "female",
                            27
                        ]
                        
                    ]
                    
                ]
                return val
                
            case (2,3):
                
                let val =  [
                    [
                        [
                            "male",
                            33
                        ],
                        [
                            "female",
                            32
                        ]
                    ],
                    [
                        [
                            "male",
                            22
                        ],
                        [
                            "female",
                            21
                        ]
                    ],
                    [
                        [
                            "male",
                            55
                        ],
                        [
                            "female",
                            53
                        ]
                        
                    ],
                    [
                        [
                            "male",
                            9
                        ],
                        [
                            "female",
                            11
                        ]
                        
                    ],
                    [
                        [
                            "male",
                            7
                        ],
                        [
                            "female",
                            9
                        ]
                        
                    ]
                    
                ]
                return val
                
            default:
                return nil
            }
        case .options(let index):
            switch (index) {
            case 0:
                
                let val :[String:Any] =
                    [
                        "titleText": "Most Populated Countries in the World (2016)",
                        "dataLabelFormat": " {point.y} ",
                        "type": "column",
                        "yAxisTitle": "Population (in millions) ",
                        "xAxisTitle": "Country ",
                        "xCategories": ["China","India","United States","Indonesia","Brazil"],
                        "ylabelFormat":"{value} mm"
                ]
                return val
             
            case 1:
                let val:[String:Any] = [
                    "titleText": "Population / Age Group",
                    "dataLabelFormat": " {point.y}%",
                    "type": "pie",
                    "yAxisTitle": "%",
                    "xAxisTitle": "Age Group",
                     "ylabelFormat":"{value}%",
                    "xCategories": ["0-14","15-24","25-54","55-64","> 65"]
                ]
                return val
          
            case 2:
                let val:[String:Any] = [
                    "titleText": "Male vs. Female per Age Grounp",
                    "dataLabelFormat": " {point.y:}%",
                    "type": "pie",
                    "yAxisTitle": "%",
                    "xAxisTitle": "Demographics",
                    "ylabelFormat":"{value}%",
                    "xCategories": ["Male","Female"]
                ]
                return val
              
            
            default:
            return nil
            }
        }
    }
}

