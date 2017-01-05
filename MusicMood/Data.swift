//
//  Data.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 30/12/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import Foundation


let maxData: Int = 25              // Defines the sample amount of brainwaves


class Data {
    var dataSize = maxData          // This will be referenced outside of the class
    
    let sad = 0.0...0.5
    
    struct WaveRange {
        static let alphaRange1000: Range = 0.0..<0.5
        static let betaRange1000: Range = 0.0..<0.5
        static let deltaRange1000: Range = 0.0..<0.5
        static let thetaRange1000: Range = 0.0..<0.5
        static let gammaRange1000: Range = 0.0..<0.5
    }
    
    static var Waves = ["alpha": Array(repeating: 0.0, count: maxData),
                 "beta": Array(repeating: 0.0, count: maxData),
                 "delta": Array(repeating: 0.0, count: maxData),
                 "theta": Array(repeating: 0.0, count: maxData),
                 "gamma": Array(repeating: 0.0, count: maxData)]
    var WavesAverage: [String: Double] = ["alpha": 0.0, "beta": 0.0, "delta": 0.0, "theta": 0.0, "gamma": 0.0]
    
    func determineMood() {
        for (wave, value) in Data.Waves {
            WavesAverage[wave] = value.reduce(0.0) {
                return $0 + $1/Double(value.count)
            }
            print("Average of \(wave): \(WavesAverage[wave]!)")
        }
    

        print(Array(WavesAverage.values))
        
        // Switching over the values of the headband and determining the mood.
        switch (WavesAverage["alpha"], WavesAverage["beta"], WavesAverage["delta"], WavesAverage["theta"], WavesAverage["gamma"]) {
        case (WaveRange.alphaRange1000?, WaveRange.betaRange1000?, WaveRange.deltaRange1000?, WaveRange.deltaRange1000?, WaveRange.gammaRange1000?):
            print("Basic mood!")
        default:
            print("LOL, important!")
        }
    }
}
