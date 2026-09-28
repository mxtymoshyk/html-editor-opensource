require 'Qt4'

require_relative 'mainwindow_ui'
require_relative 'webpage_ui'
require_relative 'new_tab'
require_relative 'local_preview'
require_relative 'no_file_open'
require_relative 'about_program'
require_relative 'html_highlight'
require_relative 'settings'
require_relative 'translation'

class Start < Qt::MainWindow
  include Translation

  ## File submenu slots
  slots 'new_file()', 'open_file()', 'save_file()', 'save_as()'
  ## Edit submenu
  slots 'settings()'
  ## Tools submenu slots
  slots 'open_in_browser()', 'local_preview()'
  ## View submenu slots
  slots 'toggle_statusbar(bool)', 'toggle_toolbar(bool)'
  ## Help submenu slot
  slots 'about_program()', 'about_qt()'

  ## Edit and Insert slots, forwarded to the current tab
  TAB_ACTIONS = %w(copy cut paste undo redo bold italic underline image link ulist olist)
  TAB_ACTIONS.each { |action| slots "tab_#{action}()" }

  ## General slots
  slots 'remove_tab(int)', 'update_line_count()', 'current_tab_changed(int)', 'enable_save()'

  def initialize(parent = nil)
    super
    @ui = Ui_Editor.new
    @ui.setupUi(self)

    ## Connecting menu items
    Qt::Object.connect(@ui.menu_browser_preview, SIGNAL('triggered()'), self, SLOT('open_in_browser()'))
    Qt::Object.connect(@ui.menu_preview, SIGNAL('triggered()'), self, SLOT('local_preview()'))
    Qt::Object.connect(@ui.menu_settings, SIGNAL('triggered()'), self, SLOT('settings()'))
    Qt::Object.connect(@ui.menu_show_toolbar, SIGNAL('toggled(bool)'), self, SLOT('toggle_toolbar(bool)'))
    Qt::Object.connect(@ui.menu_show_statusbar, SIGNAL('toggled(bool)'), self, SLOT('toggle_statusbar(bool)'))
    Qt::Object.connect(@ui.menu_open_file, SIGNAL('triggered()'), self, SLOT('open_file()'))
    Qt::Object.connect(@ui.menu_save_file, SIGNAL('triggered()'), self, SLOT('save_file()'))
    Qt::Object.connect(@ui.menu_save_as, SIGNAL('triggered()'), self, SLOT('save_as()'))
    Qt::Object.connect(@ui.menu_new_file, SIGNAL('triggered()'), self, SLOT('new_file()'))
    Qt::Object.connect(@ui.menu_about_program, SIGNAL('triggered()'), self, SLOT('about_program()'))
    Qt::Object.connect(@ui.menu_about_qt, SIGNAL('triggered()'), self, SLOT('about_qt()'))
    Qt::Object.connect(@ui.menu_copy, SIGNAL('triggered()'), self, SLOT('tab_copy()'))
    Qt::Object.connect(@ui.menu_cut, SIGNAL('triggered()'), self, SLOT('tab_cut()'))
    Qt::Object.connect(@ui.menu_paste, SIGNAL('triggered()'), self, SLOT('tab_paste()'))
    Qt::Object.connect(@ui.menu_undo, SIGNAL('triggered()'), self, SLOT('tab_undo()'))
    Qt::Object.connect(@ui.menu_redo, SIGNAL('triggered()'), self, SLOT('tab_redo()'))
    Qt::Object.connect(@ui.menu_bold, SIGNAL('triggered()'), self, SLOT('tab_bold()'))
    Qt::Object.connect(@ui.menu_italic, SIGNAL('triggered()'), self, SLOT('tab_italic()'))
    Qt::Object.connect(@ui.menu_underline, SIGNAL('triggered()'), self, SLOT('tab_underline()'))
    Qt::Object.connect(@ui.menu_image, SIGNAL('triggered()'), self, SLOT('tab_image()'))
    Qt::Object.connect(@ui.menu_hyperlink, SIGNAL('triggered()'), self, SLOT('tab_link()'))
    Qt::Object.connect(@ui.menu_unordered, SIGNAL('triggered()'), self, SLOT('tab_ulist()'))
    Qt::Object.connect(@ui.menu_ordered, SIGNAL('triggered()'), self, SLOT('tab_olist()'))

    ## Connecting toolbar items
    Qt::Object.connect(@ui.toolbar_run, SIGNAL('triggered()'), self, SLOT('local_preview()'))
    Qt::Object.connect(@ui.toolbar_open_file, SIGNAL('triggered()'), self, SLOT('open_file()'))
    Qt::Object.connect(@ui.toolbar_save_file, SIGNAL('triggered()'), self, SLOT('save_file()'))
    Qt::Object.connect(@ui.toolbar_new_file, SIGNAL('triggered()'), self, SLOT('new_file()'))
    Qt::Object.connect(@ui.toolbar_settings, SIGNAL('triggered()'), self, SLOT('settings()'))
    Qt::Object.connect(@ui.toolbar_copy, SIGNAL('triggered()'), self, SLOT('tab_copy()'))
    Qt::Object.connect(@ui.toolbar_cut, SIGNAL('triggered()'), self, SLOT('tab_cut()'))
    Qt::Object.connect(@ui.toolbar_paste, SIGNAL('triggered()'), self, SLOT('tab_paste()'))
    Qt::Object.connect(@ui.toolbar_undo, SIGNAL('triggered()'), self, SLOT('tab_undo()'))
    Qt::Object.connect(@ui.toolbar_redo, SIGNAL('triggered()'), self, SLOT('tab_redo()'))
    Qt::Object.connect(@ui.toolbar_bold, SIGNAL('triggered()'), self, SLOT('tab_bold()'))
    Qt::Object.connect(@ui.toolbar_italic, SIGNAL('triggered()'), self, SLOT('tab_italic()'))
    Qt::Object.connect(@ui.toolbar_underline, SIGNAL('triggered()'), self, SLOT('tab_underline()'))
    Qt::Object.connect(@ui.toolbar_image, SIGNAL('triggered()'), self, SLOT('tab_image()'))
    Qt::Object.connect(@ui.toolbar_hyperlink, SIGNAL('triggered()'), self, SLOT('tab_link()'))
    Qt::Object.connect(@ui.toolbar_ulist, SIGNAL('triggered()'), self, SLOT('tab_ulist()'))
    Qt::Object.connect(@ui.toolbar_olist, SIGNAL('triggered()'), self, SLOT('tab_olist()'))

    ## Connecting command link buttons
    Qt::Object.connect(@ui.new_file_linkbutton, SIGNAL('clicked()'), self, SLOT('new_file()'))
    Qt::Object.connect(@ui.open_file_linkbutton, SIGNAL('clicked()'), self, SLOT('open_file()'))

    ## Set default behaviour
    @ui.no_file_widget.setVisible(true)
    @ui.toolBar.setMovable(false)
    @ui.tabWidget.setVisible(false)
    @ui.toolbar_save_file.setEnabled(false)
    @ui.toolbar_run.setEnabled(false)
    @ui.menu_show_toolbar.setChecked(true)
    @ui.menu_show_statusbar.setChecked(true)
    @current_file = ''
    @@tab_width = 2
    @tb_pos_int = 0 #=> Top toolbar position
    
    @line_label = Qt::Label.new(tr("Line: %d") % 0)    
    @column_label = Qt::Label.new(tr("Column: %d") % 0)    
    
    @ui.statusbar.addWidget(@line_label)
    @ui.statusbar.addWidget(@column_label)
    
    Qt::Object.connect(@ui.tabWidget, SIGNAL('tabCloseRequested(int)'), self, SLOT('remove_tab(int)'))
    Qt::Object.connect(@ui.tabWidget, SIGNAL('currentChanged(int)'), self, SLOT('current_tab_changed(int)'))
  end

  ## FILE SUBMENU SLOTS
  def new_file
    puts 'triggered new_file'
    add_tab(New_Tab.new(self, nil, @@tab_width*10), "untitled")
    @ui.toolbar_save_file.setEnabled(true)
  end

  def open_file
    puts 'triggered open_file'
    @open_file = Qt::FileDialog.getOpenFileName(self, tr("Open file"), Qt::Dir::homePath, tr("HTML Document(*.html);;All files(*)"))
    return if @open_file.nil?
    @current_file = @open_file

    (0...@ui.tabWidget.count).each do |i|
      if File.basename(@current_file) == @ui.tabWidget.tabText(i)
        @ui.tabWidget.setCurrentIndex(i)
        @ui.statusbar.showMessage(tr("File already loaded."), 2000)
        return
      end
    end

    add_tab(New_Tab.new(@open_file, @@tab_width*10), File.basename(@open_file))
    @ui.statusbar.showMessage(tr("File loaded."), 2000)
  end

  def save_file
    puts 'triggered save_file'
    return if @ui.tabWidget.currentWidget.nil?

    if @ui.tabWidget.tabText(@ui.tabWidget.currentIndex) == "untitled"
      save_as
    else
      write_current_tab
    end
  end

  def save_as
    puts 'triggered save_as'
    return if @ui.tabWidget.currentWidget.nil?

    @save_file = Qt::FileDialog.getSaveFileName(self, tr("Save"), Qt::Dir::homePath, tr("HTML Document(*.html);;All files(*)"))
    return if @save_file.nil?

    @current_file = @save_file
    @ui.tabWidget.setTabText(@ui.tabWidget.currentIndex, File.basename(@save_file))
    write_current_tab
  end

  ## EDIT SUBMENU SLOTS
  def settings
    puts 'settings triggered'
    @settings = Settings.new(self, @ui.toolBar.isVisible, @ui.statusbar.isVisible, @@tab_width, @tb_pos_int)

    if @settings.exec == Qt::Dialog::Accepted
      @ui.toolBar.setVisible(@settings.tb_enabled)
      @ui.statusbar.setVisible(@settings.st_enabled)
      @@tab_width = @settings.tab_w
      @tb_pos_int = @settings.tb_pos
      @tb_position = case @settings.tb_pos
      when 0
        Qt::TopToolBarArea
      when 1
        Qt::BottomToolBarArea
      when 2
        Qt::LeftToolBarArea
      when 3
        Qt::RightToolBarArea
      end

      addToolBar(@tb_position, @ui.toolBar)
      puts 'settings applied'
    end

  end

  ## TOOLS SUBMENU SLOTS
  def open_in_browser
    puts 'triggered open_in_browser'
    save_file

    ## Not cross-platform but solution :/
    system("xdg-open #{@current_file}")
  end

  def local_preview
    puts 'triggered local_preview'
    save_file()
    @web_page = Local_Preview.new(self, @current_file)
    @web_page.show
  end

  ## VIEW SUBMENU SLOTS
  def toggle_statusbar(bool)
    @ui.statusbar.setVisible(bool)
  end

  def toggle_toolbar(bool)
    @ui.toolBar.setVisible(bool)
  end

  ## HELP SUBMENU SLOTS
  def about_qt
    Qt::MessageBox::aboutQt(self)
  end

  def about_program
    puts 'triggered about_program'
    @about = About_Program.new(self)
    @about.show
  end

  ## GENERAL SLOTS
  def enable_save
    @ui.toolbar_save_file.setEnabled(true)
  end

  def remove_tab(int)
    @ui.tabWidget.removeTab(int)
    if @ui.tabWidget.count < 1
      @ui.toolbar_save_file.setEnabled(false)
      @ui.toolbar_run.setEnabled(false)
      @ui.no_file_widget.setVisible(true)
      @ui.tabWidget.setVisible(false)
      @no_file = NoFileOpen.new(self)
      @no_file.show
    end
    @line_label.setText(tr("Line: %d") % 0)
    @column_label.setText(tr("Column: %d") % 0)
    puts "deleted tab ##{int}"
  end

  def update_line_count
    puts 'triggered update line'
    @line_label.setText(tr("Line: %d") % (@ui.tabWidget.currentWidget.textCursor.blockNumber+1))
    @column_label.setText(tr("Column: %d") % (@ui.tabWidget.currentWidget.textCursor.columnNumber+1))
    @ui.statusbar.update
  end

  def current_tab_changed(int)
    return if int < 0

    @ui.tabWidget.widget(int).setFocus
    update_line_count
  end

  ## EDIT AND INSERT SLOTS
  TAB_ACTIONS.each do |action|
    define_method("tab_#{action}") do
      @ui.tabWidget.currentWidget.send(action) unless @ui.tabWidget.currentWidget.nil?
    end
  end

  private

  def add_tab(tab, title)
    Qt::Object.connect(tab, SIGNAL('cursorPositionChanged()'), self, SLOT('update_line_count()'))
    Qt::Object.connect(tab.document, SIGNAL('contentsChanged()'), self, SLOT('enable_save()'))

    @ui.tabWidget.setVisible(true)
    @ui.no_file_widget.setVisible(false)
    @ui.toolbar_run.setEnabled(true)

    index = @ui.tabWidget.addTab(tab, title)
    @ui.tabWidget.setCurrentIndex(index)
    tab.setFocus
  end

  def write_current_tab
    File.open(@current_file, 'w') { |file| file.write(@ui.tabWidget.currentWidget.toPlainText) }
    puts "file #{@current_file} saved"
    @ui.statusbar.showMessage(tr("File saved."), 2000)
    @ui.toolbar_save_file.setEnabled(false)
  end
end

if $0 == __FILE__
  app = Qt::Application.new(ARGV)

  ## Load translations for the system language, e.g. translations/pineapple_ru.qm
  locale = Qt::Locale::system.name
  qt_translator = Qt::Translator.new
  qt_translator.load("qt_" + locale, Qt::LibraryInfo::location(Qt::LibraryInfo::TranslationsPath))
  app.installTranslator(qt_translator)
  translator = Qt::Translator.new
  translator.load("pineapple_" + locale, File.join(__dir__, 'translations'))
  app.installTranslator(translator)

  myapp = Start.new
  myapp.show
  app.exec
end