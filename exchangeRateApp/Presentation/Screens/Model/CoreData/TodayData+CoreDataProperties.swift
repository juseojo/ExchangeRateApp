//
//  TodayData+CoreDataProperties.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/12/25.
//
//

import Foundation
import CoreData


extension TodayData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodayData> {
        return NSFetchRequest<TodayData>(entityName: "TodayData")
    }

    @NSManaged public var code: String?
    @NSManaged public var rate: Double

}

extension TodayData : Identifiable {

}
