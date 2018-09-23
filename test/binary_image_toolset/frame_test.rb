require 'test_helper'

class Frame < Minitest::Test
  def setup
    @frame_source = [%w(* * *), %w(* - -), %w(- * -), %w(- - *), %w(- - -)]
    @background_symbol = '-'
    @frame = BinaryImageToolset::Frame.new(@frame_source)
    @frame.background_symbol = @background_symbol
  end

  def test_respond_to
    methods = [:frame, :height, :width, :crop_by_radius, :crop_by_radius!, :crop, :crop!, :filter, :filter!, :erase, :erase!, :create, :create!, :fill, :fill!, :find, :info]
    methods.each do |method|
      assert_respond_to @frame, method
    end
  end

  def test_return_frame
    assert_equal @frame.frame, @frame_source
  end

  def test_return_height
    assert_equal @frame.height, 5
  end

  def test_return_width
    assert_equal @frame.width, 3
  end

  def test_crop_by_radius
    assert_equal @frame.crop_by_radius(1, 1, 1), [%w(* * *), %w(* - -), %w(- * -)]
  end

  def test_crop_by_radius!
    assert_equal @frame.crop_by_radius!(1, 1, 1), @frame.frame
  end

  def test_crop
    assert_equal @frame.crop(0, 3, 0, 3), [%w(* * *), %w(* - -), %w(- * -)]
  end

  def test_crop!
    assert_equal @frame.crop!(0, 3, 0, 3), @frame.frame
  end

  def test_filter
    assert_equal @frame.filter(:median, radius: 1), [%w(* * *), %w(* * -), %w(- - -), %w(- - -), %w(- - -)]
  end

  def test_filter!
    assert_equal @frame.filter!(:median, radius: 1), @frame.frame
  end

  def test_erase
    erase_result = @frame.frame
    erase_result[0] = %w(- - -)
    assert_equal @frame.erase(0, 3, 0, 1), erase_result
  end

  def test_erase!
    assert_equal @frame.erase!(1, 1, 1, 1), @frame.frame
  end

  def test_create
    assert_equal @frame.create(1, 1), [[@background_symbol]]
  end

  def test_create!
    assert_equal @frame.create!(1, 1), @frame.frame
  end

  def test_fill
    fill_result = @frame.frame
    fill_result[4] = %w(* * *)
    assert_equal @frame.fill('*', 3, 1, 0, 3), fill_result
  end

  def test_fill!
    assert_equal @frame.fill!('*', 3, 1, 0, 3), @frame.frame
  end

  def test_find
    search_frame = BinaryImageToolset::Frame.new([%w(* * *)])
    search_result = [
      { position: [0, 1, 0, 2], percent: 100, overlap_percent: 67 },
      { position: [0, 1, 0, 3], percent: 100, overlap_percent: 100 },
      { position: [0, 1, 1, 2], percent: 100, overlap_percent: 67 }
    ]
    assert_equal @frame.find(search_frame, :standard), search_result
    assert_equal @frame.find(search_frame, :standard, { min_overlap: 100 }), [search_result[1]]
  end

  def test_info
    assert_equal @frame.info,  {
      height: 5,
      width: 3
    }
  end
end
