//
//  EditView.swift
//
//

import SwiftUI

struct EditView: View {
    @Binding var meetingData: MeetingInfo.Data
    @State private var newAttendee = ""
    var body: some View {
        List {
            Section(header: Text(NSLocalizedString("Meeting Info", comment: ""))) {
                TextField(NSLocalizedString("Meeting Title", comment: ""), text: $meetingData.title)
                ColorPicker(NSLocalizedString("Color", comment: ""), selection: $meetingData.color)
                    .accessibilityLabel(Text(NSLocalizedString("Color picker", comment: "")))
            }
            Section(header: Text(NSLocalizedString("Attendees", comment: ""))) {
                ForEach(meetingData.attendees, id: \.self) { attendee in
                    Text(attendee)
                }
                .onDelete { indices in
                    meetingData.attendees.remove(atOffsets: indices)
                }
                HStack {
                    TextField(NSLocalizedString("New Attendee", comment: ""), text: $newAttendee)
                    Button(action: {
                        withAnimation {
                            meetingData.attendees.append(newAttendee)
                            newAttendee = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(Text(NSLocalizedString("Add attendee", comment: "")))
                    }
                    .disabled(newAttendee.isEmpty)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())

    }

}

//if meetingData.attendees.count == 0{
//    self.present(Service.createAlertController(title: "Error", message: "Please include at least one attendee"), animated: true, completion: nil)
//    return
//}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(meetingData: .constant(MeetingInfo.data[0].data))
    }
}
