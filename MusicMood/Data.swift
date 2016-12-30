//
//  Data.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 30/12/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import Foundation


let maxData: Int = 50              // Defines the sample amount of brainwaves


class Data {
    var dataSize = maxData          // This will be referenced outside of the class
    
//    struct Waves {
//        static var alpha = Array(repeating: 0.0, count: maxData)
//        static var beta = Array(repeating: 0.0, count: maxData)
//        static var delta = Array(repeating: 0.0, count: maxData)
//        static var theta = Array(repeating: 0.0, count: maxData)
//        static var gamma = Array(repeating: 0.0, count: maxData)
//    }
//    
//    struct WavesAverage {
//        static var alpha: Double = 0.0
//        static var beta: Double = 0.0
//        static var delta: Double = 0.0
//        static var theta: Double = 0.0
//        static var gamma: Double = 0.0
//    }
    
    static var Waves = ["alpha": Array(repeating: 0.0, count: maxData),
                 "beta": Array(repeating: 0.0, count: maxData),
                 "delta": Array(repeating: 0.0, count: maxData),
                 "theta": Array(repeating: 0.0, count: maxData),
                 "gamma": Array(repeating: 0.0, count: maxData)]
    var WavesAverage = ["alpha": 0.0, "beta": 0.0, "delta": 0.0, "theta": 0.0, "gamma": 0.0]
    
    func determineMood() {
        for (wave, value) in Data.Waves {
            WavesAverage[wave] = value.reduce(0.0) {
                return $0 + $1/Double(value.count)
            }
            print("Average of \(wave): \(WavesAverage[wave]!)")
        }
    

//        switch WavesAverage.self {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
    }
}
