require 'tty-prompt' #библиотека для управления событиями нажатия с клавиатуры

class Game

  attr_accessor :y, :x

  def management #метод "управление"
    prompt = TTY::Prompt.new #объявляем объект класса

    prompt.on(:keypress) do |event| 
      case event.value
        when 'q' then exit
      end
      
      @x = 0
      @y = 0

      case event.key.name
        when :up then @x = -1 
        when :down then @x = 1
        when :left then @y = -1
        when :right then @y = 1
      end
    end

    prompt.read_keypress == 'q' ? "Конец игры" : true #если нажали q то завершить игру
  end
end

class Field #класс "поле"
  attr_reader :row, :column, :field #переменные для поля. столбцы, строки и сам массив (поле)
  attr_accessor :y, :x

  def initialize
    @row = 12 #количество столбцов 
    @column = 12 #количество строк
    size_field #создаем массив, который будет полем
    field_boundary #сразу присваиваем границы поля в массиве
    default_position
  end

  def size_field #размер поля, состоящий из массива
    @field = Array.new(@row){|i| Array.new(@column){" "}}
  end

  def field_boundary #присваиваем гринцы полю
    # Верхняя и нижняя границы
    0.upto(@row - 1) { |j| @field[0][j] = "-" }       # первая строка
    0.upto(@row - 1) { |j| @field[@column - 1][j] = "-" }  # последняя строка

    # Левая и правая границы
    1.upto(@column - 2) { |i| @field[i][0] = "|" }       # первый столбец
    1.upto(@column - 2) { |i| @field[i][@row - 1] = "|" }  # последний столбец
  end

  def default_position
    @x = 1
    @y = 1
  end

  def gamer_label
    "@"
  end

  def postision(x, y)
    @x += x.to_i
    @y += y.to_i
  end

  def render #отрисовываем поле 
    puts "\e[H\e[2J" #очищаем экран

    0.upto((@column - 1)) do |column|
      0.upto((@row - 1)) do |row|
        if row == @x && column == @y
          print gamer_label
           
        else
          print @field[column][row]
        end 
      end
      puts
    end
  end

end
#отладка
  i = Field.new #создаем объект класса "поле"
  m = Game.new

loop do
  i.render #рисуем поле на экране терминала

  m.management

  i.postision(m.y, m.x)

end