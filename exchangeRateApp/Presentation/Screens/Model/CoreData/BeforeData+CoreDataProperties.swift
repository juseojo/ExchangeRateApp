//
//  BeforeData+CoreDataProperties.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/12/25.
//
//

import Foundation
import CoreData


extension BeforeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BeforeData> {
        return NSFetchRequest<BeforeData>(entityName: "BeforeData")
    }

    @NSManaged public var code: String?
    @NSManaged public var rate: Double

}

extension BeforeData : Identifiable {

}
