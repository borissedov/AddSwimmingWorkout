//
//  ViewController.swift
//  AddSwimmingWorkout
//
//  Created by Boris Sedov on 17.12.2019.
//  Copyright © 2019 Sedov Boris. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        healthStore.handleAuthorizationForExtension { (success, error) in
                        
            guard let swimmingStrokeCount = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount) else {
                fatalError("*** Unable to create the distance type ***")
            }
            
            self.healthStore.requestAuthorization(
                toShare: [HKObjectType.workoutType(), swimmingStrokeCount],
                read: [HKObjectType.workoutType(), swimmingStrokeCount],
                completion: { success, error in
                    
                    if success {
                        self.addSwimming()
                        return
                    } else  if let error = error {
                        print(error.localizedDescription)
                    }
                   
                    
            })
        }
    }
    
    
    func addSwimming() {
        let start = Date().addingTimeInterval(-60*30)
        let end = Date()

        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(),
                                      doubleValue: 425.0)

        let distance = HKQuantity(unit: HKUnit.mile(),
                                  doubleValue: 3.2)

        let totalSwimmingStrokeCount = HKQuantity(unit: HKUnit.count(), doubleValue: 60)

        let swimming = HKWorkout(activityType: .swimming, start: start, end: end, workoutEvents: nil, totalEnergyBurned: energyBurned, totalDistance: distance, totalSwimmingStrokeCount: totalSwimmingStrokeCount, device: nil, metadata: nil)


        healthStore.save(swimming) { (success, error) -> Void in
            guard success else {
                fatalError("*** An error occurred while saving the " +
                    "workout: \(error?.localizedDescription ?? "")")
            }

            let strokeCount = HKQuantity(unit: HKUnit.count(),
                                                  doubleValue: 10.0)

            guard let count = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount) else {
                fatalError("*** Unable to create a heart rate type ***")
            }

            let sample0 = HKQuantitySample(
                type: count,
                quantity: strokeCount,
                start: start,
                end: start.addingTimeInterval(60*5),
                device: nil,
                metadata: [
                    "HKSwimmingStrokeStyle": 0 // unknown
            ])
            
            let sample1 = HKQuantitySample(
                type: count,
                quantity: strokeCount,
                start: start.addingTimeInterval(60*5),
                end: start.addingTimeInterval(60*10),
                device: nil,
                metadata: [
                    "HKSwimmingStrokeStyle": 1 // mixed
            ])
            
            let sample2 = HKQuantitySample(
                type: count,
                quantity: strokeCount,
                start: start.addingTimeInterval(60*10),
                end: start.addingTimeInterval(60*15),
                device: nil,
                metadata: [
                    "HKSwimmingStrokeStyle": 2 // freestyle
            ])
            
            let sample3 = HKQuantitySample(
                type: count,
                quantity: strokeCount,
                start: start.addingTimeInterval(60*15),
                end: start.addingTimeInterval(60*20),
                device: nil,
                metadata: [
                    "HKSwimmingStrokeStyle": 3 // backstroke
            ])
            
            let sample4 = HKQuantitySample(
                type: count,
                quantity: strokeCount,
                start: start.addingTimeInterval(60*20),
                end: start.addingTimeInterval(60*25),
                device: nil,
                metadata: [
                    "HKSwimmingStrokeStyle": 4 // breaststroke
            ])
            
            let sample5 = HKQuantitySample(
                type: count,
                quantity: strokeCount,
                start: start.addingTimeInterval(60*25),
                end: start.addingTimeInterval(60*30),
                device: nil,
                metadata: [
                    "HKSwimmingStrokeStyle": 5 // butterfly
            ])
                        

            self.healthStore.add([sample0, sample1, sample2, sample3, sample4, sample5],
                                 to: swimming) { (success, error) -> Void in
                                    guard success else {
                                        fatalError("*** An error occurred while adding a " +
                                            "sample to the workout: \(error?.localizedDescription ?? "")")
                                    }
                                    
                                    print(success)
            }
        }
    }


}

