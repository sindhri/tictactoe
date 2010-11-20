require "pp"

module TicTacToe
  class Board
    PositionOccupiedError = Class.new(StandardError)
    OutOfBoundsError = Class.new(StandardError)
    
    def initialize
      @data = [[nil,nil,nil],[nil,nil,nil],[nil,nil,nil]]
    end

    def [](row,col)
      @data[row][col]
    end
    
    def []=(row,col,value)
      raise OutOfBoundsError      if [2,row,col].max > 2
      raise PositionOccupiedError if @data[row][col]
      
      @data[row][col] = value 
    end
    
    def rows
      @data
    end
    
    def columns
      @data.transpose
    end
    
    def diagonals
      [[self[0,0], self[1,1], self[2,2]],
       [self[0,2], self[1,1], self[2,0]]]
    end
    
    def lines
      rows + columns + diagonals
    end
    
    def to_s
      rows.map { |row| row.map { |e| e || "*" }.join(" | ") }.join("\n")
    end
  end
  
  class Game
    def initialize
      @board        = TicTacToe::Board.new
      @symbols = ["X","O"].cycle
      new_turn
    end
    
    attr_reader :board, :current_symbol
    
    def move(row,col)
      @board[row,col] = @current_symbol
    end
    
    def new_turn
      @current_symbol = @symbols.next
    end
    
    def finished?
      @board.lines.any? { |line| line.all? { |e| e == @current_symbol } }
    end
  end
  
  module UI
    extend self
    
    def play
      game = TicTacToe::Game.new

      loop do
        puts game.board
        print ">> "
        move = gets.chomp.split(",").map { |e| e.to_i }

        begin
          game.move(*move)
        rescue TicTacToe::Board::OutOfBoundsError
          puts "Out of bounds, try another position"
          next
        rescue TicTacToe::Board::PositionOccupiedError
          puts "There is already a mark in that position"
          next
        end

        if game.finished?
          puts "#{game.current_symbol} wins"
          exit
        end

        game.new_turn
      end 
    end
  end
end

TicTacToe::UI.play

