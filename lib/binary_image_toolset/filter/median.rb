module BinaryImageToolset
  module Filter
    class Median
      def initialize(frame, radius: 3)
        @frame = frame
        @radius = radius
        @radius += 1 if @radius.even?
      end

      def perform
        filtered = []
        (@frame.height).times do |y|
          (@frame.width).times do |x|
            filtered[y] = [] if filtered[y].nil?
            filtered[y][x] = median_value(@frame.crop_by_radius(x, y, @radius).flatten)
          end
        end
        filtered
      end

      private

      def median_value(arr)
        arr.sort[arr.length / 2]
      end
    end
  end
end
