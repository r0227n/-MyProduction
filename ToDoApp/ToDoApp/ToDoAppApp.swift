//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by RyoNishimura on 2020/09/22.
//

import SwiftUI
import CoreData

@main
struct ToDoAppApp: App {
    //let persistenceController = PersistenceController.shared
    

    let persistenceController = PersistentScheduleController.shared
    var body: some Scene {
        WindowGroup {
            TaskRowView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
