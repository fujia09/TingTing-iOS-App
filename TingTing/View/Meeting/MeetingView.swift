//
//  MeetingView.swift
//  TingTing
//
//  Created by fujia wang on 2021/11/14.
//

import SwiftUI

struct MeetingView: View {
    @Binding var meetings: [MeetingInfo]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresented = false
    @State private var newData = MeetingInfo.Data()
    
    @State var searchString = ""
    
    let saveAction: () -> Void
    var body: some View {
        List {
//            ForEach(meetings) { meeting in
//                NavigationLink(destination: DetailView(meeting: binding(for: meeting)).onDisappear(){
//                    saveAction()
//                }) {
//                    CardView(meeting: meeting)
//                }
//                .listRowBackground(meeting.color)
//            }.onDelete(perform: delete)
            ForEach(searchString == "" ? meetings : meetings.filter{$0.title.lowercased().contains(searchString.lowercased())}) { meeting in  // show the items view.
                    NavigationLink(destination: DetailView(meeting: binding(for: meeting)).onDisappear(){
                        saveAction()
                    }) {
                        CardView(meeting: meeting)
                    }
                    .listRowBackground(meeting.color)
                    
                }.onDelete(perform: delete)

        }
        .searchable(text: $searchString)
        .navigationTitle(NSLocalizedString("Meeting", comment: ""))
        .navigationBarItems(trailing: Button(action: {
            isPresented = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isPresented) {
            NavigationView {
                EditView(meetingData: $newData)
                    .navigationBarItems(leading: Button(NSLocalizedString("Cancel", comment: "")) {
                        isPresented = false
                        saveAction();
                    }, trailing: Button(NSLocalizedString("Add", comment: "")) {
                        let meeting = MeetingInfo(title: newData.title, attendees: newData.attendees, color: newData.color)
                        meetings.append(meeting)
                        isPresented = false
                        saveAction();
                    }).onDisappear(){
                        saveAction();
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }

    }
    
    private func binding(for meeting: MeetingInfo) -> Binding<MeetingInfo> {
        guard let index = meetings.firstIndex(where: { $0.id == meeting.id }) else {
            fatalError("Can't find scrum in array")
        }
        return $meetings[index]
    }
    
    func delete(at offsets: IndexSet) {
        if let first = offsets.first { //获得索引集合里的第一个元素，然后从数组里删除对应索引的元素
            meetings.remove(at: first)
            saveAction();
        }
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(meetings: .constant(MeetingInfo.data), saveAction: {})
    }
}
