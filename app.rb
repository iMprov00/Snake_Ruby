require 'tty-prompt' #библиотека для управления событиями нажатия с клавиатуры

#========================================================= управление игрой


class Game_management

  attr_reader :y, :x

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
  end #конец метода
end

#========================================================= класс игровых объектов (змейка, яблоко)
class Game_objects

  attr_accessor :y, :x

  def initialize
    default_position
  end

  def default_position
    @x = 1
    @y = 1
  end #конец метода

  def position(y, x, column)
      y = @y + y.to_i
      x = @x + x.to_i

      if y <= 0 || y >= (column - 1) || x <= 0 || x >= (column - 1)
        
      else
        @y = y
        @x = x
      end
  end #конец метода
end #конец класса

class Snake < Game_objects
  def label
    "@"
  end #конец метода
end

class Food < Game_objects
  def label
    "*"
  end #конец метода
end

#========================================================= класс поля
class Field #класс "поле"
  attr_reader :row, :column, :field #переменные для поля. столбцы, строки и сам массив (поле)
  attr_accessor :y, :x

  def initialize
    default_row_column
    size_field #создаем массив, который будет полем
    field_boundary #сразу присваиваем границы поля в массиве
    default_position
  end #конец метода

  def default_row_column
    @row = 12 #количество столбцов 
    @column = 12 #количество строк
  end #конец метода

  def default_position
    @x = 1
    @y = 1
  end #конец метода

  def size_field #размер поля, состоящий из массива
    @field = Array.new(@row){|i| Array.new(@column){" "}}
  end #конец метода

  def field_boundary #присваиваем гринцы полю
    # Верхняя и нижняя границы
    0.upto(@row - 1) { |j| @field[0][j] = "-" }       # первая строка
    0.upto(@row - 1) { |j| @field[@column - 1][j] = "-" }  # последняя строка

    # Левая и правая границы
    1.upto(@column - 2) { |i| @field[i][0] = "|" }       # первый столбец
    1.upto(@column - 2) { |i| @field[i][@row - 1] = "|" }  # последний столбец
  end #конец метода

  def render(label, x, y)#отрисовываем поле 
    puts "\e[H\e[2J" #очищаем экран

    0.upto((@column - 1)) do |column|
      0.upto((@row - 1)) do |row|
        if row == x && column == y
          print label
        else
          print @field[column][row]
        end 
      end
      puts
    end
  end #конец метода

end

field = Field.new #создаем объект класса "поле"
keybord = Game_management.new
snake = Snake.new

loop do
  field.render(snake.label, snake.x, snake.y) #рисуем поле на экране терминала

  keybord.management

  snake.position(keybord.x, keybord.y, field.column)
end