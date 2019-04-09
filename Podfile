# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

workspace 'ARProgramming'

# Shared dependency injection framework
def swinject
    pod 'Swinject', '~> 2.6'
end

target 'ARProgramming' do
  project 'ARProgramming/ARProgramming'
  use_frameworks!
  
  # Pods for ARProgramming
  swinject
  pod 'SwinjectStoryboard', '~> 2.2'
  pod 'AudioKit', '~> 4.5'
  
  target 'ARProgrammingTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'ProgramModel' do
    project 'ProgramModel/ProgramModel'
    use_frameworks!
    
    # Pods for ProgramModel
    swinject
    
    target 'ProgramModelTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end

target 'Level' do
    project 'Level/Level'
    use_frameworks!
    
    # Pods for Level
    swinject
    
    target 'LevelTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end

target 'EntityComponentSystem' do
    project 'EntityComponentSystem/EntityComponentSystem'
    use_frameworks!
    
    # Pods for EntityComponentSystem
    swinject
    
    target 'EntityComponentSystemTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end
