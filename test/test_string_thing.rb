require "minitest/autorun"
require "string_thing"

class StringThingTest < Minitest::Test
    def setup
        @myString = 'This is my string'
    end

    def test_default_pattern
        myStringThing = StringThing.new
        encoded = myStringThing.encode(@myString)

        assert_equal 'ZN!TJ!TJIuHOJSUT!', encoded
    end

    def test_split_halves
        myStringThing = StringThing.new(['split-halves'])
        encoded = myStringThing.encode(@myString)

        assert_equal 'y stringThis is m', encoded
    end

    def test_reverse
        myStringThing = StringThing.new(['reverse'])
        encoded = myStringThing.encode(@myString)

        assert_equal 'gnirts ym si sihT', encoded
    end

    def test_shift
        myStringThing = StringThing.new(['shift'])
        encoded = myStringThing.encode(@myString)

        assert_equal 'Uijt!jt!nz!tusjoh', encoded
    end

    def test_swap_case
        myStringThing = StringThing.new(['swap-case'])
        encoded = myStringThing.encode(@myString)

        assert_equal 'tHIS IS MY STRING', encoded
    end

    def test_rotate
        myStringThing = StringThing.new(['rotate'])
        encoded = myStringThing.encode(@myString)

        assert_equal 'gThis is my strin', encoded
    end

    def test_shift_shift
        myStringThing = StringThing.new(['shift', 'shift'])
        encoded = myStringThing.encode(@myString)

        assert_equal 'Vjku"ku"o{"uvtkpi', encoded
    end

    def test_rotate_rotate
        myStringThing = StringThing.new(['rotate', 'rotate'])
        encoded = myStringThing.encode(@myString)

        assert_equal 'ngThis is my stri', encoded
    end

    def test_rotate_split_halves_shift_reverse_shift_swap_case_rotate
        myStringThing = StringThing.new(['shift', 'split-halves', 'shift', 'reverse', 'shift', 'swap-case', 'rotate'])
        encoded = myStringThing.encode(@myString)

        assert_equal '|P#VL#VLKwJQLUWV#', encoded
    end

    # Errors

    def test_split_halves_split_halves
        assert_raises(StandardError) {
            StringThing.new(['split-halves', 'split-halves'])
        }
    end

    def test_reverse_reverse
        assert_raises(StandardError) {
            StringThing.new(['reverse', 'reverse'])
        }
    end

    def test_shift_95_times_plus
        assert_raises(StandardError) {
            StringThing.new(Array.new(95, 'shift'))
        }
    end

    def test_swap_case_swap_case
        assert_raises(StandardError) {
            StringThing.new(['swap-case', 'swap-case'])
        }
    end
end
