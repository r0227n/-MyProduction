//
//  AddTaskView.swift
//  ToDoApp
//
//  Created by RyoNishimura on 2020/09/15.
//  Copyright © 2020 RyoNishimura. All rights reserved.
//

import SwiftUI
import CoreData

class AddEventData: ObservableObject {
    @Published var eventName = ""
    @Published var eventStartDay = Date()
    @Published var eventStartTime = Date()
    @Published var eventEndDay = Date()
    @Published var eventEndTime = Date()
    @Published var fullText: String = ""
}

struct AddTaskView: View {
    @ObservedObject var addEvent = AddEventData()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Schedule.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Schedule>
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("予定").font(.headline)){
                    TextField("予定を入力してください", text: $addEvent.eventName)
                }
                Section(header: Text("開始日時").font(.headline)){
                    DatePicker("開始日", selection: $addEvent.eventStartTime, displayedComponents: .date)
                    DatePicker("時刻", selection: $addEvent.eventStartDay, displayedComponents: .hourAndMinute)
                }
                Section(header: Text("終了日時").font(.headline)){
                    DatePicker("終了日", selection: $addEvent.eventEndTime, displayedComponents: .date)
                    DatePicker("時刻", selection: $addEvent.eventEndDay, displayedComponents: .hourAndMinute)
                }
                Section(header: Text("メモ").font(.headline)){
                    TextEditor(text: $addEvent.fullText)
                }
            }.navigationBarTitle("入力画面", displayMode: .large)
            Button(action: {
                addItem()
                presentationMode.wrappedValue.dismiss()
            }) {
                ZStack {
                    Circle()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("保存")
                        .foregroundColor(Color.white)
                }
            }
        }
    }
    private func addItem() {
        withAnimation {
            let newTask = Schedule(context: viewContext)
            newTask.title = addEvent.eventName
            newTask.start = addEvent.eventStartTime
            newTask.startDate = addEvent.eventStartDay
            newTask.end = addEvent.eventEndTime
            newTask.endDate = addEvent.eventStartDay
            newTask.memo = addEvent.fullText

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

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView().environment(\.managedObjectContext, PersistentScheduleController.preview.container.viewContext)
        
    }
}
