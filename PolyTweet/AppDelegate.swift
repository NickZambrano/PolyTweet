//
//  AppDelegate.swift
//  PolyTweet
//
//  Created by Nicolas zambrano on 10/02/2017.
//  Copyright © 2017 Nicolas zambrano. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //deleteAll()
        loadGroupesAndDep()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PolyTweet")
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

    func saveContext () {
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
    func loadGroupesAndDep(){
        let context=persistentContainer.viewContext
        let requestDep : NSFetchRequest<Departement> = Departement.fetchRequest();
        let requestGroup : NSFetchRequest<Group> = Group.fetchRequest();
        
        do{
            let resultDep: [Departement] = try context.fetch(requestDep)
            let resultGroup: [Group] = try context.fetch(requestGroup)
            if(resultGroup.count == 0){
                
                let general = Group(context:context);
                general.name="Général"
                
                let troisA = Group(context:context);
                troisA.name="3ème année"
                let trois = Years(context:context);
                trois.numero=3;
                troisA.annee=trois;
                trois.addToGroups(troisA);
                
                
                let quatreA = Group(context:context);
                quatreA.name="4ème année";
                let quatre = Years(context:context);
                quatre.numero=4;
                quatreA.annee=quatre;
                quatre.addToGroups(quatreA);
                
                
                let cinqA = Group(context:context);
                cinqA.name="5ème année";
                let cinq = Years(context:context);
                cinq.numero=5;
                cinqA.annee=cinq;
                cinq.addToGroups(cinqA);
                do{
                    try context.save();
                }
                catch let error as NSError{
                    print(error);
                }
            }
            if(resultDep.count==0){
                let ig = Departement(context:context);
                ig.name="IG";
                ig.fullName="Informatique et Gestion";
                let mea = Departement(context:context);
                mea.name="MEA";
                mea.fullName="Microélectronique et Automatique";
                let mat = Departement(context:context);
                mat.name="MAT";
                mat.fullName="Matériaux";
                
                let gba = Departement(context:context);
                gba.name="GBA";
                gba.fullName="Génie biologique et Agroalimentaire";
                
                let ste = Departement(context:context);
                ste.name="STE";
                ste.fullName="Sciences et Technologies de l'eau";
                
                let mi = Departement(context:context);
                mi.name="MI";
                mi.fullName="Mécanique et Interactions";
                
                let msi = Departement(context:context);
                msi.name="MSI";
                msi.fullName="Mécanique structures industrielles";
                
                let se = Departement(context:context);
                se.name="SE";
                se.fullName="Systèmes embarqués";
                
                do{
                    try context.save();
                }
                catch let error as NSError{
                    print(error);
                }
            }
        }
        catch let error as NSError{
            print(error);
        }

    }
    func deleteAll(){
        // Initialize Fetch Request
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            
            // Save Changes
            try persistentContainer.viewContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            
            // Save Changes
            try persistentContainer.viewContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            
            // Save Changes
            try persistentContainer.viewContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            
            // Save Changes
            try persistentContainer.viewContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Departement")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            
            // Save Changes
            try persistentContainer.viewContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Years")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            
            // Save Changes
            try persistentContainer.viewContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Enseignant")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            
            // Save Changes
            try persistentContainer.viewContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            
            // Save Changes
            try persistentContainer.viewContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
    }

}

