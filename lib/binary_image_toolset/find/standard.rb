module BinaryImageToolset
  module Find
    class Standard
      def initialize(base_frame:, search_frame:, configs: {})
        @base_frame = base_frame
        @search_frame = search_frame
        configs[:min_match] = 80 unless configs.has_key? :min_match
        configs[:min_overlap] = 50 unless configs.has_key? :min_overlap
        configs[:debug] = false unless configs.has_key? :debug
        @configs = configs
      end

      def perform
        handle
      end

      private

      def handle
        out = []
        generate_compare_jobs.each do |compare_job|
          base_sub_frame = @base_frame.crop(*compare_job[:base])
          search_sub_frame = @search_frame.crop(*compare_job[:search])
          percent = compare(base_sub_frame, search_sub_frame)
          overlap_percent = overlap(@search_frame.frame, search_sub_frame)

          if percent >= @configs[:min_match] && overlap_percent >= @configs[:min_overlap]
            h = { position: compare_job[:base], percent: percent, overlap_percent: overlap_percent }
            h[:debug] = compare_job[:debug] if @configs[:debug]
            out << h
          end
        end

        out
      end

      def overlap(base_frame, frame)
        (((frame&.size.to_f * frame.first&.size.to_f) / (base_frame&.size.to_f * base_frame.first&.size.to_f)) * 100).round
      end

      def compare(base_frame, frame)
        return 0 if base_frame.flatten.size.zero? || base_frame.flatten.size != frame.flatten.size
        same = base_frame.flatten.zip(frame.flatten).select { |a, b| a == b }.size
        (same.to_f / base_frame.flatten.size * 100).round
      end

      def generate_compare_jobs
        jobs = []
        jobs << gcj_edge_row_up
        jobs << gcj_edge_column_left
        jobs << gcj_middle
        jobs << gcj_edge_column_right
        jobs << gcj_edge_row_down
        jobs.flatten!
      end

      def gcj_middle
        jobs = []
        (0..(@base_frame.width - @search_frame.width)).each do |c|
          (0..(@base_frame.height - @search_frame.height)).each do |r|
            jobs << { base: [r, @search_frame.height, c, @search_frame.width], search: [0, @search_frame.height, 0, @search_frame.width], debug: __method__ }
          end
        end
        jobs
      end

      def gcj_edge_row_up
        jobs = []
        (0..(@base_frame.width - @search_frame.width)).each do |c|
          (0..(@search_frame.height - @search_frame.height / 2 - 1)).each do |r|
            jobs << { base: [0, @search_frame.height / 2 + r, c, @search_frame.width], search: [@search_frame.height / 2 - r, @search_frame.height / 2 + r, 0, @search_frame.width], debug: __method__ }
          end
        end
        jobs
      end

      def gcj_edge_row_down
        jobs = []
        (0..(@base_frame.width - @search_frame.width)).each do |c|
          ((@base_frame.height - @search_frame.height + 1)..(@base_frame.height - @search_frame.height / 2)).each do |r|
            jobs << { base: [r, @base_frame.height - r, c, @search_frame.width], search: [0, @base_frame.height - r, 0, @search_frame.width], debug: __method__ }
          end
        end
        jobs
      end

      def gcj_edge_column_left
        jobs = []
        (0..(@search_frame.width - @search_frame.width / 2 - 1)).each do |c|
          (0..(@base_frame.height - @search_frame.height)).each do |r|
            jobs << { base: [r, @search_frame.height, 0, @search_frame.width / 2 + c], search: [0, @search_frame.height, @search_frame.width / 2 - c, @search_frame.width / 2 + c], debug: __method__ }
          end
        end
        jobs
      end

      def gcj_edge_column_right
        jobs = []
        ((@base_frame.width - @search_frame.width + 1)..(@base_frame.width - @search_frame.width / 2)).each do |c|
          (0..(@base_frame.height - @search_frame.height)).each do |r|
            jobs << { base: [r, @search_frame.height, c, @base_frame.width - c], search: [0, @search_frame.height, 0, @base_frame.width - c], debug: __method__ }
          end
        end
        jobs
      end
    end
  end
end
