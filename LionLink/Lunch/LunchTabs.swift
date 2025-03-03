//
//  LunchTabs.swift
//  LionLink
//
//  Created by Liam Bean on 11/4/24.
//

import SwiftUI
//struct NavView: View {
//    let lunchService: LunchService
//    let dailyMenus: [DailyMenu]
//    var todayId: Int
//    var todayDate: String
//    var body: some View {
//        NavigationView {
//            
//                ScrollView(.horizontal) {
//                    HStack{
//                    ForEach(dailyMenus, id: \.id) {menu in
//                        
//                        NavigationLink(destination: LunchTabs(lunchService: lunchService, dailyMenus: dailyMenus,todayId: todayId, todayDate: todayDate, tag: menu.id)) {
//                            Text("\(lunchService.formatDateFromMenu(from: menu.date)!)")
//                                .frame(minWidth:30,idealWidth:60,maxWidth: 75,minHeight: 30,idealHeight:80,maxHeight:90)
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                                .foregroundColor(Color.white)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//struct LunchTabs: View {
//    let count = 1...10
//    let lunchService: LunchService
//    let dailyMenus: [DailyMenu]
//    let todayId: Int
//    let todayDate: String
//    @State var tag: Int = 0
//    let colors = [Color.red,Color.blue,Color.green,Color.purple,Color.yellow]
//    var body: some View {
//      
////            TabView(selection:$tag){
////                ForEach(dailyMenus, id:\.id){ menu in
////                    VStack{
////                        Text("ID: \(menu.id)")
////                        Text("\(lunchService.formatDateFromMenu(from:menu.date)!)").padding()
////                            
////                        if !menu.lunchContents.isEmpty {
////                            Text("Breakfast: \(menu.breakfastContents.joined(separator: ", "))").padding()
////                        }
////                            
////                        if !menu.lunchContents.isEmpty {
////                            Text("Lunch: \(menu.lunchContents.joined(separator: ", "))").padding()
////                        }
////                            
////                        if !menu.dinnerContents.isEmpty {
////                            Text("Dinner: \(menu.dinnerContents.joined(separator: ", "))").padding()
////                        }
////                    }
////                    .tag(menu.id)
////                    .padding()
////                    .background(Color.blue.opacity(0.5))
////                    .foregroundColor(Color.white)
////                    .cornerRadius(20)
////                    .frame(width:300,height:500,alignment:.center)
////                        
////                    
////                    
////                }
////                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
////                .frame(width:310, height: 200)
////        }.onAppear(){
////            self.tag = todayId
////        }
//        TabView(){
//            ForEach(dailyMenus, id:\.id){ menu in
//                VStack{
//                    Text("ID: \(menu.id)")
//                    Text("\(lunchService.formatDateFromMenu(from:menu.date)!)").padding()
//                        
//                    if !menu.lunchContents.isEmpty {
//                        Text("Breakfast: \(menu.breakfastContents.joined(separator: ", "))").padding()
//                    }
//                        
//                    if !menu.lunchContents.isEmpty {
//                        Text("Lunch: \(menu.lunchContents.joined(separator: ", "))").padding()
//                    }
//                        
//                    if !menu.dinnerContents.isEmpty {
//                        Text("Dinner: \(menu.dinnerContents.joined(separator: ", "))").padding()
//                    }
//                }
//                .tag(menu.id)
//                .padding()
//                .background(Color.blue.opacity(0.5))
//                .foregroundColor(Color.white)
//                .cornerRadius(20)
//                .frame(width:300,height:500,alignment:.center)
//                    
//                
//                
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .tabViewStyle(.page)
//            .frame(width:310, height: 200)
//    }.onAppear(){
//        self.tag = todayId
//    }
//    }
//}
//
//


struct LunchTabs: View {
    let lunchService: LunchService
    let dailyMenus: [DailyMenu]
    let todayId: Int
    let todayDate: String
    @State private var currentTab: Int = 0
    var body: some View {
        GeometryReader{
            let size = $0.size
            TabView(selection: $currentTab, content:{
                ForEach(dailyMenus, id:\.id){menu in
                    ZStack{
                        RoundedRectangle(cornerRadius:25, style: .continuous)
                            .fill(.blue)
                            .frame(width:300,height:size.height)
                        Text("Menu")
                    }.tag(menu.id)
                        .offsetX(){ rect in
                            print(rect.minX)
                        }
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height:400)
            .offset(CGSize(width:(CGFloat(size.width)*CGFloat(todayId)), height: 0))
        }.onAppear(){
            self.currentTab = todayId
        }
    }
}
