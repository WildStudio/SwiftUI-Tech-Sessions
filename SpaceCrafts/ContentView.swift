//
//  ContentView.swift
//  SpaceCrafts
//
//  Created by Christian Aranda on 26/09/2019.
//  Copyright © 2019 Christian Aranda. All rights reserved.
//

import SwiftUI

enum Side: String {
    case imperial
    case rebel
}

struct SpaceCraft: Identifiable {
    let id = UUID()
    let name: String
    let side: Side
}

struct ImperialList: View {
    var dataSource: [SpaceCraft] = [
        SpaceCraft(name: "Death Star", side: .imperial),
        SpaceCraft(name: "TIE Fighter", side: .imperial)
    ]
    
    var body: some View {
        List {
            ForEach(dataSource, content: SpaceCraftRowView.init(spaceCraft:))
        }
    }
}

final class RepublicData: ObservableObject {
    @Published var dataSource: [SpaceCraft] = [
        SpaceCraft(name: "X-Wing", side: .rebel),
        SpaceCraft(name: "Millenium Falcon", side: .rebel)
    ] // Binding<[SpaceCraft]>
    
    func addSpaceCraft() {
           if let random = dataSource.randomElement() {
               dataSource.append(random)
           }
       }
}

struct RepublicList: View {
    @EnvironmentObject var republicData: RepublicData
    
    var body: some View {
        List {
            ForEach(republicData.dataSource, content: SpaceCraftRowView.init(spaceCraft:))
        }
        .navigationBarTitle(Text("Republic Fleet"))
        .navigationBarItems(
            trailing: Button(action: {
                self.republicData.addSpaceCraft()
            }) {
                Text("Add")
            }
        )
    }
}

struct SpaceCraftRowView: View {
    let spaceCraft: SpaceCraft
    
    init(spaceCraft: SpaceCraft) {
        self.spaceCraft = spaceCraft
    }
    
    var body: some View {
        HStack {
            Text(spaceCraft.name)
            Spacer()
            Text(spaceCraft.side.rawValue)
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: RepublicList().environmentObject(RepublicData())) {
                    Text("Republic Fleet 🚀")
                }
                NavigationLink(destination: ImperialList()) {
                    Text("Empire Fleet 🚀")
                }
                EmptyView()
            }
            .navigationBarTitle("Star Wars Space Crafts")
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



// If you want callers to be able to select their data type then generics work well, but if you want the function to decide the return type then they fall down;
protocol SpaceShip {
    associatedtype Pilot
    init()
}

struct RebelSoldier {
    let name: String
}

struct EmpireSoldier {
    let name: String
}

struct XWing: SpaceShip {
    typealias Pilot = RebelSoldier
}
struct TIE: SpaceShip {
    typealias Pilot = EmpireSoldier
}

func launchFighter() -> some SpaceShip {
    return XWing()
}


// Opaque return types

//protocol SpaceShip {
//    init()
//}
//
//struct XWing: SpaceShip { }
//struct TIE: SpaceShip { }
//
//func launchFighter<T: SpaceShip>() -> T {
//    T()
//}
//
//let red5: XWing = launchFighter()

