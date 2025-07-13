//
//  Favorites+CoreDataProperties.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/12/25.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var favoriteCode: String?

}

extension Favorites : Identifiable {

}
