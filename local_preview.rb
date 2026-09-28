require 'qtwebkit'
require_relative 'translation'

class Integer
  def to_filesize
    {
      'bytes'  => 1024,
      'kilobytes' => 1024 * 1024,
      'megabytes' => 1024 * 1024 * 1024,
    }.each_pair { |e, s| return "#{s / self} #{Qt::Application.translate('Local_Preview', e, nil, Qt::Application::UnicodeUTF8)}" if self < s && self != 0 } ## FIXME if self < 0 crush
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
    @web_view.load(Qt::Url::fromUserInput(input))

    @vert.addWidget(@web_view)
    @vert.addWidget(@label)

    setLayout(@vert)
  end
end