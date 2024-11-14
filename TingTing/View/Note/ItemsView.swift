//
//  ItemsView.swift
//  NoteDemo
//
//  Created by fujia wang on 2021/11/18.
//

import SwiftUI

struct ItemsView: View {  // view.
    @StateObject var noteData = NoteViewModel()
    @State var searchString = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {  // ScrollView.
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
                    LazyVGrid(columns: columns, spacing: 10){
                    
//                    LazyVStack(spacing: 2) {
                        ForEach(searchString == "" ? noteData.noteItems : noteData.noteItems.filter{$0.noteTitle.lowercased().contains(searchString.lowercased())}) { noteItem in  // show the items view.
                            NoteItemView(noteItem: $noteData.noteItems[getItemIndex(noteItem: noteItem)], noteItems: $noteData.noteItems,mSaveNote:saveNote)
                            
                        }
                    }
                }
                .onTapGesture {
                          self.hideKeyboard()
                        }
                // Create a new note
            }
            .padding(.horizontal,10)
            .navigationTitle(NSLocalizedString("Quick Flashcards", comment: ""))
            .searchable(text: $searchString)
            .navigationBarItems(trailing:NavigationLink(destination: NoteView(noteItems: $noteData.noteItems, id: "",mSaveNote:saveNote)) {
                Image(systemName: "square.and.pencil")
            })
        }
    }
    
    
    
    
    func getItemIndex(noteItem: NoteItem) -> Int {  // get the index of current item.
        return noteData.noteItems.firstIndex { (noteItem1) -> Bool in
            return noteItem.id == noteItem1.id
        } ?? 0
    }
    
    func saveNote() {
        noteData.save()
    }

}


struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}

