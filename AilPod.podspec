#
# Be sure to run `pod lib lint AilPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                = 'AilPod'
  s.version             = '0.2.1'
  s.summary             = 'AilPod is a library making implementation of several ios regular features shorter and easier'

  s.description         = <<-DESC
# AilPod

[![Version](https://img.shields.io/cocoapods/v/AilPod.svg?style=flat)](http://cocoapods.org/pods/AilPod)
[![License](https://img.shields.io/cocoapods/l/AilPod.svg?style=flat)](http://cocoapods.org/pods/AilPod)
[![Platform](https://img.shields.io/cocoapods/p/AilPod.svg?style=flat)](http://cocoapods.org/pods/AilPod)

AilPod is a library making implementation of several ios regular features shorter and easier:
* AilNetworking: a tool to send and handle webrequests easily
* AilTableViewController: a shortcut for UITableViewController implementation
* AilCollectionViewController: a shortcut for UICollectionViewController implementation

AilPod also contains extensions designed to:
* Resize UIImage objects and encode them in webrequests
* Easily manipulate dates
* Manipulate email addresses and passwords
* Easily layout images in UIButton objects
* Initialize UIColor objects from hexadecimal strings
* Change the placeholder color of a UITextField object
* Access border and corner information of a UIVIew

Tips:
This pod add behavior on the storyboard. If XCode keeps building, don't hesitate to deactivate the "Automatically Refresh Views" on the "Editor Menu".

If you have any question about the project, don't hesitate to open an issue on github.

[Learn more](https://medium.com/wassa/developing-our-own-framework-the-ailpod-80000ed2ef7f)

## Environment
* Xcode 9.1
* Swift 4.0
* iOS 9.0

## Installation

AilPod is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "AilPod"
```

## Authors

Wassa, iOS Team, contact@wassa.fr

## License

AilPod is available under the MIT license. See the LICENSE file for more info.


                       DESC

  s.homepage                = 'https://github.com/wassafr/AilPod'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'Wassa' => 'contact@wassa.fr'}
  s.source                  = { :git => 'https://github.com/wassafr/AilPod.git', :tag => s.version.to_s }
  s.social_media_url        = 'https://twitter.com/wassabemobile'

  s.ios.deployment_target   = '9.0'
  s.swift_version           = '4.2'

  s.default_subspec         = 'Core'

  s.subspec 'Core' do |core|
    core.source_files           = 'AilPod/Classes/Core/**/*'
  end

  s.subspec 'AilCollectionView' do |collection|
    collection.source_files     = 'AilPod/Classes/AilCollectionView/**/*'
    collection.dependency       'AilPod/Core'
  end

  s.subspec 'AilPickers' do |collection|
    collection.source_files     = 'AilPod/Classes/AilPickers/**/*'
  end

  s.subspec 'Design' do |design|
    design.source_files         = 'AilPod/Classes/Design/**/*'
  end

  s.subspec 'NetworkingAFNetworking' do |n|
    n.source_files              = 'AilPod/Classes/NetworkingAFNetworking/**/*'
    n.dependency                'AFNetworking'
    n.dependency                'AilPod/Core'
  end
  
  s.subspec 'NetworkingAlamofire' do |n|
    n.source_files              = 'AilPod/Classes/NetworkingAlamofire/**/*'
    n.dependency                'Alamofire'
    n.dependency                'AilPod/Core'
  end


end

