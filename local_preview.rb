require 'qtwebkit'
require_relative 'translation'

class Integer
  def to_filesize
    unit, size = [['megabytes', 1024 * 1024], ['kilobytes', 1024]].find { |_, s| self >= s } || ['bytes', 1]
    "#{self / size} #{Qt::Application.translate('Local_Preview', unit, nil, Qt::Application::UnicodeUTF8)}"
  end
end

class Local_Preview < Qt::Dialog
  include Translation

  def initialize(parent = nil, input)
    super(parent)    
    setWindowTitle(tr("Previewing %s...") % input)

    @vert = Qt::VBoxLayout.new

    @label = Qt::Label.new(tr("File size: %s") % File.size(input).to_filesize)
    puts "got file: #{input}"
    @web_view = Qt::WebView.new
    ## Files are saved as UTF-8; without a <meta charset> WebKit would assume Latin-1
    @web_view.settings.setDefaultTextEncoding("utf-8")
    @web_view.load(Qt::Url::fromUserInput(input))

    @vert.addWidget(@web_view)
    @vert.addWidget(@label)

    setLayout(@vert)
  end
end