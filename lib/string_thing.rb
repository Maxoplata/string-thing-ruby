class StringThing
    def initialize(pattern = ['split-halves', 'reverse', 'shift', 'swap-case', 'rotate'])
        patternOpMap = {
            'split-halves' => '0',
            'reverse' => '1',
            'shift' => '2',
            'swap-case' => '3',
            'rotate' => '4',
        }

        patternString = pattern.map { |op| patternOpMap[op] }.join('')

		errorChecks.each do |error|
            if patternString.include? error['match']
                raise "Error: #{error['description']}"
            end
        end

        @opFunctionMap = opFunctionMap
		@pattern = pattern;
    end

    def encode(text)
        @pattern.reduce(text) { |newText, op| @opFunctionMap.key?(op) ? opFunctionMap[op].call(newText, false) : newText }
    end

    def decode(text)
        @pattern.reduce(text) { |newText, op| @opFunctionMap.key?(op) ? opFunctionMap[op].call(newText, true) : newText }
    end

    private

    def opFunctionMap
        {
            'split-halves' => lambda { |text, decode = false| text[(decode ? (text.length.to_f / 2).floor : (text.length.to_f / 2).ceil)..-1] + text[0..(decode ? ((text.length.to_f / 2).floor - 1) : ((text.length.to_f / 2).ceil - 1))] },
            'reverse' => lambda { |text, _| text.reverse },
            'shift' => lambda { |text, decode = false| shift(text, !decode ? 1 : -1) },
            'swap-case' => lambda { |text, _| text.chars.map { |c| c == c.upcase ? c.downcase : c.upcase }.join },
            'rotate' => lambda { |text, decode = false| !decode ? text[-1] + text[0..-2] : text[1..-2] + text[0] },
        }
    end

    def shift(text, shift = 1)
        chars = (0..94).map { |i| (i + 32).chr }

        chars_max_index = chars.length - 1

        text.chars.map do |char|
            index = chars.index(char)

            if index
                new_index = index + shift

                if new_index > chars_max_index
                    chars[new_index - chars_max_index - 1]
                elsif new_index < 0
                    chars[chars_max_index + new_index + 1]
                else
                    chars[new_index]
                end
            else
                char
            end
        end.join('')
    end

    def errorChecks
		[
			{
				'description' => "Using 'split-halves' back-to-back results in the original string",
				'match' => '00',
			},
			{
				'description' => "Using 'reverse' back-to-back results in the original string",
				'match' => '11',
			},
			{
				'description' => "Using 'shift' 95 times results in the original string. Using 'shift' more than 95 times is the same as using using it X - 95 times.",
				'match' => '2' * 95,
			},
			{
				'description' => "Using 'swap-case' back-to-back results in the original string",
				'match' => '33',
			},
		];
    end
end
