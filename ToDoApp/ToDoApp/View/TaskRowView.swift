//
//  ContentView.swift
//  ToDoApp
//
//  Created by RyoNishimura on 2020/09/22.
//

import SwiftUI
import CoreData

struct TaskRowView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Schedule.title, ascending: true)],
        animation: .default)
    private var task: FetchedResults<Schedule>
    
    
    let displayItems = ["全て","タイトル", "開始時刻", "終了時刻"]
    @State private var selection = 0

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Form {
                    Section(header: Text("表示項目").font(.headline)){
                        Picker(selection: $selection, label: Text("表示する項目を選択")) {
                                        ForEach(0 ..< displayItems.count) { num in
                                            Text(self.displayItems[num])
                                        }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    Section(header: Text("予定").font(.headline)){
                        ForEach(task) { item in
                            NavigationLink(
                                destination: TaskCellView(editTask: item),
                                label: {
                                    VStack(alignment: .leading) {
                                        switch(selection){
                                        case 0:
                                            Text(item.title!)
                                            Text("\(item.start!, formatter: itemFormatter)")
                                            Text("\(item.end!, formatter: itemFormatter)")
                                        case 1:
                                            Text("\(item.title!)")
                                        case 2:
                                            Text("\(item.start!, formatter: itemFormatter)")
                                        case 3:
                                            Text("\(item.end!, formatter: itemFormatter)")
                                        default:
                                            Text("エラー")
                                        }
                                    }
                                })
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                
                NavigationLink(destination: AddTaskView() , label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("新規追加")
                    }
                }).padding(15)
            }
            .navigationTitle("ToDoApp")
            .navigationBarItems(trailing: EditButton())
        }
    }

    func addItem() {
        withAnimation {
            let newTask = Schedule(context: viewContext)
            newTask.start = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { task[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView().environment(\.managedObjectContext, PersistentScheduleController.preview.container.viewContext)
    }
}
