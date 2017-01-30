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
    
    enum Mood: String {
        case undefined
        case happy
        case sad
        case melancholic
        case angry
    }
    
    struct CMV {
        static var currentMoodValue = Mood.undefined.rawValue
    }
    
    
    // This struct determines the mood by the range of brainwave values
    struct WaveRange {
        // Sad mood
        static let alphaRange1000: Range = 0.0..<0.2
        static let betaRange1000: Range = 0.0..<1.0
        static let deltaRange1000: Range = 0.0..<1.0
        static let thetaRange1000: Range = 0.0..<1.0
        static let gammaRange1000: Range = 0.0..<1.0
        
        // Happy mood
        static let alphaRange5000: Range = 0.3..<1.0
        static let betaRange5000: Range = 0.0..<1.0
        static let deltaRange5000: Range = 0.0..<1.0
        static let thetaRange5000: Range = 0.0..<1.0
        static let gammaRange5000: Range = 0.0..<1.0
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
        // Sad mood
        case (WaveRange.alphaRange1000?, WaveRange.betaRange1000?, WaveRange.deltaRange1000?, WaveRange.deltaRange1000?, WaveRange.gammaRange1000?):
            print("Sad mood!")
            CMV.currentMoodValue = Mood.sad.rawValue
            
        // Happy mood
        case (WaveRange.alphaRange5000?, WaveRange.betaRange5000?, WaveRange.deltaRange5000?, WaveRange.deltaRange5000?, WaveRange.gammaRange5000?):
            print("Happy mood!")
            CMV.currentMoodValue = Mood.happy.rawValue
            
        default:
            print("LOL, important!")
        }
    }
}
