# Pineapple Editor OpenSource

A lightweight, cross-platform HTML editor built with Ruby and Qt4. This graphical application provides an intuitive interface for creating and editing HTML files with features like syntax highlighting, live preview, and tabbed editing.

## Purpose

Pineapple Editor addresses the need for a simple, focused HTML editing tool that balances functionality with ease of use. Unlike heavyweight IDEs or basic text editors, it offers HTML-specific features (syntax highlighting, tag insertion, preview) in a clean, distraction-free interface suitable for quick HTML editing tasks, learning HTML, or lightweight web development.

## Project Structure

```
html-editor-opensource/
├── start.rb                 # Main application entry point and controller
├── new_tab.rb               # Text editor widget for tab-based editing
├── settings.rb              # Settings dialog for preferences
├── html_highlight.rb        # HTML syntax highlighter
├── about_program.rb         # About dialog
├── local_preview.rb         # HTML preview window
├── no_file_open.rb          # Welcome screen widget
├── mainwindow.ui            # Qt Designer main window layout
├── webpage.ui               # Qt Designer preview window layout
├── toolbar.qrc              # Qt resource file for toolbar icons
├── Rakefile                 # Build automation tasks
├── images/
│   ├── logo.png             # Application logo
│   ├── pineapple-logo.jpeg  # Pineapple branding
│   └── toolbar/             # Toolbar icons (22 icons)
│       ├── copy.png, cut.png, paste.png
│       ├── undo.png, redo.png
│       ├── document.png, folder.png, save.png
│       ├── font_bold.png, font_italic.png, font_underline.png
│       ├── image.png, link.png
│       ├── ulist.png, olist.png
│       └── setting.png, wrench.png
├── README.md
└── LICENSE
```

## Requirements

### Runtime Dependencies

- **Ruby** (2.0+)
- **Qt4** libraries
- **qtruby4** - Ruby bindings for Qt4
- **QtWebKit** - For HTML preview functionality
- **xdg-utils** - For opening files in system browser (Linux)

### Build Dependencies

- **rbuic4** - Qt Designer UI compiler for Ruby
- **rake** - Ruby build tool

### Installation on Debian/Ubuntu

```bash
sudo apt-get install ruby qt4-dev-tools libqt4-ruby1.8 libqtwebkit-dev rake
```

### Installation on Fedora

```bash
sudo dnf install ruby qt4-devel ruby-qt4 qtwebkit-devel rubygem-rake
```

### Installation on Arch Linux

```bash
sudo pacman -S ruby qt4 qtwebkit
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/html-editor-opensource.git
cd html-editor-opensource
```

2. Compile the Qt UI files:
```bash
rake build
```

3. Run the application:
```bash
ruby start.rb
```

Or use the combined build and launch command:
```bash
rake
```

## Usage

### Starting the Application

```bash
ruby start.rb
```

Or:

```bash
rake launch
```

### Basic Operations

**Creating a New File:**
- Menu: File > New
- Keyboard: Click "New file" button on welcome screen
- Creates a new "untitled" tab

**Opening an Existing File:**
- Menu: File > Open
- Displays file dialog to select HTML files
- Opened files appear in new tabs

**Saving Files:**
- Menu: File > Save
- New files prompt for filename via Save As dialog
- Existing files are overwritten in place

### HTML Tag Insertion

Insert common HTML tags via the Insert menu or toolbar:

| Feature | Menu Path | Result |
|---------|-----------|--------|
| Bold | Insert > Bold | `<b></b>` (cursor positioned inside) |
| Italic | Insert > Italic | `<i></i>` |
| Underline | Insert > Underline | `<u></u>` |
| Image | Insert > Image | `<img src=''/>` |
| Link | Insert > Link | `<a href=''></a>` |
| Unordered List | Insert > Unordered List | `<ul><li></li></ul>` |
| Ordered List | Insert > Ordered List | `<ol><li></li></ol>` |

### Preview Options

**Local Preview:**
- Menu: Tools > Local preview
- Opens HTML rendering in embedded WebKit window
- Displays file size information

**Browser Preview:**
- Menu: Tools > Browser preview
- Opens current file in system default browser

### Example Workflow

1. Launch the application:
```bash
ruby start.rb
```

2. Create a new file (File > New)

3. Type HTML content:
```html
<!DOCTYPE html>
<html>
<head>
    <title>My Page</title>
</head>
<body>
    <h1>Hello World</h1>
    <p>This is my first page.</p>
</body>
</html>
```

4. Save the file (File > Save) as `mypage.html`

5. Preview in browser (Tools > Browser preview)

## Implementation Details

### Architecture

The application follows a Model-View-Controller pattern adapted for Qt:

- **Controller**: `Start` class manages application logic and signal/slot connections
- **Views**: `New_Tab` (editor), `Local_Preview` (preview), `Settings` (preferences)
- **Signals/Slots**: Qt's event system connects UI elements to handler methods

### Syntax Highlighting

The `HTML_Highlighter` class provides real-time syntax coloring using regex patterns:

- **Tags**: `<html>`, `<body>`, `<head>`, `<title>`, `<h1>`-`<h6>`, `<br>`, `<ul>`, `<ol>`, `<li>`, etc.
- **DOCTYPE**: `<!DOCTYPE>` declarations
- **Comments**: `<!-- ... -->`
- **Attributes**: Quoted string values

Color scheme: dark cyan for tags, cyan for short tags, gray for comments, green for strings.

### Tab Management

- Multiple files can be opened simultaneously in tabs
- Duplicate file detection prevents opening the same file twice
- Unsaved changes tracked per tab
- Dynamic signal/slot connection when switching tabs

### Settings Persistence

Configurable options via Settings dialog:
- Toolbar visibility and position (top/bottom/left/right)
- Status bar visibility
- Tab width (minimum 2 spaces)

## Class/Function Reference

### Classes

| Class | File | Description |
|-------|------|-------------|
| `Start` | start.rb | Main application window and controller |
| `New_Tab` | new_tab.rb | Plain text editor widget with HTML helpers |
| `Settings` | settings.rb | Preferences dialog |
| `HTML_Highlighter` | html_highlight.rb | Syntax highlighting engine |
| `Local_Preview` | local_preview.rb | WebKit-based HTML preview window |
| `About_Program` | about_program.rb | Application information dialog |
| `NoFileOpen` | no_file_open.rb | Welcome screen shown when no files open |

### Key Methods (Start class)

| Method | Description |
|--------|-------------|
| `new_file()` | Creates a new empty tab |
| `open_file()` | Opens file dialog and loads selected file |
| `save_file()` | Saves current tab content to file |
| `save_as()` | Prompts for filename and saves |
| `open_in_browser()` | Opens current file in system browser |
| `local_preview()` | Shows HTML preview in embedded window |
| `settings()` | Opens settings dialog |
| `remove_tab(int)` | Closes specified tab |
| `update_line_count()` | Updates cursor position in status bar |
| `toggle_toolbar(bool)` | Shows/hides toolbar |
| `toggle_statusbar(bool)` | Shows/hides status bar |

### Key Methods (New_Tab class)

| Method | Description |
|--------|-------------|
| `bold()` | Inserts `<b></b>` tags |
| `italic()` | Inserts `<i></i>` tags |
| `underline()` | Inserts `<u></u>` tags |
| `link()` | Inserts `<a href=''></a>` tags |
| `image()` | Inserts `<img src=''/>` tag |
| `ulist()` | Inserts unordered list structure |
| `olist()` | Inserts ordered list structure |

## Build Tasks

| Command | Description |
|---------|-------------|
| `rake` | Build UI files and launch application |
| `rake build` | Compile .ui files to Ruby classes |
| `rake launch` | Build and run the application |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
