//
//  LastVCs+CoreDataProperties.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/14/25.
//
//

import Foundation
import CoreData


extension LastVCs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastVCs> {
        return NSFetchRequest<LastVCs>(entityName: "LastVCs")
    }

    @NSManaged public var vcs: [String]?

}

extension LastVCs : Identifiable {

}
