
import Foundation

final class BadgeModel: ObservableObject{
    @Published var openDetailSheet = false
    @Published var tappedId = ""
    @Published var completed = false
    @Published var com = 0
    @Published var completedDate = ""
    @Published var badges = [BadgesInfo(badge_id: "", badge_name: "", badge_photo: "", is_completed: false, date_completed: "", completion: 0)]
    @Published var badgeSel = BadgesInfoDetailed(name: "", description: "", badge_requirement_threshold: 0, badge_photo: "")
    
    
    
    func openBadge(badge: BadgesInfo){
        tappedId = badge.badge_id
        com = badge.completion
        completed = badge.is_completed
        openDetailSheet = true
        completedDate = formattedDate(badge.date_completed)
    }
    
    
    func fetchSingleBadge(api: ApiManager, id: String){
        api.getSpecificBadge(badgeId: id) { resp in
            switch resp {
            case .success(let arr):
                self.badgeSel = arr
            case .failure(let error):
                print("Failed to load badges: \(error)")
            }
        }
    }
    
    
    func getBadges(api : ApiManager, tabBarSelection : TabBarSelection ){
        api.getBadges { resp in
            switch resp {
            case .success(let arr):
                self.badges = arr
                if tabBarSelection.selectedBadge != "" {
                    let selected = self.badges.first { $0.badge_name ==  tabBarSelection.selectedBadge }
                    self.tappedId = selected!.badge_id
                    self.com = selected!.completion
                    self.completed = selected!.is_completed
                    self.openDetailSheet = true
                    self.completedDate = formattedDate(selected?.date_completed)
                    tabBarSelection.selectedBadge = ""
                  
                }
            case .failure(let error):
                print("Failed to load badges: \(error)")
            }
        }
    }
}
