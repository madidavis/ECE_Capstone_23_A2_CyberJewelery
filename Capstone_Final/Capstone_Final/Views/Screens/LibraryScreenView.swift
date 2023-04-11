//
//  LibraryScreenView.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct LibraryScreenView: View {
    //MARK: - PROPERTIES
    /** View Model */
    @ObservedObject var viewModel = LibraryScreenViewModel()
    
    /** Layout Paramertes */
    let gridPadding : Int = 20
    
    /** Library Collection View */
    let gridColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    //MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            VStack{
                //MARK: - HEADER
                HStack {
                    //MARK: - LEADING BUTTON
                    Button("left"){
                        print("left pressed")
                        print(viewModel.screenContentDim)
                        print(UIScreen.main.bounds.height)
                        print(geometry.size.height)
                        print(geometry.size.width)
                    }
                    .buttonStyle(HeaderButton())
                    
                    Spacer()
                    
                    //MARK: - TITLE
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    //MARK: - TRAILING BUTTON
                    Button("right"){
                        print("right pressed")
                        /* Add New Design */
                        viewModel.showNewDesignModal.toggle()
                    }
                    .buttonStyle(HeaderButton())
                    
                } //: HSTACK
                .padding([.leading,.trailing], 20)
                //MARK: - SEARCH BAR
                SearchBar()
                    .padding(20)
                //MARK: - DESIGN COLLECTION VIEW
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 20) {
                        ForEach(viewModel.designs) { design in
                            DesignCard(title: design.name)
                                .frame(minWidth: 165, maxWidth: .infinity,minHeight: 200, maxHeight: 200)
                        }
                    }//: LAZYVSTACK
                    .padding()
                }//: SCROLL
                
            }//: VSTACK
            .sheet(isPresented: $viewModel.showNewDesignModal, onDismiss: {
                // Get current / new design
                print("dismised")
                
            }) {
                AddDesignView( height: geometry.size.height*0.4, width: geometry.size.width)
 
            }
            
        }//: GEOREADER
        
    }

}

struct LibraryScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScreenView(viewModel: LibraryScreenViewModel(dataManager: DataManager.shared))
    }
}
