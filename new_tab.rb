class New_Tab < Qt::PlainTextEdit
  
  ## Edit slots
  slots 'copy_text()', 'cut_text()', 'paste_text()', 'undo_text()', 'redo_text()'
  ## Insert slots
  slots 'bold()', 'italic()', 'underline()', 'link()', 'image()', 'ulist()', 'olist()' 
  ## General
  slots 'focus_current(int)'

  
  def initialize(parent = nil, open_file, tab_width)
    super(parent)
    @highlighter = HTML_Highlighter.new(document)

     unless open_file.nil?
      setPlainText(File.new(open_file).read)
    end
    
    setTabStopWidth(tab_width)
  end
 
  def bold
    self.insertPlainText("<b></b>")
    cursor = self.textCursor 
    pos = cursor.position
    cursor.setPosition(pos-4)
    self.setTextCursor(cursor)
  end
  
  def italic
    self.insertPlainText("<i></i>")
    cursor = self.textCursor 
    pos = cursor.position
    cursor.setPosition(pos-4)
    self.setTextCursor(cursor)
  end
 
  def underline
    self.insertPlainText("<u></u>")
    cursor = self.textCursor 
    pos = cursor.position
    cursor.setPosition(pos-4)
    self.setTextCursor(cursor)  
  end
  
  def image
    self.insertPlainText("<img src = ''/>")
    cursor = self.textCursor 
    pos = cursor.position
    cursor.setPosition(pos-6)
    self.setTextCursor(cursor)
  end
  
  def link
    self.insertPlainText("<a href = ''></a>")
    cursor = self.textCursor 
    pos = cursor.position
    cursor.setPosition(pos-4)
    self.setTextCursor(cursor)
  end
  
  def ulist
    self.insertPlainText("<ul>\n\t<li></li>\n</ul>\n")
    cursor = self.textCursor 
    pos = cursor.position
    cursor.setPosition(pos-12)
    self.setTextCursor(cursor)
  end
  
  def olist
    self.insertPlainText("<ol>\n\t<li></li>\n</ol>\n")
    cursor = self.textCursor 
    pos = cursor.position
    cursor.setPosition(pos-12)
    self.setTextCursor(cursor)
  end
  
  def focus_current(int); self.setFocus; end
end