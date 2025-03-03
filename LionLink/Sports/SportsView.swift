//
//  SportsView.swift
//  LionLink
//
//  Created by Jayden Yoon on 2/3/25.
//

import SwiftUI
import Foundation


    
struct SportsView: View {
    @State private var selectedTab: Int = 0 // 0 = Upcoming, 1 = My Team, etc.
    @State var teamClicked: Bool = false
    var body: some View {
        VStack {
            if !teamClicked{
                GeneralNavBar(title:"Sports")
                Spacer()
                // Top segmented control
                Picker(selection: $selectedTab, label: Text("")) {
                    Text("Upcoming Games").tag(0)
                    Text("My Team").tag(1)
                    Text("Teams").tag(2)
                    Text("Scores").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .padding(.top, -8)
            }
            
            // Switch visible content based on selected segment
            switch selectedTab {
            case 0:
                UpcomingGamesView()
            case 1:
                MyTeamViewTemp()
            case 2:
                TeamsView()
            case 3:
                ScoresView()
            default:
                UpcomingGamesView()
            }
        }
    }
}

// MARK: - Game Model (sample)
struct Game: Identifiable {
    let id = UUID()
    let league: String              // e.g. "NEPSAC", "Friendlies"
    let dateTime: String            // e.g. "Wednesday 01/15 5:30pm"
    let team1: String               // e.g. "Girls Varsity Hockey"
    let team2: String               // e.g. "Middlesex School"
    let isHome: Bool                // true if home, false if away
    let venueName: String?          // e.g. "Gardner Hockey Rink" if home
}

// MARK: - UPCOMING GAMES PAGE
struct UpcomingGamesView: View {
    
    // Example data
    
    let games: [Game] = [
        Game(league: "ISL",
             dateTime: "Sunday 01/12 4:30pm",
             team1: "Girls V Crew",
             team2: "Rivers Academy",
             isHome: false,
             venueName: nil),
        Game(league: "Friendlies",
             dateTime: "Wednesday 01/15 3:30pm",
             team1: "Boys JV Soccer",
             team2: "Milton Academy",
             isHome: true,
             venueName: "Thayer Field"),
        Game(league: "NEPSAC",
             dateTime: "Wednesday 01/15 5:30pm",
             team1: "Girls V Hockey",
             team2: "Middlesex School",
             isHome: true,
             venueName: "Gardner Hockey Rink"),
        Game(league: "NEPSAC",
             dateTime: "Wednesday 01/15 5:30pm",
             team1: "Girls V Squash",
             team2: "Thayer Academy",
             isHome: false,
             venueName: nil),
        Game(league: "NEPSAC",
             dateTime: "Wednesday 01/15 5:30pm",
             team1: "Girls V Squash",
             team2: "Thayer Academy",
             isHome: false,
             venueName: nil),
        Game(league: "NEPSAC",
             dateTime: "Wednesday 01/15 5:30pm",
             team1: "Girls V Squash",
             team2: "Thayer Academy",
             isHome: false,
             venueName: nil),
        Game(league: "NEPSAC",
             dateTime: "Wednesday 01/15 5:30pm",
             team1: "Girls V Squash",
             team2: "Thayer Academy",
             isHome: false,
             venueName: nil),
        // Add more games if desired
    ]
    
    // Example sports filter options
    let sportsFilters = ["Tennis", "Crew", "Hockey", "Squash", "Golf", "Soccer"]
    @State var selectedFilters: [String] = []
    @State var searching = false
    @State var searchText = ""
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Large heading
                Text("Upcoming Games")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, -7)
                
                // filter code Horizontal scroll for filters + search
                HStack{
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack() {
                            if !(searching){
                                ForEach(sportsFilters, id: \.self) { sport in
                                    Button{
                                        if !selectedFilters.contains(sport){
                                            selectedFilters.append(sport)
                                        }
                                        else{
                                            selectedFilters.remove(at:selectedFilters.firstIndex(of: sport)!)
                                        }
                                        
                                    } label:{
                                        Text(sport)
                                            .font(.subheadline)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                            )
                                            .background(selectedFilters.contains(sport) ? .clearNGray : .clear)
                                            .foregroundStyle(selectedFilters.contains(sport) ? .black : .primary)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                        
                                    }
                                }
                            }
                        }
                    }
                    SearchingBar(searchText: $searchText, isSearching: $searching)
                }
                
                // The list of upcoming games (scrollable vertical)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredTeams) { game in
                            GameCardView(game: game)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        var filteredTeams: [Game] {
            var filtered: [Game] = []
            let lowerSearch = searchText.lowercased()
            for filter in selectedFilters{
                filtered += games.filter{$0.team1.lowercased().contains(filter.lowercased())}
            }
            if !(lowerSearch.isEmpty){
                filtered = games.filter{$0.team1.lowercased().contains(lowerSearch)}
            }
            return (!(selectedFilters.isEmpty && searchText.isEmpty) ? filtered : games)
        }
    }
}
    
    // MARK: - Game Card View
    
struct GameCardView: View {
    let game: Game
    
    var body: some View {
        ZStack {
            // Outer shape
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            
            // Card content
            HStack(alignment: .top) {
                // Left column
                VStack(alignment: .leading, spacing: 4) {
                    // e.g. "NEPSAC", "Friendlies"
                    Text(game.league)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    // e.g. "Girls Varsity Hockey" + "Middlesex School"
                    Text(game.team1)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.team2)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Right column
                VStack(alignment: .trailing, spacing: 6) {
                    // Date/time in green
                    Text(game.dateTime)
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    // "Home" or "Away"
                    if game.isHome {
                        VStack(alignment: .trailing, spacing: 2) {
                            //Don't need to explicitly state "home" if you are giving campus location of event
                            //                            Text("Home")
                            //                                .font(.subheadline)
                            //                                .foregroundColor(.primary)
                            if let venue = game.venueName {
                                HStack(spacing: 4) {
                                    Text("📍")
                                    Text(venue)
                                }
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            }
                        }
                    } else {
                        Text("Away")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
}
    
    // MARK: - MY TEAM PAGE
    
struct MyTeamViewTemp: View {
    var body: some View {
        // Outer container: holds the “My Team” card + headings + two ScrollViews
        VStack(alignment: .leading) {
            
            // -- Title --
            Text("My Team")
                .font(.title)
                .fontWeight(.bold)
            // Extra bottom padding to separate from the card
                .padding(.bottom, 4)
                .padding(.top, -25)
            
            // -- My Team Card (full width) --
            VStack(alignment: .leading, spacing: 8) {
                Text("Varsity Boy’s Tennis 🎾")
                    .font(.headline)
                
                Text("Coach(es): Coach #1, Coach #2")
                    .font(.subheadline)
                Text("Captain(s): Player #1, Player #2")
                    .font(.subheadline)
                Text("Manager: Manager #1")
                    .font(.subheadline)
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("View Full Roster ➡️")
                        //Image(systemName: "arrow.forward.square")
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding() // Padding inside the card
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            
            // -- Coming Up Section --
            Text("Coming Up")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            
            // Only the items scroll
            ScrollView {
                VStack(spacing: 12) {
                    // Each item with generous padding
                    UpcomingItemView(
                        title: "Game v. Groton School",
                        dateTime: "Sunday 01/12 3:30pm",
                        location: "Tennis Courts",
                        locationIcon: "mappin.and.ellipse",
                        titleColor: .primary,
                        dateColor: .green
                    )
                    UpcomingItemView(
                        title: "Practice",
                        dateTime: "Monday 01/13 3:30pm",
                        location: "Tennis Courts",
                        locationIcon: "mappin.and.ellipse",
                        titleColor: .primary,
                        dateColor: .green
                    )
                    UpcomingItemView(
                        title: "Practice",
                        dateTime: "Tuesday 01/14 4:30pm",
                        location: "Tennis Courts",
                        locationIcon: "mappin.and.ellipse",
                        titleColor: .primary,
                        dateColor: .green
                    )
                }
                .padding(.vertical, 8)
            }
            // Height of the scrollable area (adjust as you like)
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
            
            // -- Scores Section --
            Text("Scores")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Record (W/D/L): 2/0/1")
                .font(.subheadline)
            
            ScrollView {
                VStack(spacing: 12) {
                    ScoreItemView(
                        opponent: "Rivers Academy",
                        dateTime: "Monday 01/13 3:30pm",
                        score: "4–3 Win",
                        isWin: true
                    )
                    ScoreItemView(
                        opponent: "Milton Academy",
                        dateTime: "Tuesday 01/14 4:30pm",
                        score: "3–4 Loss",
                        isWin: false
                    )
                }
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}
    
    // MARK: - UpcomingItemView
    
struct UpcomingItemView: View {
    let title: String
    let dateTime: String
    let location: String
    let locationIcon: String
    let titleColor: Color
    let dateColor: Color
    
    var body: some View {
        ZStack {
            // White background with a subtle border to mimic the Figma "card" look
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            
            HStack {
                // Left column
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(titleColor)
                    Text(dateTime)
                        .font(.footnote)
                        .foregroundColor(dateColor)
                }
                
                Spacer()
                
                // Right column: icon + text
                HStack(spacing: 4) {
                    Image(systemName: locationIcon)
                        .foregroundColor(.gray)
                    Text(location)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding() // Internal padding
        }
        .frame(maxWidth: .infinity)
    }
}
    
    // MARK: - ScoreItemView
    
struct ScoreItemView: View {
    let opponent: String
    let dateTime: String
    let score: String
    let isWin: Bool
    
    var body: some View {
        ZStack {
            // White background to match the design
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("v. \(opponent)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text(dateTime)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(score)
                    .fontWeight(.semibold)
                    .foregroundColor(isWin ? .green : .red)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
    
    // MARK: - TEAMS PAGE
    
    // MARK: - TEAMS PAGE DATA
struct Sports: Identifiable, Codable {
    let id = UUID()
    let name: String
    let teams: [SportTeam]
}
    
struct SportTeam: Identifiable, Codable {
    let id = UUID()
    let name: String
    let category: String
}
    
struct MockMeets {
    static let sportsData: [Sports] = [
        Sports(name: "Tennis", teams: [
            SportTeam(name: "Boys Varsity Tennis", category: "Boys Varsity"),
            SportTeam(name: "Girls Varsity Tennis", category: "Girls Varsity"),
            SportTeam(name: "Boys JV Tennis", category: "Boys JV"),
            SportTeam(name: "Girls JV Tennis", category: "Girls JV")
        ]),
        Sports(name: "Hockey", teams: [
            SportTeam(name: "Boys Varsity Hockey", category: "Boys Varsity"),
            SportTeam(name: "Girls Varsity Hockey", category: "Girls Varsity"),
            SportTeam(name: "Boys JV Hockey", category: "Boys JV"),
            SportTeam(name: "Girls JV Hockey", category: "Girls JV")
        ]),
        Sports(name: "Basketball", teams: [
            SportTeam(name: "Boys Varsity Basketball", category: "Boys Varsity"),
            SportTeam(name: "Girls Varsity Basketball", category: "Girls Varsity"),
            SportTeam(name: "Boys JV Basketball", category: "Boys JV"),
            SportTeam(name: "Girls JV Basketball", category: "Girls JV"),
            SportTeam(name: "Boys Freshman Basketball", category: "Boys Freshman"),
            SportTeam(name: "Girls Freshman Basketball", category: "Girls Freshman")
        ]),
        Sports(name: "Soccer", teams: [
            SportTeam(name: "Boys Varsity Soccer", category: "Boys Varsity"),
            SportTeam(name: "Girls Varsity Soccer", category: "Girls Varsity"),
            SportTeam(name: "Boys JV Soccer", category: "Boys JV"),
            SportTeam(name: "Girls JV Soccer", category: "Girls JV"),
            SportTeam(name: "Boys Freshman Soccer", category: "Boys Freshman"),
            SportTeam(name: "Girls Freshman Soccer", category: "Girls Freshman")
        ]),
        Sports(name: "Swimming", teams: [
            SportTeam(name: "Boys Varsity Swimming", category: "Boys Varsity"),
            SportTeam(name: "Girls Varsity Swimming", category: "Girls Varsity"),
            SportTeam(name: "Boys JV Swimming", category: "Boys JV"),
            SportTeam(name: "Girls JV Swimming", category: "Girls JV")
        ]),
        Sports(name: "Track & Field", teams: [
            SportTeam(name: "Boys Varsity Track", category: "Boys Varsity"),
            SportTeam(name: "Girls Varsity Track", category: "Girls Varsity"),
            SportTeam(name: "Boys JV Track", category: "Boys JV"),
            SportTeam(name: "Girls JV Track", category: "Girls JV")
        ]),
        Sports(name: "Baseball", teams: [
            SportTeam(name: "Boys Varsity Baseball", category: "Boys Varsity"),
            SportTeam(name: "Boys JV Baseball", category: "Boys JV"),
            SportTeam(name: "Boys Freshman Baseball", category: "Boys Freshman")
        ]),
        Sports(name: "Softball", teams: [
            SportTeam(name: "Girls Varsity Softball", category: "Girls Varsity"),
            SportTeam(name: "Girls JV Softball", category: "Girls JV"),
            SportTeam(name: "Girls Freshman Softball", category: "Girls Freshman")
        ]),
        Sports(name: "Volleyball", teams: [
            SportTeam(name: "Boys Varsity Volleyball", category: "Boys Varsity"),
            SportTeam(name: "Girls Varsity Volleyball", category: "Girls Varsity"),
            SportTeam(name: "Boys JV Volleyball", category: "Boys JV"),
            SportTeam(name: "Girls JV Volleyball", category: "Girls JV")
        ])
    ]
}
    
struct TeamsView: View {
    let allTeams = ["Tennis", "Golf", "Lacrosse", "Softball", "Baseball", "Crew", "Other"]//mine
    
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16){
                //Title
                Text("Teams")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, -6)
                
                //search bar
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Search", text: $searchText)
                                        .disableAutocorrection(true)
                                }
                                .padding(8)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(8)
                
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredTeams, id: \.self) { team in
                            ZStack {
                                // Rounded black border
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 1)
                                    .overlay(alignment:.trailing){
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 16)
                                    }
                                
                                // Row content
                                HStack() {
                                    Text(team)
                                        .foregroundColor(.primary)
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                            }
                        }
                    }
                    .padding(.top, 4)
                }
                
                
                
                
                ZStack(alignment:.topLeading){
                    List(searchResults) { sport in
                        NavigationLink(destination: SportView(sport: sport)) {
                            Text(sport.name)
                                .padding(10) // Add padding inside the row
                                .frame(maxWidth: .infinity, alignment: .leading) // Make the row fill the width
                                .background(.thinMaterial) // Set a custom background color
                                .cornerRadius(20) // Round the corners
                                .foregroundColor(.primary) // Set text color
                                .font(.headline) // Customize font
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 1) // Add a border
                                )
                                .shadow(color: .whiteNBlack.opacity(0.4), radius: 5, x: 0, y: 2) // Add a shadow
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .tint(.black)
                        .listRowSeparator(.hidden)
                    }
                    .searchable(text: $searchText)
                }
                .background(.clear)
            }
            .padding(.horizontal)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(.clear)
            .toolbar(.hidden)
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
        }
    }
    
    var searchResults: [Sports] {
        if searchText.isEmpty {
            return MockMeets.sportsData
        } else {
            return MockMeets.sportsData.filter { $0.name.contains(searchText) }
        }
    }
    
    
    
    // Filter teams by search text
    private var filteredTeams: [String] {//mine
        let lower = searchText.lowercased()
        if lower.isEmpty { return allTeams }
        return allTeams.filter { $0.lowercased().contains(lower) }
    }
}
    
struct SportView: View {
    let sport: Sports
    @State private var searchText = ""
    var body: some View {
        
        List(searchResults) { team in
            NavigationLink(destination: TeamDetailView(team: team)) {
                Text(team.name)
                    .padding() // Add padding inside the row
                    .frame(maxWidth: .infinity, alignment: .leading) // Make the row fill the width
                    .background(.thinMaterial) // Set a custom background color
                    .cornerRadius(20) // Round the corners
                    .foregroundColor(.primary) // Set text color
                    .font(.headline) // Customize font
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 1) // Add a border
                    )
                    .shadow(color: .whiteNBlack.opacity(0.4), radius: 5, x: 0, y: 2) // Add a shadow
                    .foregroundColor(.black)
                    .font(.headline)
                
            }
            .tint(.black)
            .listRowSeparator(.hidden)
            
        }
        .searchable(text: $searchText)
        .navigationTitle(sport.name)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        
        
    }
    var searchResults: [SportTeam] {
        if searchText.isEmpty {
            return sport.teams
        } else {
            return sport.teams.filter { $0.name.contains(searchText) }
        }
    }
}
    
struct TeamDetailView: View {
    let team: SportTeam
    
    var body: some View {
        VStack {
            Text(team.name)
                .font(.title)
            Text("Category: \(team.category)")
                .font(.subheadline)
            // Add more details about the team here
        }
    }
}
    
    
    
    
    //struct TeamsView: View {
    //    // Search text state
    //    @State private var searchText = ""
    //
    //    // Sample list of teams
    //    let allTeams = ["Tennis", "Golf", "Lacrosse", "Softball", "Baseball", "Crew", "Other"]
    //
    //    var body: some View {
    //        NavigationView {
    //            VStack(alignment: .leading, spacing: 16) {
    //
    //                // Large title
    //                Text("Teams")
    //                    .font(.title)
    //                    .fontWeight(.bold)
    //                    .padding(.top, -6)
    //
    //                // Search bar
    //                HStack {
    //                    Image(systemName: "magnifyingglass")
    //                        .foregroundColor(.gray)
    //                    TextField("Search", text: $searchText)
    //                        .disableAutocorrection(true)
    //                }
    //                .padding(8)
    //                .background(Color.gray.opacity(0.15))
    //                .cornerRadius(8)
    //
    //                // Scrollable list of teams
    //                ScrollView {
    //                    VStack(spacing: 10) {
    //                        ForEach(filteredTeams, id: \.self) { team in
    //                            ZStack {
    //                                // Rounded black border
    //                                RoundedRectangle(cornerRadius: 12)
    //                                    .stroke(Color.black, lineWidth: 1)
    //
    //                                // Row content
    //                                HStack {
    //                                    Text(team)
    //                                        .foregroundColor(.primary)
    //                                        .padding(.leading, 16)
    //
    //                                    Spacer()
    //
    //                                    Image(systemName: "chevron.right")
    //                                        .foregroundColor(.gray)
    //                                        .padding(.trailing, 16)
    //                                }
    //                                .padding(.vertical, 12)
    //                            }
    //                        }
    //                    }
    //                    .padding(.top, 4)
    //                }
    //
    //                Spacer(minLength: 0)
    //            }
    //            .padding(.horizontal)
    //        }
    //    }
    //
    //    // Filter teams by search text
    //    private var filteredTeams: [String] {
    //        let lower = searchText.lowercased()
    //        if lower.isEmpty { return allTeams }
    //        return allTeams.filter { $0.lowercased().contains(lower) }
    //    }
    //}
    
    // MARK: - SCORES PAGE
    
struct ScoresView: View{
    let completedGames: [CompletedGame] = [
        CompletedGame(
            league: "ISL",
            dateTime: "Sun. 01/12 4:30pm",
            team1: "Girls V Crew",
            team2: "Rivers Academy",
            finalScore: "1-3 Loss",
            didWin: false
        ),
        CompletedGame(
            league: "Friendlies",
            dateTime: "Wed. 01/15 3:30pm",
            team1: "Boys JV Soccer",
            team2: "Milton Academy",
            finalScore: "8-2 Win",
            didWin: true
        ),
        CompletedGame(
            league: "Friendlies",
            dateTime: "Wed. 01/15 3:30pm",
            team1: "Boys JV Soccer",
            team2: "Milton Academy",
            finalScore: "8-2 Win",
            didWin: true
        ),
        CompletedGame(
            league: "Friendlies",
            dateTime: "Wed. 01/15 3:30pm",
            team1: "Boys JV Soccer",
            team2: "Milton Academy",
            finalScore: "8-2 Win",
            didWin: true
        ),
        CompletedGame(
            league: "Friendlies",
            dateTime: "Wed. 01/15 3:30pm",
            team1: "Boys JV Soccer",
            team2: "Milton Academy",
            finalScore: "8-2 Win",
            didWin: true
        ),
        CompletedGame(
            league: "Friendlies",
            dateTime: "Wed. 01/15 3:30pm",
            team1: "Boys JV Soccer",
            team2: "Milton Academy",
            finalScore: "8-2 Win",
            didWin: true
        ),
        CompletedGame(
            league: "Friendlies",
            dateTime: "Wed. 01/15 3:30pm",
            team1: "Boys JV Soccer",
            team2: "Milton Academy",
            finalScore: "8-2 Win",
            didWin: true
        ),
        CompletedGame(
            league: "Friendlies",
            dateTime: "Wed. 01/15 3:30pm",
            team1: "Boys JV Soccer",
            team2: "Milton Academy",
            finalScore: "8-2 Win",
            didWin: true
        ),
        // ... add more
    ]
    
    let sportsFilters = ["Tennis", "Crew", "Hockey", "Squash", "Golf", "Soccer"]
    @State var selectedFilters: [String] = []
    @State var searching = false
    @State var searchText = ""
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                
//                 -- Big Title
                Text("Scores")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, -7)
//                
//                // -- Horizontal Filter
                HStack{
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack() {
                            if !(searching){
                                ForEach(sportsFilters, id: \.self) { sport in
                                    Button{
                                        if !selectedFilters.contains(sport){
                                            selectedFilters.append(sport)
                                        }
                                        else{
                                            selectedFilters.remove(at:selectedFilters.firstIndex(of: sport)!)
                                        }
                                        
                                    } label:{
                                        Text(sport)
                                            .font(.subheadline)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                            )
                                            .background(selectedFilters.contains(sport) ? .clearNGray : .clear)
                                            .foregroundStyle(selectedFilters.contains(sport) ? .black : .primary)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                        
                                    }
                                }
                            }
                        }
                    }
                    SearchingBar(searchText: $searchText, isSearching: $searching)
                }
                
                // -- Scrollable Scores Only
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredTeams) { game in
                            ScoreCardView(game: game)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        
    }
    var filteredTeams: [CompletedGame] {
        var filtered: [CompletedGame] = []
        let lowerSearch = searchText.lowercased()
        for filter in selectedFilters{
            filtered += completedGames.filter{$0.team1.lowercased().contains(filter.lowercased())}
        }
        if !(lowerSearch.isEmpty){
            filtered = completedGames.filter{$0.team1.lowercased().contains(lowerSearch)}
        }
        return (!(selectedFilters.isEmpty && searchText.isEmpty) ? filtered : completedGames)
    }
}
    
    // MARK: - Model
struct CompletedGame: Identifiable {
    let id = UUID()
    let league: String
    let dateTime: String
    let team1: String
    let team2: String
    let finalScore: String
    let didWin: Bool
}
    
    // MARK: - Card
struct ScoreCardView: View {
    let game: CompletedGame
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            
            HStack(alignment: .center, spacing: 16) {
                // LEFT COLUMN
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.league)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(game.team1)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(game.team2)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // RIGHT COLUMN
                VStack(alignment: .trailing, spacing: 8) {
                    Text(game.dateTime)
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    // Score bubble
                    Text(game.finalScore)
                        .fontWeight(.semibold)
                        .foregroundColor(game.didWin ? .green : .red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(game.didWin
                                      ? Color.green.opacity(0.15)
                                      : Color.red.opacity(0.15))
                        )
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
    
    // MARK: - Preview
    
struct SportsView_Previews: PreviewProvider {
    static var previews: some View {
        SportsView()
    }
}
    
struct SearchingBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    var body: some View{
        HStack{
            
            ZStack{
                if isSearching{
                    TextField("Search", text: $searchText)
                        .padding(.horizontal, 30)
                        .transition(.move(edge:.trailing))
                    
                }
                HStack{
                    RoundedRectangle(cornerRadius:16)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 0.4)
                        .frame(minWidth:34, maxWidth: isSearching ? .infinity : 34, maxHeight: 34)
                        .overlay(alignment: .trailing){
                            Button(action: {
                                withAnimation{
                                    if isSearching{
                                        searchText=""
                                    }
                                    isSearching.toggle()
                                    
                                }
                            }, label: {
                                Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                                    .tint(.gray)
                                    .padding(4)
                            })
                        }
                    
                    
                    
                    
                    
                    
                    //                                .foregroundColor(.gray)
                    //                                .padding(.vertical, 8)
                    //                                .padding(.horizontal, 12)
                    //                                .overlay(
                    //                                    RoundedRectangle(cornerRadius: 16)
                    //                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    //            }
                }
            }
        }
    }
}

