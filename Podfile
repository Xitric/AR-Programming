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

# All credit goes to Tracy Keeling (icecrystal23) for providing this fix to a bug in Xcode 10.1
# See: https://github.com/CocoaPods/CocoaPods/issues/8139
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # This works around a unit test issue introduced in Xcode 10.
            # We only apply it to the Debug configuration to avoid bloating the app size
            if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
                config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
            end
        end
    end
end
