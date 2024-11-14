//
//  VoiceView.swift
//  TingTing
//
//  Created by fujia wang on 2021/11/24.
//

import SwiftUI
import SwiftSpeech

struct VoiceView: View {
    var locale: Locale
    
    @State private var text = NSLocalizedString("Tap to Speak", comment: "")
    
    public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
    
    public init(localeIdentifier: String) {
        self.locale = Locale(identifier: localeIdentifier)
    }
    
    var body: some View {
        VStack(spacing: 35.0) {
            Text(text)
                .font(.system(size: 25, weight: .bold, design: .default))
            SwiftSpeech.RecordButton()
                .swiftSpeechToggleRecordingOnTap(locale: self.locale, animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                .onRecognizeLatest(update: $text)
            
        }.navigationTitle(NSLocalizedString("Voice", comment: ""))

    }

}


struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView()
    }
}
