//
//  BrainWaveData+CoreDataProperties.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 27/12/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import Foundation
import CoreData


extension BrainWaveData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BrainWaveData> {
        return NSFetchRequest<BrainWaveData>(entityName: "BrainWaveData");
    }

    @NSManaged public var alpha: Double
    @NSManaged public var beta: Double
    @NSManaged public var delta: Double
    @NSManaged public var theta: Double
    @NSManaged public var gamma: Double

}
