require_relative 'translation'

class NoFileOpen < Qt::Widget
  include Translation

  def initialize(parent = nil)
    super(parent)
    
    @label = Qt::Label.new(tr("No files open"))
    @label.setAlignment(Qt::AlignHCenter)
    @new_file_linkbutton = Qt::CommandLinkButton.new(tr("New file"), tr("Create a new empty file."))
    @open_file_linkbutton = Qt::CommandLinkButton.new(tr("Open file"), tr("Open a saved file."))
    
    self.layout = Qt::VBoxLayout.new do |m|
        m.addWidget(@label)
        m.addWidget(@new_file_linkbutton)
        m.addWidget(@open_file_linkbutton)
    end
  end
end