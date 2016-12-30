//
//  FutureImplementation.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 30/12/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import Foundation


// TODO: Adapt the code below


class FutureImplementation {
    func daFuture() {
        var checkSizeOfCD: Double = 0.0
        checkSizeOfCD += 1
        // Clean the Core Data, if it exists
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<BrainWaveData> = BrainWaveData.fetchRequest()
        let query: NSFetchRequest<BrainWaveData> = BrainWaveData.fetchRequest()

        do {
        let fetchResults = try viewContext.fetch(request)
        for result: AnyObject in fetchResults {
        let record = result as! NSManagedObject
        viewContext.delete(record)
        }
        try viewContext.save()
        } catch {
        }
        
        // Creating Core Data
        for _ in 0...data.dataSize {
        let data = NSEntityDescription.entity(forEntityName: "BrainWaveData", in: viewContext)
        let newRecord = NSManagedObject(entity: data!, insertInto: viewContext)
        
        
        newRecord.setValue(0.0, forKey: "alpha") //値を代入
        newRecord.setValue(0.0, forKey: "beta") //値を代入
        newRecord.setValue(0.0, forKey: "delta") //値を代入
        newRecord.setValue(0.0, forKey: "theta") //値を代入
        newRecord.setValue(0.0, forKey: "gamma") //値を代入
        
        do {
        try viewContext.save()
        } catch {
        }
        }

        do {
        let fetchResults = try viewContext.fetch(query)
        for result: AnyObject in fetchResults {
        let alpha: Double! = result.value(forKey: "alpha") as? Double
        let beta: Double? = result.value(forKey: "beta") as? Double
        let delta: Double? = result.value(forKey: "delta") as? Double
        let theta: Double? = result.value(forKey: "theta") as? Double
        let gamma: Double? = result.value(forKey: "gamma") as? Double
        
        print("CD Alpha: \(alpha)")
        print("CD Beta: \(beta)")
        print("CD Delta: \(delta)")
        print("CD Theta: \(theta)")
        print("CD Gamma: \(gamma)")
        }
        } catch {
        }
        
        // Declaring values for CoreData
        // For saving
        
        
        let data = NSEntityDescription.entity(forEntityName: "BrainWaveData", in: viewContext)
        let newRecord = NSManagedObject(entity: data!, insertInto: viewContext)


        newRecord.setValue(alpha, forKey: "alpha") //値を代入
        newRecord.setValue(beta, forKey: "beta") //値を代入
        newRecord.setValue(delta, forKey: "delta") //値を代入
        newRecord.setValue(theta, forKey: "theta") //値を代入
        newRecord.setValue(checkSizeOfCD, forKey: "gamma") //値を代入
        
        
        
        do {
            let fetchResults = try viewContext.fetch(request)
            fetchResults[i].setValue(alpha, forKey: "alpha")
            fetchResults[i].setValue(beta, forKey: "beta")
            fetchResults[i].setValue(delta, forKey: "delta")
            fetchResults[i].setValue(theta, forKey: "theta")
            fetchResults[i].setValue(gamma, forKey: "gamma")

            try viewContext.save()
        } catch {
        }
        

        let fetchResults = try viewContext.fetch(request)
        for result: AnyObject in fetchResults {
            let alpha: Double! = result.value(forKey: "alpha") as? Double
            let beta: Double! = result.value(forKey: "beta") as? Double
            let delta: Double! = result.value(forKey: "delta") as? Double
            let theta: Double! = result.value(forKey: "theta") as? Double
            let gamma: Double! = result.value(forKey: "gamma") as? Double

            print("CD ________________________________-   Alpha: \(Double(alpha))")
            print("CD Beta: \(Double(beta))")
            print("CD Delta: \(Double(delta))")
            print("CD Theta: \(Double(theta))")
            print("CD Gamma: \(Double(gamma))")
        }

        
        
        // For reading
        
        // The lines below limit the scanning, but not the input
        query.fetchLimit = 500      // for 50 seconds
        
        
        request.fetchLimit = 500
    }
}


