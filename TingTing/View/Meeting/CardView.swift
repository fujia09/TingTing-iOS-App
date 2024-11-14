//
//  CardView.swift
//  Scrumdinger
//
//

import SwiftUI

struct CardView: View {
    let meeting: MeetingInfo
    var body: some View {
        VStack(alignment: .leading) {
            Text(meeting.title)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(meeting.attendees.count)", systemImage: "person.3")
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(NSLocalizedString("Attendees", comment: "")))
                    .accessibilityValue(Text("\(meeting.attendees.count)"))
                Spacer()
            }
            .font(.caption)
            
        }
        .padding()
        .foregroundColor(meeting.color.accessibleFontColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var meeting = MeetingInfo.data[0]
    static var previews: some View {
        CardView(meeting: meeting)
            .background(meeting.color)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
