require_relative 'translation'

class Settings < Qt::Dialog
	include Translation

	slots  'accepted()', 'rejected()', 'disable_tb(int)'
	
	attr_reader :tb_enabled, :tb_pos, :st_enabled, :tab_w

	def initialize(parent = nil, tb_state, st_state, tab_w_state, tb_pos_state)
		super(parent)

		## Default behaviour
		setModal(true)

		## Toolbar enable layout
		@hbox1 = Qt::HBoxLayout.new
		@toolbar_enabled = Qt::Label.new(tr("Enabled:"))
		@toolbar_checkbox = Qt::CheckBox.new
		
		@toolbar_checkbox.setChecked(tb_state)
		Qt::Object.connect(@toolbar_checkbox, SIGNAL('stateChanged(int)'), self, SLOT('disable_tb(int)') )
		
		@hbox1.addWidget(@toolbar_enabled)
		@hbox1.addWidget(@toolbar_checkbox)

		## Toolbar position layout
		@hbox2 = Qt::HBoxLayout.new
		@toolbar_position = Qt::Label.new(tr("Position:"))
		@toolbar_combobox = Qt::ComboBox.new

		@toolbar_combobox.addItem(tr('Top'))
		@toolbar_combobox.addItem(tr('Bottom'))
		@toolbar_combobox.addItem(tr('Left'))
		@toolbar_combobox.addItem(tr('Right'))
		
		@hbox2.addWidget(@toolbar_position)
		@hbox2.addWidget(@toolbar_combobox)

		puts "tb pos state #{tb_pos_state}"
		@toolbar_combobox.setCurrentIndex(tb_pos_state)

		## Layout to add to groupbox
		@toolbar_layout = Qt::VBoxLayout.new
		@toolbar_layout.addLayout(@hbox1)
		@toolbar_layout.addLayout(@hbox2)

		## Toolbar section
		@toolbar_groupbox = Qt::GroupBox.new(tr("Toolbar"))
		@toolbar_groupbox.setLayout(@toolbar_layout)
		
		## Statusbar enable layout		
		@hbox3 = Qt::HBoxLayout.new		
		@st_label = Qt::Label.new(tr("Enabled:"))
		@st_checkbox = Qt::CheckBox.new	
		
		@st_checkbox.setChecked(st_state)

		@hbox3.addWidget(@st_label)
		@hbox3.addWidget(@st_checkbox)

		## Statusbar section
		@st_groupbox = Qt::GroupBox.new(tr("Statusbar"))
		@st_groupbox.setLayout(@hbox3)

		## Tab width layout
		@hbox4 = Qt::HBoxLayout.new
		@editor_label = Qt::Label.new(tr("Tab width:"))
		@tab_spinbox = Qt::SpinBox.new

		@tab_spinbox.setMinimum(2)
		@tab_spinbox.setValue(tab_w_state)
		puts "tab_w_state #{tab_w_state}"

		@hbox4.addWidget(@editor_label)
		@hbox4.addWidget(@tab_spinbox)

		## Editor section
		@editor_groupbox = Qt::GroupBox.new(tr("Editor"))
		@editor_groupbox.setLayout(@hbox4)
		
		## Buttons section
		@apply_button = Qt::PushButton.new(tr('Apply'))
		@cancel_button = Qt::PushButton.new(tr('Cancel'))
		Qt::Object.connect(@cancel_button, SIGNAL('clicked()'), self, SLOT('rejected()'))
		Qt::Object.connect(@apply_button, SIGNAL('clicked()'), self, SLOT('accepted()'))

		@buttonBox = Qt::DialogButtonBox.new(Qt::Horizontal)
		@buttonBox.addButton(@apply_button, Qt::DialogButtonBox::AcceptRole)
		@buttonBox.addButton(@cancel_button, Qt::DialogButtonBox::RejectRole)

		## Parent layout
		@window = Qt::VBoxLayout.new
		@window.addWidget(@toolbar_groupbox)
		@window.addWidget(@st_groupbox)
		@window.addWidget(@editor_groupbox)
		@window.addWidget(@buttonBox)
		setLayout(@window)
	end

	def accepted
		@tb_enabled = @toolbar_checkbox.isChecked
		@tb_pos = @toolbar_combobox.currentIndex
		@st_enabled = @st_checkbox.isChecked
		@tab_w = @tab_spinbox.value
		self.accept 		
	end

	def rejected; self.reject; end

	def disable_tb(int)
		int == Qt::Checked ? @toolbar_combobox.setEnabled(true) : @toolbar_combobox.setEnabled(false)	
	end
end