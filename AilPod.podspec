#
# Be sure to run `pod lib lint AilPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AilPod'
  s.version          = '0.0.17'
  s.summary          = 'AilPod is a library making implementation of several ios regular features shorter and easier'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
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

AilPod is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AilPod"
```

## Authors

Wassa, ios Team, contact@wassa.fr

## License

AilPod is available under the MIT license. See the LICENSE file for more info.


                       DESC

  s.homepage         = 'https://bitbucket.org/johnatwassa/ailpod.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wassa' => 'contact@wassa.fr',
                         'Julien Brusseaux' => 'julien.brusseaux@wassa.fr'}
  s.source           = { :git => 'git@github.com:wassafr/AilPod.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/wassabemobile'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AilPod/Classes/**/*'

  s.dependency 'AFNetworking', '~> 3.0'

end

