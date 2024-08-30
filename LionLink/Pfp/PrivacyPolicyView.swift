import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("1. USE OF LINKS")
                    .font(.title2)
                    .bold()
                Text("Throughout our Web pages, we provide links to other servers which may contain information of interest to our readers. We take no responsibility for, and exercise no control over, the organizations, views, or accuracy of the information contained on other servers. Creating a text link from your Web site to our site does not require permission. If you have a link you’d like us to consider adding to our Web site, please send an email to csdevelopmentstmarks@gmail.com with the subject “Link request.”")
                
                Text("2. USE OF TEXT AND IMAGES")
                    .font(.title2)
                    .bold()
                Text("If you would like to publish information that you find on our Web site, please send your request to csdevelopmentstmarks@gmail.com. Where text or images are posted on our site with the permission of the original copyright holder, a copyright statement appears at the bottom of the page. Information about using our logo and images is available in Media Resources.")
                
                
                Text("3. ACCESSIBILITY")
                    .font(.title2)
                    .bold()
                Text("This Web site is designed to be accessible to visitors with disabilities, and to comply with federal guidelines concerning accessibility. We welcome your comments. If you have suggestions on how to make the site more accessible, please contact us at csdevelopmentstmarks@gmail.com.")
                
                Text("4.READING OR DOWNLOADING")
                    .font(.title2)
                    .bold()
                Text("We collect and store only the following information about you: the name of the domain from which you access the Internet, the date and time you access our site, and the Internet address of the Web site from which you linked to our site. We use the information we collect to measure the number of visitors to the different sections of our site, and to help us make our site more useful to visitors.")
                
                Text("5.ONLINE PROFILE UPDATES AND DONATIONS")
                    .font(.title2)
                    .bold()
                Text("If you complete the Profile update form and share your personally identifying information, this information will be used only to provide you with more targeted content. We may use your contact information to send further information about our St. Mark’s School or to contact you when necessary. You may always opt-out of receiving future mailings; see the “Opt Out” section below.")
                
                Text("6.SENDING US AN EMAIL")
                    .font(.title2)
                    .bold()
                Text("You also may decide to send us personally identifying information, for example, in an electronic mail message containing a question or comment, or by filling out a Web form that provides us this information. We use personally identifying information from email primarily to respond to your requests. We may forward your email to other employees who are better able to answer you questions. We may also use your email to contact you in the future about our programs that may be of interest. We want to be very clear: We will not obtain personally identifying information about you when you visit our site, unless you choose to provide such information to us. Providing such information is strictly voluntary. Except as might be required by law, we do not share any information we receive with any outside parties. If you sign up for one of our email lists, we will only send you the kinds of information you have requested. We won’t share your name or email address with any outside parties.")
                
                Text("7.OPT-OUT OR CHANGE YOUR CONTACT INFORMATION")
                    .font(.title2)
                    .bold()
                Text("Our site provides users the opportunity to opt-out of receiving communications from us through a special online form. You may choose to receive only specific communications or none at all. You may also update your contact information previously provided to us through another online form. You can not remove yourself from our database, but you can prevent unwanted communication.")
                
                Text("8.QUESTIONS ABOUT OUR POLICIES")
                    .font(.title2)
                    .bold()
                Text("If you have any questions about this privacy statement, the practices of this site, or your dealings with this Web site, you can contact us at: csdevelopmentstmarks@gmail.com.")
                
            }
            .padding()
        }
    }
}


//struct MyGroupsView: View {
//    @ObservedObject var viewModel: GroupViewModel
//    @State private var showingDetail = false
//    @State private var selectedGroup: Groups?
//
//    var body: some View {
//        List(viewModel.myGroups, id: \.id) { group in
//            ZStack(alignment: .bottomTrailing) {
//                GroupTile(group: group, viewModel: viewModel)
//                    .cornerRadius(10)
//                    .shadow(radius: 5)
//                    .padding(.top, 5)
//                    .onTapGesture {
//                        self.selectedGroup = group
//                        self.showingDetail = true
//                    }
//                
//                if viewModel.isUserAMember(of: group.id) {
//                    Button(action: {
//                        viewModel.leaveGroup(withId: group.id)
//                    }) {
//                        Image(systemName: "checkmark.circle.fill")
//                            .foregroundColor(.green)
//                            .font(.title2)
//                            .padding(20)
//                    }
//                }
//            }
//            .listRowBackground(Color.clear)
//            .frame(height: 200)
//        }
//        .navigationBarTitle("My Groups", displayMode: .inline)
//        .sheet(isPresented: $showingDetail) {
//            if let group = selectedGroup {
//                GroupDetailView(groupId: group.id, viewModel: viewModel)
//            }
//        }
//        .onAppear {
//            viewModel.fetchMyGroups()
//        }
//    }
//}
