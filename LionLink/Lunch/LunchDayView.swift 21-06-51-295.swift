//
//  LunchDayView.swift
//  LionLink
//
//  Created by Liam Bean on 10/28/24.
//

import SwiftUI
import UIKit


struct VisibleItemPreferenceKey: PreferenceKey {
    static var defaultValue: Int? = nil
    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        value = value ?? nextValue()
    }
}
struct VisibleDatePreferenceKey: PreferenceKey {
    static var defaultValue: Int? = nil
    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        value = value ?? nextValue()
    }
}

struct LunchDayView: View {
    let lunchService: LunchService
    let dailyMenus: [DailyMenu]
    let todayId: Int
    let todayDate: String
    @State private var currentlyVisibleId: Int?
    @State var dateSelected: Int
    @State private var debounceTask: DispatchWorkItem?
//    @State private var activeTab: [DailyMenu]
    var body: some View {
        ScrollViewReader { proxy in
            VStack{
                //                Button{
                //                    proxy.scrollTo(todayDate,anchor:.leading)
                //                    proxy.scrollTo(todayId, anchor:.center)
                //                }label:{
                //                    Text("Today's Menu")
                //                        .bold()
                //                        .fontDesign(.default)
                //                        .foregroundStyle(.white)
                //                        .frame(width:120,height:50)
                //                }
                
                    DayLunch(lunchService: lunchService,dailyMenus:dailyMenus,todayId:todayId,proxy:proxy,selectedDate: $dateSelected)
                
                
                //                NavView(lunchService: lunchService, dailyMenus: dailyMenus, todayId: todayId, todayDate: todayDate)
                //                LunchTabs(lunchService: lunchService, dailyMenus: dailyMenus,todayId: todayId, todayDate: todayDate)
                Spacer()
                //BELOW IS NON FUNCTIONAL
                
                
                //                TabView(selection:$activeTab){
                //                    ForEach(dailyMenus, id:\.id){menu in
                //                        VStack{
                //                            Text("ID: \(menu.id)")
                //                            Text("\(lunchService.formatDateFromMenu(from:menu.date)!)").padding()
                //
                //                            if !menu.lunchContents.isEmpty {
                //                                Text("Breakfast: \(menu.breakfastContents.joined(separator: ", "))").padding()
                //                            }
                //
                //                            if !menu.lunchContents.isEmpty {
                //                                Text("Lunch: \(menu.lunchContents.joined(separator: ", "))").padding()
                //                            }
                //
                //                            if !menu.dinnerContents.isEmpty {
                //                                Text("Dinner: \(menu.dinnerContents.joined(separator: ", "))").padding()
                //                            }
                //                        }
                //                        .tag(menu.id)
                //                        .padding()
                //                        .background(Color.blue.opacity(0.5))
                //                        .foregroundColor(Color.white)
                //                        .cornerRadius(20)
                //                        .frame(width:300,height:500,alignment:.center)
                //
                //                    }
                //
                //
                //                    }
                //                }
                //                .onAppear(){
                //                    self.activeTab = todayId
                //                }
                //
                //                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                //
                //
                
                //BELOW IS FUNCTIONAL
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing:0){
                        ForEach(dailyMenus, id:\.id){ menu in
                                VStack{
                                    Text("\(lunchService.formatDateFromMenu(from: menu.date)!)")
                                        .font(.system(size:40))
                                        .background(.clear)
                                    
                                    ScrollView(showsIndicators:false){
                                        VStack(alignment: .center){
                                            if !menu.breakfastContents.isEmpty {
                                                LunchRec(title:"Breakfast",text:"\(menu.breakfastContents.joined(separator: "\n-"))",color:.whiteNGray)
                                                    .padding(5)
                                            }
                                            
                                            if !menu.lunchContents.isEmpty {
                                                LunchRec(title:"Lunch",text:"\(menu.lunchContents.joined(separator: "\n-"))",color:.whiteNGray)
                                                    .padding(5)

                                            }
                                            
                                            if !menu.dinnerContents.isEmpty {
                                                LunchRec(title:"Dinner",text:"\(menu.dinnerContents.joined(separator: "\n-"))",color:.whiteNGray)
                                                    .padding(5)
                                                
                                            }
                                            
                                            
                                        }.background(.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius:20))
                                        
                                    }
                                    .scrollTargetLayout()
                                    .scrollTargetBehavior(.viewAligned)
                                }
                                .scrollTransition(.interactive){content, phase in
                                    content
                                        .opacity(phase.isIdentity ?1:0)
                                        .scaleEffect(phase.isIdentity ?1:0.7)
                                    
                                }
                                .overlay(GeometryReader { geometry in
                                            Color.clear
                                            .preference(
                                            key: VisibleItemPreferenceKey.self,
                                            value: geometry.frame(in: .global).midX >= 0 && geometry.frame(in: .global).midX <= UIScreen.main.bounds.width ? menu.id : nil
                                        )
//                                        .border(Color.red, width: 2) // Debugging: Add a border to see the GeometryReader's frame
                                })
                                .containerRelativeFrame(.horizontal, alignment:.center)
                                .onAppear(){
                                    proxy.scrollTo(todayId,anchor:.center)
                                    currentlyVisibleId=menu.id
                                    
                                }
                            .onAppear(){
                                proxy.scrollTo(todayDate,anchor:.leading)
                                print(todayDate)
                            }
                            
                        }.onAppear(){
                            proxy.scrollTo(todayId)
                            dateSelected=todayId
                            print(dateSelected)
                            
                        }
                        //                                    .scenePadding()
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
                .scrollTargetLayout()
                .scrollTargetBehavior(.viewAligned)
                .contentMargins(10)
                .onAppear(){
                    proxy.scrollTo(todayId)
                    
                }
                .onPreferenceChange(VisibleItemPreferenceKey.self) { visibleId in
                    // Update the currently visible element
                    
                    currentlyVisibleId = visibleId
                    dateSelected = (currentlyVisibleId ?? todayId)
                    withAnimation(.easeOut(duration: 2).speed(4.0)) {
                        proxy.scrollTo(lunchService.getDateByMenuId(menuId: dateSelected, from: dailyMenus) ?? todayDate)
                    }
                }
                
                
            }
            
        }
    }
}
//struct LunchDayView: View {
//    let lunchService: LunchService
//    let dailyMenus: [DailyMenu]
//    let todayId: Int
//    let todayDate: String
//    @State var dateSelected: Int
//    @State private var currentlyVisibleId: Int? // Track the currently visible element
//
//    var body: some View {
//        ScrollViewReader { proxy in
//            VStack {
//                // Button to scroll to today's menu
//                Button {
//                    withAnimation {
//                        proxy.scrollTo(todayId, anchor: .center)
//                        dateSelected = todayId
//                        currentlyVisibleId = todayId
//                    }
//                } label: {
//                    Text("Today's Menu")
//                        .bold()
//                        .fontDesign(.default)
//                        .foregroundStyle(.white)
//                        .frame(width: 120, height: 50)
//                }
//
//                DayLunch(lunchService: lunchService, dailyMenus: dailyMenus, todayId: todayId, proxy: proxy, selectedDate: $dateSelected)
//
//                Spacer()
//
//                // Horizontal ScrollView
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 0) {
//                        ForEach(dailyMenus, id: \.id) { menu in
//                            GeometryReader { geometry in
//                                VStack {
//                                    Text("\(lunchService.formatDateFromMenu(from: menu.date)!)")
//                                        .font(.system(size: 40))
//                                        .fontDesign(.serif)
//                                        .background(.clear)
//
//                                    ScrollView(showsIndicators: false) {
//                                        VStack {
//                                            if !menu.breakfastContents.isEmpty {
//                                                LunchRec(title: "Breakfast", text: "\(menu.breakfastContents.joined(separator: "\n-"))", color: .clearNGray)
//                                                    .padding(5)
//                                            }
//
//                                            if !menu.lunchContents.isEmpty {
//                                                LunchRec(title: "Lunch", text: "\(menu.lunchContents.joined(separator: "\n-"))", color: .clearNGray)
//                                                    .padding(5)
//                                            }
//
//                                            if !menu.dinnerContents.isEmpty {
//                                                LunchRec(title: "Dinner", text: "\(menu.dinnerContents.joined(separator: "\n-"))", color: .clearNGray)
//                                                    .padding(5)
//                                            }
//                                        }
//                                        .background(.white.opacity(0.2))
//                                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                                    }
//                                    .scrollTargetLayout()
//                                    .scrollTargetBehavior(.viewAligned)
//                                }
//                                .onChange(of: geometry.frame(in: .global).midX) { midX in
//                                    // Check if the element is in the visible area
//                                    let screenWidth = UIScreen.main.bounds.width
//                                    if abs(midX - screenWidth / 2) < screenWidth / 2 {
//                                        currentlyVisibleId = menu.id
//                                    }
//                                }
//                            }
//                            .containerRelativeFrame(.horizontal, alignment: .center)
//                            .id(menu.id) // Assign an ID to each menu for scrolling
//                        }
//                    }
//                }
//                .scrollTargetLayout()
//                .scrollTargetBehavior(.viewAligned)
//                .contentMargins(10)
//                .onAppear {
//                    withAnimation {
//                        proxy.scrollTo(todayId, anchor: .center)
//                        dateSelected = todayId
//                        currentlyVisibleId = todayId
//                    }
//                }
//            }
//        }
//    }
//}
struct DayLunch: View {
    let lunchService: LunchService
    let dailyMenus: [DailyMenu]
    let todayId: Int

    let proxy: ScrollViewProxy
    @Binding var selectedDate: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(dailyMenus, id:\.date){ menu in
                    VStack{
                        Button(){
                            print(selectedDate)
//                            withAnimation(.spring(duration: 0.5, bounce: 1,blendDuration: 1)) {
                                proxy.scrollTo(menu.id,anchor:.center)
//                            }
                            selectedDate = menu.id
                        }label:{
                            VStack{
                                Text("\(lunchService.formatDateFromMenuShort(from: menu.date)!)")
                                    .foregroundStyle(.whiteNBlack)
                                Circle()
                                    .foregroundStyle( menu.id==selectedDate ? .blue : .clear)
                                    .transition(.scale)

                                    .overlay{
                                        ZStack{
                                            Text("\(lunchService.formatDateFromMenuShortNum(from: menu.date)!)")
                                                .foregroundStyle((menu.id==selectedDate) ? .white : .whiteNBlack)
                                            Circle()
                                                .stroke(.black,lineWidth:1)
                                                .background(.clear)
                                                .frame(width:29,height:29)
                                        }
                                    }
                                    .padding(0)
                                    .frame(width:30,height:30)
                                
                                    
                            }
                            .frame(minWidth:20,idealWidth:UIScreen.screenWidth/6,maxWidth: 200)
                            .background(.clear)
                            .cornerRadius(10)
                        }
                        
                    }.scrollTransition(.animated.threshold(.visible(0.9))){content, phase in
                        content
                            .opacity(phase.isIdentity ?1:0.7)
                            .scaleEffect(phase.isIdentity ?1:0)
                            .blur(radius: phase.isIdentity ?0:2)
                        
                        
                    }
                    .overlay(GeometryReader { geometry in
                                Color.clear
                                .preference(
                                key: VisibleDatePreferenceKey.self,
                                value: geometry.frame(in: .global).midX >= 0 && geometry.frame(in: .global).midX <= UIScreen.main.bounds.width ? menu.id : nil
                            )
//                                        .border(Color.red, width: 2) // Debugging: Add a border to see the GeometryReader's frame
                    })
                   
                    .ignoresSafeArea()
                    
                }
            }.ignoresSafeArea()
        }.ignoresSafeArea()
            .scenePadding()
            .onPreferenceChange(VisibleDatePreferenceKey.self) { visibleId in
                                // Update the currently visible element
                                
                                    print("date"+"\(visibleId)")
                            }

            

        .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
    }
}
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct LunchRec: View{
    let title: String
    let text: String
    let color: Color
    @State var lines: Int = 1
    @State var expanded: Bool = true
    var body: some View{
        VStack(alignment:.leading){
//            Button{
//                expanded.toggle()
//            }label:{
                VStack(alignment: .leading){
                    Text(title)
                        .font(.system(size:40))
                    if expanded{
                        Text("-"+text)
                            .font(.system(size:20))
                            .multilineTextAlignment(.leading)
                        
                    }
                }
                    .padding()
                    .frame(width:350,alignment:.leading)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .animation(.easeInOut(duration:0.1),value:expanded)
//            }.buttonStyle(NoTapAnimationStyle())
                
        }
    }
}


struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Make the whole button surface tappable. Without this only content in the label is tappable and not whitespace. Order is important so add it before the tap gesture
            .onTapGesture(perform: configuration.trigger)
    }
}
