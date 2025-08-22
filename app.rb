require 'tty-prompt'

def management
  prompt = TTY::Prompt.new

  prompt.on(:keypress) do |event|
    case event.value
      when 'q' then exit
    end
    
    case event.key.name
      when :up then puts "Вверх"
      when :down then puts "Вниз"
      when :left then puts "Влево"
      when :right then puts "Вправо"
    end
  end
  prompt.read_keypress == 'q' ? "Конец игры" : prompt.read_keypress
end

class Field
  attr_accessor :y, :x, :field

  def initialize
    @y = 12 #количество столбцов 
    @x = 12 #количество строк
    size_field
  end

  def size_field#размер поля, состоящий из массива
    @field = Array.new(@y){|i| Array.new(@x){" "}}
  end

def field_boundary
  # Верхняя и нижняя границы
  0.upto(@y - 1) { |j| @field[0][j] = "-" }       # первая строка
  0.upto(@y - 1) { |j| @field[@x - 1][j] = "-" }  # последняя строка

  # Левая и правая границы
  1.upto(@x - 2) { |i| @field[i][0] = "|" }       # первый столбец
  1.upto(@x - 2) { |i| @field[i][@y - 1] = "|" }  # последний столбец
end

  def render #отрисовываем поле
    puts "\e[H\e[2J" #очищаем экран
    @field.each do |y|
      y.each do |x|
        print x
      end
      puts
    end
  end
end
  i = Field.new
  i.field_boundary
loop do
  #management

  i.render

  sleep(1)

end