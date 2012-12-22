#Team Solo Mid
#Counter Logic Gaming
#Dignitas < not on current
#Azure G4ming

def is_eligible(team_name)
  return nil if !team_name.is_a?(String)
  array = Array.new
  array << "Counter Logic Gaming" << "Team Solo Mid" << "Azure G4ming"
  #IneligibleTeams = ["Counter Logic Gaming", "Team Solo Mid", "Azure G4ming"]
  #ineligible_teams = ["Counter Logic Gaming", "Team Solo Mid", "Azure G4ming"]
  if array.include?(team_name)
  #if ineligible_teams.include?(team_name)
    false
  else
    true
  end
end

class Team

end