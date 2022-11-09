//
//  DataManager.swift
//  billCalculator
//
//  Created by Ho Wang Leung on 8/11/2022.
//

import Foundation
import CoreData

class DataManager{
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "billCalculator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func restaurant(restaurantName:String) -> Restaurant {
        let restaurant = Restaurant(context: persistentContainer.viewContext)
        restaurant.restaurantName = restaurantName
        return restaurant
    }
    
    func menuItem(name:String, price:NSDecimalNumber, type:String) -> MenuItem {
        let menuItem = MenuItem(context: persistentContainer.viewContext)
        menuItem.name = name
        menuItem.price = price
        menuItem.type = type
        return menuItem
    }
    
    func getRestaurants()->[Restaurant] {
        let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        var fetchedRestaurants:[Restaurant] = []
        
        do{
            fetchedRestaurants = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("ERROR FETCHING RESTAURANT........")
        }
        return fetchedRestaurants
    }
    
    func getMenuItemsByRestaurant(currentRestaurant:Restaurant)->[MenuItem] {
        let request: NSFetchRequest<MenuItem> = MenuItem.fetchRequest()
        request.predicate =  NSPredicate(format: "(restaurant = %@)", currentRestaurant)
        var fetchedMenuItems:[MenuItem] = []
        
        do{
            fetchedMenuItems = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("ERROR FETCHING MenuItemS........")
        }
        return fetchedMenuItems
    }
    

    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
