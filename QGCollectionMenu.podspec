Pod::Spec.new do |s|
  s.name     = 'QGCollectionMenu'
  s.version  = '0.1.1'
  s.platform = :ios, '7.0'
  s.license  = 'MIT'
  s.summary  = 'some menus in a horizontally collection '
  s.homepage = 'https://github.com/QuanGe/QGCollectionMenu'
  s.author   = { 'QuanGe' => 'zhang_ru_quan@163.com' }
  s.source   = { :git => 'https://github.com/QuanGe/QGCollectionMenu.git', :tag => s.version.to_s }

  s.description = 'some menus in a horizontally collection ' 

  s.frameworks   = 'QuartzCore'
  s.source_files = 'QGCollectionMenu/*.{h,m,xib}'
  s.preserve_paths  = 'Demo'
  s.requires_arc = true
end
