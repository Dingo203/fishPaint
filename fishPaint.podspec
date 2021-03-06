Pod::Spec.new do |s|

  s.name         = "fishPaint"
  s.version      = "1.0.0"

  s.summary      = "A easy view for fish to paint"

  s.description  = <<-DESC
  					fishPaint provide swifty way to paint.
                   DESC

  s.homepage     = "https://github.com/Dingo203/fishPaint"
  s.license      = "MIT"
  s.author             = { "Dingo" => "477623503@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Dingo203/fishPaint.git", :tag => s.version }
  s.source_files  = "fishPaint/Class/*.{h,m,swift}"
  s.requires_arc = true

end
