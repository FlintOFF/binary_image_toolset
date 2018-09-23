require 'binary_image_toolset/version'
require 'matrix'

module BinaryImageToolset
  class Frame
    attr_reader :height, :width, :frame
    attr_accessor :background_symbol

    def initialize(frame = [])
      @frame = frame
      update
      @background_symbol = '-'
    end

    def crop_by_radius(x, y, radius)
      window = []
      (y - radius).upto(y + radius).each do |win_y|
        window_y = []
        (x - radius).upto(x + radius).each do |win_x|
          win_x = 0 if win_x < 0
          win_y = 0 if win_y < 0
          win_x = @width - 1 if win_x >= @width
          win_y = @height - 1 if win_y >= @height
          window_y << @frame[win_y][win_x]
        end
        window << window_y
      end
      window
    end

    def crop_by_radius!(x, y, radius)
      @frame = crop_by_radius(x, y, radius)
      update
      @frame
    end

    def crop(x, x_length, y, y_length)
      Matrix[*@frame].minor(x, x_length, y, y_length).to_a
    end

    def crop!(x, x_length, y, y_length)
      @frame = crop(x, x_length, y, y_length)
      update
      @frame
    end

    def filter(filter_name, *filter_params)
      BinaryImageToolset::Filter.const_get(filter_name.capitalize).new(self, *filter_params).perform
    end

    def filter!(filter_name, *filter_params)
      @frame = filter(filter_name, *filter_params)
    end

    def erase(x, x_length, y, y_length)
      fill(@background_symbol, x, x_length, y, y_length)
    end

    def erase!(x, x_length, y, y_length)
      @frame = erase(x, x_length, y, y_length)
    end

    def create(height, width)
      matrix_out = Matrix.build(height, width) do |_row, _column|
        @background_symbol
      end
      matrix_out.to_a
    end

    def create!(height, width)
      @frame = create(height, width)
      update
      @frame
    end

    def fill(symbol, x, x_length, y, y_length)
      matrix_in = Matrix[*@frame]
      matrix_out = Matrix.build(@height, @width) do |row, column|
        if row >= y && row < y + y_length && column >= x && column < x + x_length
          symbol
        else
          matrix_in[row, column]
        end
      end

      matrix_out.to_a
    end

    def fill!(symbol, x, x_length, y, y_length)
      @frame = fill(symbol, x, x_length, y, y_length)
    end

    def find(search_frame, finder_name, finder_params = {})
      BinaryImageToolset::Find.const_get(finder_name.capitalize).new(base_frame: self, search_frame: search_frame, configs: finder_params).perform
    end

    def info
      {
        height: @height,
        width: @width
      }
    end

    private

    def update
      @height = @frame.size.to_i
      @width = @frame.first&.size.to_i
    end
  end
end
