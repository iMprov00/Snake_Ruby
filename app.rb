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
        when :up then @y = -1 
        when :down then @y = 1
        when :left then @x = -1
        when :right then @x = 1
      end
    end

    prompt.read_keypress == 'q' ? "Конец игры" : true #если нажали q то завершить игру
  end #конец метода
end

#========================================================= класс игровых объектов (змейка, яблоко)
class Game_objects #класс игровые объекты. идет как абстрактный класс для змейки и еды 

  attr_accessor :y, :x #переменные для определения позиции

  def initialize #инициализиурем дефолтную позицию при создании объекта
    default_position
  end

  def default_position #определяем начальную позицию
    @x = 1
    @y = 1
  end #конец метода

  def position(options={}) #определяем позицию на поле
      y = options[:y] || 0
      x = options[:x] || 0
      column = options[:column] || 0

      y = @y + y.to_i #присваием внутренней переменной значение текущее положение объекта + переданный параметр с клавиатуры (управление)
      x = @x + x.to_i

      if y <= 0 || y >= (column - 1) || x <= 0 || x >= (column - 1) #провеярем, не выходит ли значение за границы карты
        
      else #если не выходит, то присваием публичным переменным значения
        @y = y
        @x = x
      end
  end #конец метода
end #конец класса

class Snake < Game_objects #класс змейки
  def label #метод объявляющий как выглядит змейка
    "@"
  end #конец метода
end

class Food < Game_objects #класс еды

  def position(options={})
      column = options[:column] || 0

      @y = rand(1..(column - 1))
      @x = rand(1..(column - 1))

  end

  def label
    "*"
  end #конец метода
end

#========================================================= класс поля
class Field #класс "поле"
  attr_reader :row, :column, :field #переменные для поля. столбцы, строки и сам массив (поле)
  attr_accessor :y, :x #переменные для определения позиции (вероятно стоит убрать)

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

  def render(options={})#отрисовываем поле 
    snake_label = options[:snake_label] || 0
    snake_x = options[:snake_x] || 0
    snake_y = options[:snake_y] || 0

    food_label = options[:food_label] || 0
    food_x = options[:food_x] || 0
    food_y = options[:food_y] || 0

    puts "\e[H\e[2J" #очищаем экран

    0.upto((@column - 1)) do |column| 
      0.upto((@row - 1)) do |row|
        if row == snake_x && column == snake_y
          print snake_label
        else
          print @field[column][row]
        end 
      end
      puts
    end
  end #конец метода

end

#========================================================= класс статистики

class Game_statistics

  def statistics(options={})
    size_field = options[:size_field] || 0
    score = options[:score] || 0

    stat = "Статистика:\nРазмер поля #{size_field} на #{size_field}\nСчет: #{score}"
  end #конец метода

end #конец класса

field = Field.new #создаем объект класса "поле"
keybord = Game_management.new
snake = Snake.new
food = Food.new
params_food ={column: field.column}
food.position

stat = Game_statistics.new 

loop do
  params_field = {snake_label: snake.label, snake_x: snake.x, snake_y: snake.y}
  field.render(params_field) #рисуем поле на экране терминала

  puts

  params_stat = {size_field: field.row}
  puts stat.statistics(params_stat)

  keybord.management #ждет ввод с клавиатуры пользователем. передаем это в метод    

  params_keybord = {x: keybord.x, y: keybord.y, column: field.column}
  snake.position(params_keybord) #передаем змейке ввод пользователем, то есть передаем указания куда ей пойти
end