//
//  TaskCellView.swift
//  ToDoApp
//
//  Created by RyoNishimura on 2020/09/22.
//

import SwiftUI

struct TaskCellView: View {
    let editTask:Schedule
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var addEvent = AddEventData()
    
    @State var name: String = ""
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
                    Text("更新")
                        .foregroundColor(Color.white)
                }
            }
        }
    }
    private func addItem() {
        withAnimation {
            editTask.title = addEvent.eventName
            editTask.start = addEvent.eventStartTime
            editTask.startDate = addEvent.eventStartDay
            editTask.end = addEvent.eventEndTime
            editTask.endDate = addEvent.eventStartDay
            editTask.memo = addEvent.fullText

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

struct TaskCellView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellView(editTask: .init()).environment(\.managedObjectContext, PersistentScheduleController.preview.container.viewContext)
    }
}
