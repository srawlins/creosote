# Adapted from ahoward's https://gist.github.com/2819359
# Uses Gist
class Tee < ::Array
  def initialize(*handles)
    @handles = handles
  end

  def << value
    super
  ensure
    @handles.each do |h|
      begin
        h << value if h
      rescue e
        $stderr.puts "Caught #{e} while appending to #{h}..."
      end
    end
  end
end
