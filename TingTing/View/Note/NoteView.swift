//
//  NoteView.swift
//  TingTing
//
//  Created by fujia wang on 2021/11/26.
//

import SwiftUI

typealias saveNote = ()->Void

struct NoteView: View {  // view.
    enum FocusOnTyping: Hashable {  // an enumeration type that stores focus information.
        case textEditor
    }
    
    @FocusState var focusOnTyping: FocusOnTyping?  // stores the focus state.
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>  // control the backward of the navigationLink.
    
    @Binding var noteItems: [NoteItem]  // NoteItems in NoteViewModel.swift.
    
    @State var id: String  // noteItem's id.
    @State var index = 0  // the index of current noteItem in noteItems.
    @State var fullText: String = ""  // a local variable which stores the content in TextEditor.
    @State var endTime: String = ""  // a local variable that records the time of last modification.
    @State var noteTitle: String = ""  // a local variable that stores the title of this note.
    @State var tempText: String = ""  // a temporary variable is used to dertermine whether the endTime needs to be updated.
    @State private var changeSize = 0.0
    
    var mSaveNote:saveNote?
    
    var body: some View {
        VStack {
            Text(endTime).foregroundColor(Color.gray).font(.system(size: 14))
            TextEditor(text: $fullText)
                .navigationBarTitle(noteTitle, displayMode: .inline)
//                .navigationBarItems(trailing:
//                Button(action: {  // the function of the "完成" button on the navigation bar.
//                    UIApplication.shared.endEditing()  // make TextEditor lose focus and hide the keyboard.
//                    if tempText != fullText {  // if the content had been modified, update the endTime.
//                        tempText = fullText
//                        endTime = getCurrentTime()
//                    }
//                    noteTitle = getTitle(content: fullText)  // intercept the first ten elements of the content as the note title.
//                    setNoteData()  // update the noteItems.
//                    finishedNote()  // tail operation.
//                }) {
////                    Text("Done")
//                    Image(systemName: "checkmark")
//                }
//            )
            .focused($focusOnTyping, equals: .textEditor)  // focus control
            .onAppear {
                getNoteData()  // load note data from noteItems.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  // a small delay makes focus control work, anything over 0.5 seems to work.
                    self.focusOnTyping = .textEditor
                }
            }
            .font(.system(size: changeSize))
//            .dynamicTypeSize(.medium)
//            .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//            .dynamicTypeSize(.medium ... .accessibility5)
//            .minimumScaleFactor(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
            Slider(value: $changeSize, in: 10...80)
                .padding(.bottom, 100)
                .padding(.horizontal, 20.0)
            

        }
        .navigationBarItems(trailing:
        Button(action: {  // the function of the "完成" button on the navigation bar.
            UIApplication.shared.endEditing()  // make TextEditor lose focus and hide the keyboard.
            if tempText != fullText {  // if the content had been modified, update the endTime.
                tempText = fullText
                endTime = getCurrentTime()
            }
            noteTitle = getTitle(content: fullText)  // intercept the first ten elements of the content as the note title.
            setNoteData()  // update the noteItems.
            finishedNote()  // tail operation.
        }) {
//                    Text("Done")
            Image(systemName: "checkmark")
        }
    )
    .onTapGesture {
              self.hideKeyboard()
            }
    }
    
    
    func getNoteIndex(id: String) -> Int {  // get the index of current noteItem.
        return noteItems.firstIndex { (noteItem) -> Bool in
            return noteItem.id == id
        } ?? noteItems.count - 1
    }
    
    
    func getNoteData() {  // load the note data from current noteItem.
        if id != "" {  // load data.
            index = getNoteIndex(id: id)
            let noteItem = noteItems[index]
            fullText = noteItem.content
            tempText = fullText
            endTime = noteItem.endTime
            noteTitle = noteItem.noteTitle
            print("笔记\(index + 1)内容获取成功！\n标题: \(noteTitle)\n修改时间: \(endTime)\n正文: \(fullText)")
        } else {  // new note.
            print("新建笔记！")
        }
    }
    
    
    func setNoteData() {  // update the note data into current noteItem.
        let mainText = fullText.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
        if fullText != "" {
            if id != "" {
                if noteItems[index].content == fullText {  // the content of current note has's chaned.
                    print("笔记\(index + 1)的内容未发生更改！")
                } else {
                    if mainText == "" {  // there is no actual content in current note, only some enter.
                        noteTitle = NSLocalizedString("[Title is empty]", comment: "")
                    }
                    noteItems[index].noteTitle = noteTitle
                    noteItems[index].endTime = endTime
                    noteItems[index].content = fullText
                    print("笔记\(index + 1)内容修改成功！")
                }
            } else {  // create a new noteItem.
                if mainText == "" {
                    noteTitle = NSLocalizedString("[Title is empty]", comment: "")
                }
                let noteItem = NoteItem(noteTitle: noteTitle, endTime: endTime, content: fullText, isSwiped: false, offset: 0)
//                print(noteItem.noteTitle)
                noteItems.append(noteItem)
                id = noteItem.id
                index = noteItems.count - 1
                print("笔记创建成功！新的笔记是笔记\(noteItems.count)！")
            }
        } else {  // content is empty.
            if id != "" {  // delete the content in the current noteItem.
                noteItems.remove(at: index)
                self.presentationMode.wrappedValue.dismiss()  // back
                print("笔记\(index + 1)内容已被清空，笔记删除！")
            } else {  // nothing in the new note.
                print("未输入内容，笔记创建失败！")
            }
        }
    }
    
    
    func getTitle(content: String) -> String {  // get the note title.
        let limit = 1000000000000000000
        var title = content.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
        if content == "" {  // the title is "" if the note content is "".
            return ""
        } else if title == "" {  // the title is "[标题为空]" if there is no actual content.
            return NSLocalizedString("[Title is empty]", comment: "")
        } else if title.count > limit {  // intercept the first ten elements of the content as the note title.
            title = String(title[title.startIndex..<title.index(title.startIndex, offsetBy: limit)])
        }
        return title
    }
    
    
    func getCurrentTime() -> String {  // get current time.
        let nowTimeStamp = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM y"
        return dateFormatter.string(from: nowTimeStamp)
    }
    
    
    func finishedNote() {  // tail op.
        if(mSaveNote != nil){
            mSaveNote!()
        }
    }
}

extension UIApplication {
    func endEditing() {  // make TextEditor lose focus and hide the keyboard.
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
