//
//  SearchSubView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 04/02/2021.
//

import SwiftUI
import CoreData

struct SearchSubView: View {
    @ObservedObject var content: SearchContent

    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {

                    TextField("Search...", text: $content.searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .overlay(
                            Image(systemName: "magnifyingglass")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                                .foregroundColor(.gray)
                        )
                        .cornerRadius(8)
                        .padding()
                    if content.searchText != "" {
                        CancelButton(content: content)
                    }
                }
            }
            List {
                ForEach(content.spots) { spot in
                    NavigationLink(
                        destination:
                            DetailView(content: DetailContent(spot: spot)),
                        label: {
                            SpotItemView(content: SpotCellContent(spot: spot))
                        }
                    )
                }
            }
            .listStyle(PlainListStyle())
            Spacer()
        }
    }
}

private struct CancelButton: View {
    @ObservedObject var content: SearchContent
    var  body: some View {
        Button(action: {
            content.searchText = ""
            hideKeyboard()
        }, label: {
            Image(systemName: "xmark.circle")
                .foregroundColor(.gray)
        })
        .padding(.trailing, 25)
    }
}

struct SpotsListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSubView(content: Preview.searchContent)
//        CancelButton(content: Preview.searchContent)
//            .environment(\.managedObjectContext, Preview.context)
//            .previewLayout(.fixed(width: 50, height: 50))
//            .previewDisplayName("Cancel Button")
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
