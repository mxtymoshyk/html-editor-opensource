require_relative 'translation'

class About_Program < Qt::Dialog
	include Translation

	def initialize(parent = nil)
		super(parent)
		setModal(true)

		@horizontal = Qt::HBoxLayout.new
		@vertical = Qt::VBoxLayout.new
		
		@logo = Qt::Label.new
		@logo.pixmap = Qt::Pixmap.new(":/images/logo.png")
		
		@name = Qt::Label.new("Pineapple Editor openSource")
		@name.setFont(Qt::Font.new("Arial", 18))
		@name.setAlignment(Qt::AlignHCenter)
		
		@description = Qt::Label.new
		@description.setText(tr("Lightweight Qt-based HTML editor."))
		@description.setAlignment(Qt::AlignHCenter)

		@copyright = Qt::Label.new
		@copyright.setText("Copyright (c) 2014 <a href=\"https://github.com/maximillian2/\">Maksym Tymoshyk</a>")
		@copyright.setTextFormat(Qt::RichText)
		@copyright.setTextInteractionFlags(Qt::TextBrowserInteraction)
		@copyright.setOpenExternalLinks(true)
		@copyright.setAlignment(Qt::AlignHCenter)
		
		@vertical.addWidget(@name)
		@vertical.addWidget(@description)
		@vertical.addWidget(@copyright)

		@horizontal.addWidget(@logo)
		@horizontal.addLayout(@vertical)			
		setLayout(@horizontal)
	end
end