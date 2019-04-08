# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

workspace 'ARProgramming'

target 'ARProgramming' do
  project 'ARProgramming/ARProgramming'
  use_frameworks!
  
  # Pods for ARProgramming
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
    
    target 'ProgramModelTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end

target 'EntityComponentSystem' do
    project 'EntityComponentSystem/EntityComponentSystem'
    use_frameworks!
    
    # Pods for EntityComponentSystem
    
    target 'EntityComponentSystemTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end
