//
//  DetailView.swift
//

import SwiftUI
import SwiftSpeech

struct DetailView: View {
    @Binding var meeting: MeetingInfo
    @State private var data: MeetingInfo.Data = MeetingInfo.Data()
    @State private var isPresented = false
    @State private var isMeeting = false

    @State private var showingAlert = false

    
    @SceneStorage("localeIdentifier") var localeIdentifier: String = Locale.current.identifier.lowercased().replacingOccurrences(of: "_", with: "-")
    var locale: Locale {
        Locale(identifier: localeIdentifier)
    }
    @State var isLocaleSettingsPopoverPresented = false
    var body: some View {
        List {
            Section(header: Text(NSLocalizedString("Meeting Info", comment: ""))) {
//                NavigationLink(
//                    destination: ListView(meetingData: $data, locale: locale)
                
//                )
//                {
//
//                }
                Label(NSLocalizedString("Start Meeting", comment: ""), systemImage: "timer")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                    .accessibilityLabel(Text(NSLocalizedString("Start meeting", comment: ""))).onTapGesture {
                        if meeting.attendees.count == 0{
//                            let alertController = UIAlertController(title: "Error", message:
//                                                                        "Please include at least one attendee", preferredStyle: .alert)
//                            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
//                            self.present(alertController, animated: true, completion: nil)
                            
                            showingAlert = true

                        }
                        else{
                            isPresented = true
                            isMeeting = true
                            data = meeting.data
                        }

                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(NSLocalizedString("Error", comment: "")), message: Text(NSLocalizedString("Please include at least one attendee", comment: "")), dismissButton: .default(Text(NSLocalizedString("Ok", comment: ""))))
                    }
//                        if meeting.attendees.count == 0{
//                            let alertController = UIAlertController(title: "Error", message:
//                                                                        "Please include at least one attendee", preferredStyle: .alert)
//                            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
//                            self.present(alertController, animated: true, completion: nil)
//                            isPresented = false
//                            isMeeting = false
//                            data = nil
//                        }
//                        else{
//                            .accessibilityLabel(Text("Start meeting")).onTapGesture {
//                                isPresented = true
//                                isMeeting = true
//                                data = meeting.data
//                            }
//                        }
                HStack {
                    Label(NSLocalizedString("Color", comment: ""), systemImage: "paintpalette")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(meeting.color)
                }
                .accessibilityElement(children: .ignore)
            }
            Section(header: Text(NSLocalizedString("Attendees", comment: ""))) {
                ForEach(meeting.attendees, id: \.self) { attendee in
                    Label(attendee, systemImage: "person")
                        .accessibilityLabel(Text(NSLocalizedString("Person", comment: "")))
                        .accessibilityValue(Text(attendee))
                }
            }
            
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button(NSLocalizedString("Edit", comment: "")) {
            isPresented = true
            data = meeting.data
        })
        .navigationTitle(meeting.title)
        .fullScreenCover(isPresented: $isPresented) {
            if isMeeting {
                NavigationView {
                    ListView(meetingData: $data)
                        .navigationTitle(meeting.title)
                        .navigationBarItems(leading: Button(NSLocalizedString("Cancel", comment: "")) {
                            isPresented = false
                            isMeeting = false
                        }, trailing: Button(NSLocalizedString("Done", comment: "")) {
                            isPresented = false
                            isMeeting = false
                            meeting.update(from: data)
                        })
//                        .toolbar {
//                            ToolbarItem {
//                                Button {
//                                    isLocaleSettingsPopoverPresented.toggle()
//                               } label: {
//                                    Image(systemName: "globe")
//                                }.popover(isPresented: $isLocaleSettingsPopoverPresented) {
//                                    NavigationView { localeSettings }
//                                }
//                            }}
                }
            }else{
                NavigationView {
                    EditView(meetingData: $data)
                        .navigationTitle(meeting.title)
                        .navigationBarItems(leading: Button(NSLocalizedString("Cancel", comment: "")) {
                            isPresented = false
                        }, trailing: Button(NSLocalizedString("Done", comment: "")) {
                            isPresented = false
                            meeting.update(from: data)
                        })
                }
            }
            
        }
//        when u click done in the edit throw the error if there are 0 members
    }
    var localeSettings: some View {
        Form {
            Picker(NSLocalizedString("Region", comment: ""), selection: $localeIdentifier) {
                ForEach(SwiftSpeech.supportedLocales().map { $0.identifier.lowercased() }.sorted(), id: \.self) { localeIdentifier in
                    Text(Locale.current.localizedString(forIdentifier: localeIdentifier) ?? localeIdentifier)
                        .tag(localeIdentifier)
                }
            }
        }.navigationTitle(NSLocalizedString("Settings", comment: ""))
        .navigationBarItems(leading:
            Button(NSLocalizedString("Cancel", comment: "")) {
                isLocaleSettingsPopoverPresented.toggle()
            }
        )
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(meeting: .constant(MeetingInfo.data[0]))
        }
    }
}
