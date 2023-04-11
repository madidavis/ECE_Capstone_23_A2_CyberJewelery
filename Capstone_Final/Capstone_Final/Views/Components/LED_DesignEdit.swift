//
//  LED_DesignEdit.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct LED_DesignEdit: View {
    //MARK: - PROPERTIES
    /* View Model */
    @ObservedObject var viewModel = LED_DesignEditViewModel()
    
    
    
    /* Editor Layout Properties */
    let numRows: Int = 8
    let numCols: Int = 8
    var gridIdx: Int = 0
    
    @ScaledMetric var horizontalPadding = 12.0
    @ScaledMetric var verticalPadding = 26.0
    @ScaledMetric var spacing = 12.0
    
    @ScaledMetric var totalWidth = 360
    @ScaledMetric var totalHeight = 390
    
    
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            //MARK: BACKGROUND
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(.systemGray6))
                .frame(width:totalWidth ,height: totalHeight)
                .ignoresSafeArea(.all)
            
            //MARK: GRID
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                ForEach(0..<numRows, id: \.self) { row in
                    GridRow {
                        ForEach(0..<numCols, id: \.self) { col in
                            // Instanstiate individual cell controllers
                            LED_CellEdit(viewModel: viewModel.cellVMCache[row*numRows + col])
                                .onTapGesture {
                                    viewModel.cellVMCache[row*numRows + col].isSelected.toggle()
                                    print(             viewModel.cellVMCache[row*numRows + col].isSelected)
                                }


                        }
                    }
                }
                
            }//: GRID
            .frame(width:totalWidth ,height: totalHeight)
            .ignoresSafeArea(.all)
        }//: ZSTACK
    }
}



//MARK: - PREVIEW
struct LED_DesignEdit_Previews: PreviewProvider {
    static var previews: some View {
        LED_DesignEdit(viewModel: LED_DesignEditViewModel(dataManager: DataManager.shared))
    }
}
