//
//  NoteItemView.swift
//  NoteDemo
//
//  Created by fujia wang on 2021/11/18.
//

import SwiftUI

struct NoteItemView: View {  // view.
    @Binding var noteItem: NoteItem  // binding value from ItemsView.swift, stores the current touched noteItem.
    
    @Binding var noteItems: [NoteItem]  // binding value from ItemsView.swift, stores the whole NoteItem array.
    
    var mSaveNote:saveNote?
    var body: some View {
        if !noteItem.isSwiped {
            NavigationLink(destination: NoteView(noteItems: $noteItems, id: noteItem.id, mSaveNote: mSaveNote)) {
                ItemBodyView(noteItem: $noteItem, noteItems: $noteItems, mSaveNote: mSaveNote)
            }
        } else {  // if the item view is swiped, it can be reset by touching it.
            ItemBodyView(noteItem: $noteItem, noteItems: $noteItems, mSaveNote: mSaveNote)
            .onTapGesture {  // touch to reset.
                if noteItem.offset != 0 {
                    noteItem.offset = 0
                    noteItem.isSwiped = false
                }
                noteItem.isSwiped = false
            }
        }
    }
}


struct ItemBodyView: View {  // view.
    @Binding var noteItem: NoteItem
    
    @Binding var noteItems: [NoteItem]
    
    var mSaveNote:saveNote?
    var body: some View {
        ZStack {
            if noteItem.offset == 0 {
                LinearGradient(gradient: .init(colors: [Color(hex: 0xff6a6a), Color(hex: 0xff0000)]), startPoint: .leading, endPoint: .trailing)
                    .opacity(0)
                    .cornerRadius(18)

            } else {
                LinearGradient(gradient: .init(colors: [Color(hex: 0xff6a6a), Color(hex: 0xff0000)]), startPoint: .leading, endPoint: .trailing)
                    .opacity((-noteItem.offset/90) * 1)
                    .cornerRadius(18)

            }
            
            // Delete Button...
            HStack {
                Spacer()
    
                Button(action: {
                    withAnimation(.easeIn) {deleteItem()}  // delete button under the item view.
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 90, height: 50)
                }
            }
            
//            VStack(spacing: 16) {
//                // Note title
//                HStack {
//                    Text(noteItem.noteTitle)
//                        .fontWeight(.semibold)
//                        .font(.system(size: 22))
//                        .foregroundColor(.black)
//
//                    Spacer()
//                }
//
//
//                HStack {
//                    Spacer()
//
//                    Text(noteItem.endTime)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(10)
//            .background(Color(hex: 0xf2f2f2))
//            .contentShape(Rectangle())
//            .offset(x: noteItem.offset)
//            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))  // drag gesture.
            VStack{
                
//                Text(noteItem.noteTitle+"\n"+"\n")
                Text(noteItem.noteTitle)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                    .multilineTextAlignment(.leading)
//                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                    .padding(.bottom, 20)

//                Text("\n")
                
                HStack{
                    
                    Text(noteItem.endTime)
                        .foregroundColor(.gray)
                        .opacity(0.8)
//                        .font(.subheadline)
                    
                    Spacer(minLength: 0)
                    

                }
//                .padding(.top, 55)
                
            }
            .padding([.leading, .bottom, .trailing], 10)
//            .padding(10)

//            .background(Color(hex: 0xf2f2f2))
            .background(Color("Blue"))
            .offset(x: noteItem.offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))  // drag gesture.
            .cornerRadius(18)
            .frame(minWidth: 100, maxWidth: 200, minHeight: 80, maxHeight: 80)



        }
    }
    
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if noteItem.isSwiped {
                noteItem.offset = value.translation.width - 90
            } else {
                noteItem.offset = value.translation.width
            }
        }
    }
    
    
    func onEnd(value: DragGesture.Value) {
            if value.translation.width < 0 {
                // Checking...
                if -value.translation.width > UIScreen.main.bounds.width {  // swipe to delete item. UIScreen.main.bounds.width / 3
                    noteItem.offset = -1000
                    deleteItem()
                } else if -noteItem.offset > 50 {
                    // Updating is Swiping...
                    noteItem.isSwiped = true
                    noteItem.offset = -90
                } else {
                    noteItem.isSwiped = false
                    noteItem.offset = 0
                }
            } else {
                noteItem.isSwiped = false
                noteItem.offset = 0
            }
    }
    
    
    // Removing Item...
    func deleteItem() {  // delete the item.
        noteItems.removeAll() { (noteItem) -> Bool in
            return self.noteItem.id == noteItem.id
        }
        if(mSaveNote != nil){
            mSaveNote!()
        }
        
    }
}


extension Color {  // an extension makes it possible to use hexadecimal color codes.
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 8) & 0xff) / 255,
            B: Double((hex >> 0) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

