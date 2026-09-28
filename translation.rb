## Looks up text in the installed translations, using the class name as
## context (the same call rbuic4 generates for .ui strings)
module Translation
  def tr(text)
    Qt::Application.translate(self.class.name, text, nil, Qt::Application::UnicodeUTF8)
  end
end
