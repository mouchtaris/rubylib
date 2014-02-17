module IndentedPrinter

  def initialize
    super
    @indented_printer_nesting = 0
    @newline = true
  end

  def print *args
    @out.<<('    ' * @indented_printer_nesting) if @newline
    @newline = false
    @out.<<(*args) unless args.empty?
  end

  def puts *args
    print *args
    print "\n"
    @newline = true
  end

  def keep_indent
    @indented_printer_nesting -= 1
    yield
    @indented_printer_nesting += 1
  end

  def indent
    @indented_printer_nesting += 1
    yield
    @indented_printer_nesting -= 1
  end

end#module IndentedPrinter