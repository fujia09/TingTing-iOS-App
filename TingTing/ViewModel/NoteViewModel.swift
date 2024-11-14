//
//  NoteViewModel.swift
//  NoteDemo
//
//  Created by fujia wang on 2021/11/18.
//

import SwiftUI


class NoteViewModel: ObservableObject {  // modelview.
    
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
//        return documentFolder.appendingPathExtension("note.data")
//    }
    static func getDocDir() -> URL {
            let path = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)
            print("Doc Dir:\(path[0])")
            return path[0]
        }
        
        static var fileURL: URL {
            return self.getDocDir().appendingPathComponent("note.data")
        }
    
    init(){
        load()
    }
    @Published var noteItems: [NoteItem] = []  // an array that stores NoteItems.
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.noteItems = []
                }
                #endif
                return
            }
            guard let noteItems = try? JSONDecoder().decode([NoteItem].self, from: data) else {
                fatalError("Can't decode saved note data.")
            }
            DispatchQueue.main.async {
                self?.noteItems = noteItems
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let notes = self?.noteItems else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(notes) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}
