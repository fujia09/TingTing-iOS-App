//
//  List.swift
//

import SwiftUI
import Combine
import SwiftSpeech
import Speech

struct ListView: View {
    
    @Binding var meetingData: MeetingInfo.Data
    
    
    @State var list: [(session: SwiftSpeech.Session, text: String)] = []
    @State var list2: [String] = []
    @State var transcription: String = ""
    @State var attendeesIndex = 0
//    var locale: Locale
    
    @SceneStorage("localeIdentifier") var localeIdentifier: String = Locale.current.identifier.lowercased().replacingOccurrences(of: "_", with: "-")
    
    var locale: Locale {
        Locale(identifier: localeIdentifier)
    }
    
//    public init(locale: Locale = .autoupdatingCurrent) {
//        self.locale = locale
//    }
//
//    public init(localeIdentifier: String) {
//        self.locale = Locale(identifier: localeIdentifier)
//    }
    

    public var body: some View {
        SwiftUI.List {
            
            ForEach(meetingData.history, id: \.self) { text in
                Text(text)
            }
            Text(transcription)
        }.overlay(
            HStack {
                
                SwiftSpeech.RecordButton()
//                    .swiftSpeechRecordOnHold(
//                        locale: self.locale,
//                        animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0),
//                        distanceToCancel: 100.0
//                    )
                    .swiftSpeechToggleRecordingOnTap(
                        locale: self.locale,
                        animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)
                    )
                    .onStartRecording { session in
                        list.append((session, ""))
                    }.onCancelRecording { session in
                        _ = list.firstIndex { $0.session.id == session.id }
                            .map { list.remove(at: $0) }
                    }.onRecognize(includePartialResults: true) { session, result in
                        list.firstIndex { $0.session.id == session.id }
                            .map { index in
//                                list[index].text = "小明：" +  result.bestTranscription.formattedString + (result.isFinal ? "" : "...")
                                transcription = self.meetingData.attendees[self.attendeesIndex] + ": " + result.bestTranscription.formattedString + (result.isFinal ? "" : "...")

                                if result.isFinal {
                                    meetingData.history.append(self.meetingData.attendees[self.attendeesIndex] + ": " +  result.bestTranscription.formattedString)
                                    transcription = NSLocalizedString("Current Attendees: ", comment: "") + self.meetingData.attendees[self.attendeesIndex]
                                }
                            }
                    } handleError: { session, error in
                        list.firstIndex { $0.session.id == session.id }
                            .map { index in
//                                list[index].text = "Error \((error as NSError).code)"
                                transcription = ""
                            }
                    }.padding(.bottom, 60)
//                    .padding(.leading, 200)
//                VStack{
//                    Picker(selection: $attendeesIndex, label: Text("Change attendees")) {
//                        ForEach(0..<meetingData.attendees.count) {
//                            Text(self.meetingData.attendees[$0]).tag($0)
//                        }
//                    }.frame(width: UIScreen.main.bounds.width/3).padding(.bottom, 60)
//                    Picker(selection: $attendeesIndex, content: {
//                        ForEach (0..<meetingData.attendees.count){
//
//                            Text("attendees:" + self.meetingData.attendees[$0]).tag($0)
//
//                        }}, label: {
//                            Text("attendees:")
//                        }).pickerStyle(MenuPickerStyle())
//                }
                ZStack {
                    Picker(selection: $attendeesIndex, label: Text("11").foregroundColor(.white), content:{
                        ForEach (0..<meetingData.attendees.count){
                            Text(self.meetingData.attendees[$0]).tag($0)
                        }
                    }).font(.headline).foregroundColor(Color.white).frame(width: 75, height: 75)
                        .clipShape(Circle()).background(Color.white)
                        .cornerRadius(40).padding(.bottom, 60).zIndex(0)
//                    Text("Change")
//                        .foregroundColor(.white)
//                        .padding(20)
//                        .padding(.bottom, 60)
//                        .transition(.opacity)
//                        .layoutPriority(2)
//                        .zIndex(1)
                }.padding(.leading, 100)
                
                
            },
            alignment: .bottom
            
        ).navigationTitle(NSLocalizedString("Meeting Log", comment: ""))
        
    }
}

//if meetingData.attendees.count == 0{
//    self.present(Service.createAlertController(title: "Error", message: "Please include at least one attendee"), animated: true, completion: nil)
//    return
//}
// also when you delete a member it becomes 0 members so also need to raise error

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(meetingData: .constant(MeetingInfo.data[0].data))
    }
}
