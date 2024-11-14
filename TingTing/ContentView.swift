//
//  ContentView.swift
//  TingTing
//
//  Created by fujia wang on 2021/11/14.
//

import SwiftUI
import SwiftSpeech

struct ContentView: View {
    @ObservedObject private var data = MeetingData()
    let tabList: [String] = ["Voice", "Meeting", "Notes"]
    @State private var selectedTabBar = "Voice"
    @State public var xOffSet: CGFloat = 0
    init() { UITabBar.appearance().isHidden = true }
    @SceneStorage("localeIdentifier") var localeIdentifier: String = Locale.current.identifier.lowercased().replacingOccurrences(of: "_", with: "-")
    @State var isLocaleSettingsPopoverPresented = false

    var locale: Locale {
        Locale(identifier: localeIdentifier)
    }
    
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center,
                                     vertical: .bottom)) {
            TabView(selection: $selectedTabBar) {
                if selectedTabBar == tabList[0] {
                    NavigationView{
                        VoiceView(locale: locale)
                            .toolbar {
                            ToolbarItem {
                                Button {
                                    isLocaleSettingsPopoverPresented.toggle()
                                } label: {
                                    Image(systemName: "globe")
                                }.popover(isPresented: $isLocaleSettingsPopoverPresented) {
                                    NavigationView { localeSettings }
                                }
                            }
                        }
                    }.onAppear {
                        SwiftSpeech.requestSpeechRecognitionAuthorization()
                    }
                    
                } else if selectedTabBar == tabList[1] {
                    NavigationView {
                        MeetingView(meetings: $data.meetings) {
                            data.save()
                        }
                    }
                    .onAppear {
                        data.load()
                    }
                } else if selectedTabBar == tabList[2] {
                    ItemsView()
                    
                }
            }
            
            HStack() {
                ForEach(tabList,id: \.self) { image in
                    GeometryReader { reader in
                        TabbarButton(image: image, selectedTabBar:
                        selectedTabBar, reader: reader) {
                            withAnimation(Animation.linear(duration: 0.3)) {
                                selectedTabBar = image
                                xOffSet = reader.frame(in: .global).minX
                            }
                        }
                        .onAppear(perform: {
                            if image == tabList.first {
                                xOffSet = reader.frame(in: .global).minX
                            }
                        })
                    }.frame(width: 30, height: 30)
                    if image != tabList.last { Spacer(minLength: 0) }
                }
            }
            .padding(.horizontal, 25).padding(.vertical)
//            .background(Color.white.clipShape(CustomShape(xOffSet: xOffSet)).cornerRadius(10))
            .background(Color.white.clipShape(CustomShape(xOffSet: xOffSet)).cornerRadius(10))
            .padding(.horizontal)
        }
    
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
