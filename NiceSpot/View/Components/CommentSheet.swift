//
//  CommentSheet.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 01/02/2021.
//

import SwiftUI
import CoreData

struct CommentSheet: View {
    @ObservedObject var content: DetailContent
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Comment")) {
                    TextField("Pseudonym", text: $content.userComment.pseudo)
                    TextField("Title", text: $content.userComment.title)
                    TextEditor(text: $content.userComment.detail)
                        .frame(height: 100.0)
                }
            }
            .navigationTitle("Write a comment")
            .navigationBarItems(
                leading: Button(action: { content.showCommentSheet = false }) {
                    Text("Cancel")
                },
                trailing: Button(action: { content.saveComment() }) {
                    Text("Save")
                }
                .disabled((content.userComment.title == "" || content.userComment.pseudo == "") || content.userComment.detail == "")
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CommentSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Spot> = Spot.fetchRequest()
        let result = try! context.fetch(request)
        let spotDetailContent = DetailContent(spot: result.first!)
        CommentSheet(content: spotDetailContent)
    }
}
