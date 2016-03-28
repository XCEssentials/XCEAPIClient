Pod::Spec.new do |s|

  s.name                      = 'MKHCustomAPI'
  s.version                   = '1.0.1'
  s.summary                   = 'Tiny extension for NSURLSession that enables synchronous task execution written in Swift.'
  s.homepage                  = 'https://github.com/maximkhatskevich/#{s.name}'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }
  s.ios.deployment_target     = '8.0'
  s.source                    = { :git => '#{s.homepage}.git', :tag => '#{s.version}' }
  s.ios.source_files          = 'Src/*.swift'
  s.requires_arc              = true
  s.social_media_url          = 'http://www.linkedin.com/in/maximkhatskevich'

  s.dependency 'MKHSyncSession', '~> 1.0'

end
