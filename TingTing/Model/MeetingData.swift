//
//  MeetingData.swift
//  Scrumdinger
//
//

import Foundation

class MeetingData: ObservableObject {
    private static var documentFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        }catch {
            fatalError("Can't find documents directory.")
        }
    }
    
//    private static var fileURL: URL {
//        return documentFolder.appendingPathExtension("meetings.data")
//    }
    static func getDocDir() -> URL {
            let path = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)
            print("Doc Dir:\(path[0])")
            return path[0]
        }
        
        static var fileURL: URL {
            return self.getDocDir().appendingPathComponent("meetings.data")
        }
    
    
    @Published var meetings: [MeetingInfo] = []
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.meetings = MeetingInfo.data
                }
                #endif
                return
            }
            guard let meetings = try? JSONDecoder().decode([MeetingInfo].self, from: data) else {
                fatalError("Can't decode saved scrum data.")
            }
            DispatchQueue.main.async {
                self?.meetings = meetings
            }
        }
    }
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let meetings = self?.meetings else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(meetings) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}
